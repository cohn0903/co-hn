import Foundation

/// Codable representation of the JSON Apple Intelligence produces for OmniFocus.
public struct TaskPayload: Codable, Equatable, Sendable {
    public var title: String
    public var notes: String?
    public var dueDate: Date?
    public var project: String?
    public var tags: [String]?
    public var attachments: [URL]?

    public init(
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil,
        project: String? = nil,
        tags: [String]? = nil,
        attachments: [URL]? = nil
    ) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.project = project
        self.tags = tags
        self.attachments = attachments
    }
}

public extension TaskPayload {
    /// A plain-language schema description that is injected into the LanguageModel prompt.
    static var schemaDescription: String {
        """
        {
          \"title\": \"Required, concise string summarising the task\",
          \"notes\": \"Optional context or checklists\",
          \"dueDate\": \"ISO-8601 date string (yyyy-MM-dd'T'HH:mm:ssZZZZZ)\",
          \"project\": \"Exact OmniFocus project name\",
          \"tags\": [\"Existing OmniFocus tag names\"],
          \"attachments\": [\"file:// URLs pointing to local attachments\"]
        }
        """
    }

    /// Convenience that decodes JSON emitted by the model.
    init(decodingJSON json: String, decoder: JSONDecoder = .taskPayloadDecoder) throws {
        guard let data = json.data(using: .utf8) else {
            throw TaskPayloadError.invalidUTF8
        }
        do {
            self = try decoder.decode(TaskPayload.self, from: data)
        } catch {
            throw TaskPayloadError.decodingFailed(error)
        }
    }

    /// Serialises the payload back into JSON for logging or OmniFocus hand-off.
    func encodingJSON(encoder: JSONEncoder = .taskPayloadEncoder) throws -> String {
        let data = try encoder.encode(self)
        guard let json = String(data: data, encoding: .utf8) else {
            throw TaskPayloadError.invalidUTF8
        }
        return json
    }
}

public enum TaskPayloadError: Error, LocalizedError {
    case invalidUTF8
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidUTF8:
            return "Model response could not be converted to UTF-8."
        case let .decodingFailed(error):
            return "Unable to decode model response: \(error.localizedDescription)"
        }
    }
}

public extension JSONDecoder {
    static var taskPayloadDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

public extension JSONEncoder {
    static var taskPayloadEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }
}
