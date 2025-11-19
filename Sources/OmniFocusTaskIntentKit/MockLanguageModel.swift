import Foundation

/// Simple deterministic model used in unit tests and the CLI demo.
public struct MockLanguageModel: TaskLanguageModel, Sendable {
    public enum Mode: Sendable {
        case success(TaskPayload)
        case echo
        case failure(MockLanguageModelError)
    }

    public var mode: Mode

    public init(mode: Mode) {
        self.mode = mode
    }

    public func complete(_ request: TaskLanguageModelRequest) async throws -> TaskLanguageModelResponse {
        switch mode {
        case let .success(payload):
            return .init(output: (try? payload.encodingJSON()) ?? "{}")
        case .echo:
            let payload = TaskPayload(title: request.prompt, notes: nil)
            return .init(output: (try? payload.encodingJSON()) ?? "{}")
        case let .failure(error):
            throw error
        }
    }

    public func repair(_ request: TaskLanguageModelRepairRequest) async throws -> TaskLanguageModelResponse {
        switch mode {
        case let .success(payload):
            return .init(output: (try? payload.encodingJSON()) ?? "{}")
        case .echo:
            let payload = TaskPayload(title: request.invalidJSON)
            return .init(output: (try? payload.encodingJSON()) ?? "{}")
        case let .failure(error):
            throw error
        }
    }
}

public enum MockLanguageModelError: Error, Sendable {
    case forcedFailure
}
