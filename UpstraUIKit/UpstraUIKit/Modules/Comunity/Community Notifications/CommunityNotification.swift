//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

struct CommunityNotification: Identifiable {
    
    struct Actor {
        let id: String
        let name: String
        let imageUrl: String
    }
    
    let id = UUID().uuidString
    let description: String
    let networkId: String
    let userId: String
    let verb: Verb
    let targetType: TargetType
    let targetId: String
    let targetGroup: Int
    let imageUrl: String
    let hasRead: Bool
    let lastUpdate: Date
    let actors: [Actor]
}

extension CommunityNotification {
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

extension CommunityNotification.Actor {
    static func mock(name: String = "France",
                     imageUrl: String = "") -> CommunityNotification.Actor {
        return CommunityNotification.Actor(id: "id", name: name, imageUrl: imageUrl)
    }
}

extension CommunityNotification {
    static func mock(description: String = "",
                     networkId: String = "",
                     userId: String = "",
                     verb: Verb = .like,
                     targetType: TargetType = .community,
                     targetId: String = "",
                     targetGroup: Int = 1,
                     imageUrl: String = "",
                     hasRead: Bool = false,
                     lastUpdate: Date = Date(),
                     actors: [Actor] = [.mock(name: "france"), .mock(name: "spain")]) -> CommunityNotification {
        return CommunityNotification(description: description, networkId: networkId, userId: userId, verb: verb, targetType: targetType, targetId: targetId, targetGroup: targetGroup, imageUrl: imageUrl, hasRead: hasRead, lastUpdate: lastUpdate, actors: actors)
    }
    
    static var mockData: [CommunityNotification] = [.mock(verb: .comment, actors: [.mock(), .mock(), .mock()]),
                                                    .mock(actors: [.mock()]),
                                                    .mock(),
                                                    .mock(),
                                                    .mock(actors: [.mock(), .mock(), .mock(), .mock(), .mock()]),
                                                    .mock(),
                                                    .mock()]
    
}
