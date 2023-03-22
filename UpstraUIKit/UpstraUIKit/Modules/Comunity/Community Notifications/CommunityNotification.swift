//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

public struct CommunityNotification: Equatable, Identifiable {
    
    public struct Actor: Equatable {
        let name: String
        let imageUrl: String
    }
    
    public let id = UUID().uuidString
    public let description: String
    public let userAccessCode: String
    public let verb: Verb
    public let targetType: TargetType
    public let path: String
    public let sourceId: String
    public let imageUrl: String
    public let hasRead: Bool
    public let lastUpdate: Date
    public let actors: [Actor]
}

public extension CommunityNotification {
    enum Verb {
        case post, comment, like
        
        var action: String {
            switch self {
            case .like: return "liked"
            case .comment: return "commented on"
            case .post: return "posted in"
            }
        }
    }
    enum TargetType {
        case community
    }
}

public extension CommunityNotification.Actor {
    static func mock(
        name: String = "London",
        imageUrl: String = ""
    ) -> CommunityNotification.Actor {
        return CommunityNotification.Actor(name: name, imageUrl: imageUrl)
    }
}

extension CommunityNotification {
    static func mock(
        description: String = "",
        userAccessCode: String = "",
        verb: Verb = .like,
        targetType: TargetType = .community,
        path: String = "",
        sourceId: String = "",
        imageUrl: String = "",
        hasRead: Bool = false,
        lastUpdate: Date = Date(),
        actors: [Actor] = [.mock(), .mock(name: "New York"), .mock(name: "Tokyo")]) -> CommunityNotification {
        return CommunityNotification(description: description, userAccessCode: userAccessCode, verb: verb, targetType: targetType, path: path, sourceId: sourceId, imageUrl: imageUrl, hasRead: hasRead, lastUpdate: lastUpdate, actors: actors)
    }
    
    static var mockData: [CommunityNotification] = [
        .mock(verb: .comment),
        .mock(actors: [.mock()]),
        .mock(),
        .mock(verb: .comment, actors: [.mock(name: "Bangkok"), .mock(name: "Sydney")]),
        .mock(actors: [
            .mock(name: "Cairo"),
            .mock(name: "Los Angeles"),
            .mock(name: "Bogota"),
            .mock(name: "Buenos Aires"),
            .mock(name: "Rome")]),
        .mock(),
        .mock(verb: .comment)
    ]
}
