import Foundation
import OmniFocusTaskIntentKit

@main
struct TaskIntentCLI {
    static func main() async {
        let brief = CommandLine.arguments.dropFirst().joined(separator: " ")
        let modelPayload = TaskPayload(
            title: "Follow up with client",
            notes: "Summarise Apple Intelligence progress",
            dueDate: ISO8601DateFormatter().date(from: "2024-08-01T09:00:00Z"),
            project: "Client Work",
            tags: ["Follow-up", "Email"]
        )
        let generator = TaskJSONGenerator(model: MockLanguageModel(mode: .success(modelPayload)))
        do {
            let payload = try await generator.generatePayload(from: brief.isEmpty ? "Check in on project" : brief)
            _ = try await OmniFocusClient().createTask(from: payload)
        } catch {
            if let data = "Generation failed: \(error)\n".data(using: .utf8) {
                try? FileHandle.standardError.write(contentsOf: data)
            }
            exit(1)
        }
    }
}
