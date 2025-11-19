import XCTest
@testable import OmniFocusTaskIntentKit

final class TaskPayloadTests: XCTestCase {
    func testJSONRoundTrip() throws {
        let payload = TaskPayload(
            title: "Draft keynote",
            notes: "Cover LanguageModel overview",
            dueDate: ISO8601DateFormatter().date(from: "2024-06-01T10:00:00Z"),
            project: "AI",
            tags: ["Writing"],
            attachments: [URL(string: "file:///tmp/outline.md")!]
        )

        let json = try payload.encodingJSON()
        let decoded = try TaskPayload(decodingJSON: json)
        XCTAssertEqual(decoded, payload)
    }

    func testGeneratorUsesTemplate() async throws {
        let mock = MockLanguageModel(mode: .success(TaskPayload(title: "foo")))
        let generator = TaskJSONGenerator(model: mock, promptTemplate: .init(systemInstruction: "Test"))
        let payload = try await generator.generatePayload(from: "Buy milk")
        XCTAssertEqual(payload.title, "foo")
    }
}
