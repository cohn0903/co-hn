#if canImport(AppIntents)
import AppIntents

/// The App Intent Shortcuts calls to create a new OmniFocus task via Apple Intelligence.
public struct CreateTaskIntent: AppIntent {
    public static var title: LocalizedStringResource = "Create OmniFocus Task"

    @Parameter(title: "Task Brief", description: "Short natural language description to turn into a task.")
    public var taskBrief: String

    public init(taskBrief: String = "") {
        self.taskBrief = taskBrief
    }

    public func perform() async throws -> some IntentResult {
        let generator = TaskJSONGenerator(model: LanguageModel.system)
        let payload = try await generator.generatePayload(from: taskBrief)
        let title = try await OmniFocusClient().createTask(from: payload)
        return .result(value: "Created \(title)")
    }
}
#endif
