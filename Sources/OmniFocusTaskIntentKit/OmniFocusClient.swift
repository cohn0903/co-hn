import Foundation

public protocol OmniFocusTaskPerforming {
    func createTask(from payload: TaskPayload) async throws -> String
}

#if canImport(AppIntents)
import AppIntents
import Intents

/// Concrete performer that calls the real OmniFocus intent at runtime.
public struct OmniFocusClient: OmniFocusTaskPerforming {
    public init() {}

    public func createTask(from payload: TaskPayload) async throws -> String {
        var intent = AddTaskIntent()
        intent.title = payload.title
        intent.notes = payload.notes
        intent.project = payload.project
        intent.tags = payload.tags
        if let dueDate = payload.dueDate {
            intent.dueDate = Calendar.current.dateComponents(in: .current, from: dueDate)
        }
        try await intent.perform()
        return payload.title
    }
}
#else
/// Linux-friendly placeholder so the CLI and tests can run without the App Intents SDK.
public struct OmniFocusClient: OmniFocusTaskPerforming {
    public init() {}

    public func createTask(from payload: TaskPayload) async throws -> String {
        print("[OmniFocusClient] Would create task: \(try payload.encodingJSON())")
        return payload.title
    }
}
#endif
