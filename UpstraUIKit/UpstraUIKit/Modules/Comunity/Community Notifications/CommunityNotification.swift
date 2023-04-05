//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

public struct CommunityNotification: Equatable, Identifiable {
    
    public var id: String
    let description: String
    let userAccessCode: String
    let sourceType: SourceType
    let path: String
    let sourceId: String
    let imageUrl: String
    var hasRead: Bool
    let lastUpdate: Date
    let actors: [Actor]
    
    var postId: NotificationFeature.PostId? {
        guard let rangeOfPostSubstring = path.range(of: "/post/") else { return nil }
        let substring = String(path[rangeOfPostSubstring.upperBound...])
        let value: String
        if let index = substring.firstIndex(of: "/") {
            value = String(substring[substring.startIndex..<index])
        } else {
            value = substring
        }
        return .init(value: value)
    }
}

extension CommunityNotification: Codable {
    enum CodingKeys: String, CodingKey {
        case id, description, userAccessCode, imageUrl, sourceType, path, sourceId, actors
        case hasRead = "read"
        case lastUpdate = "serverTimeUpdated"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        userAccessCode = try container.decode(String.self, forKey: .userAccessCode)
        path = try container.decode(String.self, forKey: .path)
        sourceId = try container.decode(String.self, forKey: .sourceId)
        id = try container.decode(String.self, forKey: .id)
        hasRead = try container.decode(Bool.self, forKey: .hasRead)
        actors = try container.decode([Actor].self, forKey: .actors)
        sourceType = try container.decode(SourceType.self, forKey: .sourceType)
        let lastUpdateString = try container.decode(String.self, forKey: .lastUpdate)
        lastUpdate = DateFormatter.iso8601Full.date(from: lastUpdateString) ?? Date()
        do {
            imageUrl = try container.decode(String.self, forKey: .imageUrl)
        } catch {
            guard try container.decode(String.self, forKey: .imageUrl) == "" else { throw error }
            imageUrl = "defaultString"
        }
    }
}

public extension CommunityNotification {
    
    struct Actor: Equatable, Codable {
        let name: String
        let avatarUrl: String
        let userAccessCode: String
    }
    
    enum SourceType: String, Codable {
        case post = "POST"
        case comment = "COMMENT"
        case community = "COMMUNITY"
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            if let sourceType = SourceType(rawValue: rawString) {
                self = sourceType
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot initialize UserType from invalid String value \(rawString)")
            }
        }
    }
}

#if DEBUG
public extension CommunityNotification.Actor {
    static func mock(
        name: String = "London",
        avatarUrl: String = "",
        userAccessCode: String = ""
    ) -> CommunityNotification.Actor {
        return CommunityNotification.Actor(
            name: name,
            avatarUrl: avatarUrl,
            userAccessCode: userAccessCode
        )
    }
}

extension CommunityNotification {
    static func mock(
        id: String = UUID().uuidString,
        description: String = "",
        userAccessCode: String = "",
        sourceType: SourceType = .community,
        path: String = "",
        sourceId: String = "",
        imageUrl: String = "",
        hasRead: Bool = false,
        lastUpdate: String = "2023-03-27T16:07:02.299474Z",
        actors: [Actor] = [
            .mock(),
            .mock(name: "New York"),
            .mock(name: "Tokyo")
        ]
    ) -> CommunityNotification {
        return CommunityNotification(
            id: id,
            description: description,
            userAccessCode: userAccessCode,
            sourceType: sourceType,
            path: path,
            sourceId: sourceId,
            imageUrl: imageUrl,
            hasRead: hasRead,
            lastUpdate: DateFormatter.iso8601Full.date(from: lastUpdate) ?? Date(),
            actors: actors
        )
    }
    
    static var mockData: [CommunityNotification] = [
        .mock(sourceType: .post),
        .mock(actors: [.mock()]),
        .mock(),
        .mock(
            sourceType: .post,
            actors: [
                .mock(name: "Bangkok"),
                .mock(name: "Sydney")
            ]
        ),
        .mock(actors: [
            .mock(name: "Cairo"),
            .mock(name: "Los Angeles"),
            .mock(name: "Bogota"),
            .mock(name: "Buenos Aires"),
            .mock(name: "Rome")]),
        .mock(),
        .mock(sourceType: .post)
    ]
}
#endif
