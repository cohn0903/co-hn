import Foundation

/// Abstraction over Apple Intelligence's `LanguageModel` so the package remains testable on Linux.
public protocol TaskLanguageModel: Sendable {
    func complete(_ request: TaskLanguageModelRequest) async throws -> TaskLanguageModelResponse
    func repair(_ request: TaskLanguageModelRepairRequest) async throws -> TaskLanguageModelResponse
}

/// Minimal representation of the JSON-format completion request.
public struct TaskLanguageModelRequest: Sendable {
    public struct Format: Sendable {
        public static let json = Format()
    }

    public var prompt: String
    public var format: Format

    public init(prompt: String, format: Format = .json) {
        self.prompt = prompt
        self.format = format
    }
}

/// Follow-up request asking the model to fix invalid JSON.
public struct TaskLanguageModelRepairRequest: Sendable {
    public var priorPrompt: String
    public var invalidJSON: String
    public var errorDescription: String

    public init(priorPrompt: String, invalidJSON: String, errorDescription: String) {
        self.priorPrompt = priorPrompt
        self.invalidJSON = invalidJSON
        self.errorDescription = errorDescription
    }
}

public struct TaskLanguageModelResponse: Sendable {
    public var output: String

    public init(output: String) {
        self.output = output
    }
}

#if canImport(Intelligence)
import Intelligence

extension LanguageModel: TaskLanguageModel {
    public func complete(_ request: TaskLanguageModelRequest) async throws -> TaskLanguageModelResponse {
        let response = try await complete(.init(prompt: request.prompt, format: .json()))
        return TaskLanguageModelResponse(output: response.output)
    }

    public func repair(_ request: TaskLanguageModelRepairRequest) async throws -> TaskLanguageModelResponse {
        let response = try await repair(.init(
            prompt: request.priorPrompt,
            response: request.invalidJSON,
            format: .json(),
            errorDescription: request.errorDescription
        ))
        return TaskLanguageModelResponse(output: response.output)
    }
}
#endif
