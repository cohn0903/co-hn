import Foundation

public struct TaskJSONGenerator<Model: TaskLanguageModel & Sendable>: Sendable {
    public enum GeneratorError: Error {
        case emptyBrief
        case validationFailed(Error)
    }

    public var model: Model
    public var promptTemplate: PromptTemplate
    public var enableRepair: Bool

    public init(model: Model, promptTemplate: PromptTemplate = .default, enableRepair: Bool = true) {
        self.model = model
        self.promptTemplate = promptTemplate
        self.enableRepair = enableRepair
    }

    public func generatePayload(from brief: String) async throws -> TaskPayload {
        guard !brief.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw GeneratorError.emptyBrief
        }

        let prompt = promptTemplate.render(brief: brief)
        let request = TaskLanguageModelRequest(prompt: prompt)
        do {
            let response = try await model.complete(request)
            return try TaskPayload(decodingJSON: response.output)
        } catch {
            return try await attemptRepair(prompt: prompt, invalidJSON: error)
        }
    }

    private func attemptRepair(prompt: String, invalidJSON error: Error) async throws -> TaskPayload {
        guard enableRepair else {
            throw error
        }

        let invalidJSON: String
        if let payloadError = error as? TaskPayloadError, case let .decodingFailed(underlying) = payloadError,
           let decodingError = underlying as? DecodingError {
            invalidJSON = decodingError.failureReason ?? "<unknown>"
        } else {
            invalidJSON = String(describing: error)
        }

        let repairRequest = TaskLanguageModelRepairRequest(
            priorPrompt: prompt,
            invalidJSON: invalidJSON,
            errorDescription: "JSON did not match TaskPayload schema"
        )
        let repairResponse = try await model.repair(repairRequest)
        return try TaskPayload(decodingJSON: repairResponse.output)
    }
}
