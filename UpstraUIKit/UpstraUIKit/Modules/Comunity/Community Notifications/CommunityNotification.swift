//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

public struct CommunityNotification: Equatable, Identifiable, Codable {
    
    public struct Actor: Equatable, Codable {
        let name: String
        let imageUrl: String
        let userAccessCode: String
    }
    
    public let id: String
    public let description: String
    public let userAccessCode: String
    public let sourceType: SourceType
    public let path: String
    public let sourceId: String
    public let imageUrl: String
    public var hasRead: Bool
    public let lastUpdate: Date
    public let actors: [Actor]
}

public extension CommunityNotification {
    enum SourceType: Codable {
        case post, comment, community
    }
}

public extension CommunityNotification.Actor {
    static func mock(
        name: String = "London",
        imageUrl: String = "",
        userAccessCode: String = ""
    ) -> CommunityNotification.Actor {
        return CommunityNotification.Actor(
            name: name,
            imageUrl: imageUrl,
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
        lastUpdate: Date = Date(),
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
            lastUpdate: lastUpdate,
            actors: actors
        )
    }
    
    static var mockData: [CommunityNotification] = [
        .mock(sourceType: .comment),
        .mock(actors: [.mock()]),
        .mock(),
        .mock(
            sourceType: .comment,
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
        .mock(sourceType: .comment)
    ]
}

public struct NotificationTrayUser: Codable {
    let userAccessCode: String
    let lastViewed: String
}

