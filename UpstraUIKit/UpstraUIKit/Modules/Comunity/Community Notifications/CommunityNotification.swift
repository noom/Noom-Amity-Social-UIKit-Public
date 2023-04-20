//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

public struct CommunityNotification: Equatable, Identifiable {
    
    public let id: String
    let description: String
    let userAccessCode: String
    let sourceType: SourceType
    let path: String
    let imageUrl: URL?
    let lastUpdate: Date
    let actors: [Actor]
    let hasRead: Bool

    public struct PostID: Equatable {
        let value: String
    }

    var postId: PostID? {
        let pathRange = NSRange(path.startIndex ..< path.endIndex, in: path)
        let captureRegex = try? NSRegularExpression(pattern: "/post/(?<postId>[a-zA-Z0-9]+)")
        let matches = captureRegex?.matches(in: path, options: [], range: pathRange) ?? []
        return matches.lazy
            .map { $0.range(withName: "postId") }
            .last { $0.location != NSNotFound }
            .flatMap { Range($0, in: path).map { PostID(value: String(path[$0])) } }
    }
}

extension CommunityNotification: Codable {
    enum CodingKeys: String, CodingKey {
        case id, description, userAccessCode, imageUrl, sourceType, path, actors
        case hasRead = "read"
        case lastUpdate = "serverTimeUpdated"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        userAccessCode = try container.decode(String.self, forKey: .userAccessCode)
        path = try container.decode(String.self, forKey: .path)
        hasRead = (try? container.decode(Bool.self, forKey: .hasRead)) ?? false
        actors = (try? container.decode([Actor].self, forKey: .actors)) ?? []
        sourceType = (try? container.decode(SourceType.self, forKey: .sourceType)) ?? .unknown
        let lastUpdateString = try? container.decode(String.self, forKey: .lastUpdate)
        lastUpdate = lastUpdateString.flatMap { ISO8601DateFormatter.iso8601Full.date(from: $0) } ?? Date()
        imageUrl = (try? container.decode(String.self, forKey: .imageUrl)).flatMap(URL.init)
    }
}

public extension CommunityNotification {
    
    struct Actor: Equatable, Codable {
        let name: String
        let avatarUrl: String
        let userAccessCode: String
    }
    
    enum SourceType: String, Codable {
        case unknown = "UNKNOWN"

        case post = "POST"
        case comment = "COMMENT"
        case community = "COMMUNITY"
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
        imageUrl: URL? = nil,
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
            imageUrl: imageUrl,
            lastUpdate: ISO8601DateFormatter.iso8601Full.date(from: lastUpdate) ?? Date(),
            actors: actors,
            hasRead: hasRead
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
