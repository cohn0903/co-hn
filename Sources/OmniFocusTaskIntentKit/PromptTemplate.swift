import Foundation

/// Simple helper that formats the instructions given to Apple Intelligence.
public struct PromptTemplate: Sendable, Equatable {
    public var systemInstruction: String
    public var schema: String

    public init(systemInstruction: String? = nil, schema: String = TaskPayload.schemaDescription) {
        self.systemInstruction = systemInstruction ?? Self.defaultSystemInstruction
        self.schema = schema
    }

    public func render(brief: String) -> String {
        """
        \(systemInstruction)

        Schema:
        \(schema)

        Respond with JSON only.

        User brief:
        \(brief)
        """
    }
}

public extension PromptTemplate {
    static let `default` = PromptTemplate()

    private static let defaultSystemInstruction = "You turn short descriptions into OmniFocus tasks."
}
