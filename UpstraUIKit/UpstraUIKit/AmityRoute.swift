//
//  AmityRoute.swift
//  
//
//  Created by Matias Crespillo on 9/7/22.
//

import Foundation
import UIKit

public enum AmityRoute: Equatable {
    private enum QueryItemName {
        static let routeType = "routeType"
        static let postId = "postId"
        static let communityId = "communityId"
        static let userId = "userId"
        static let commentId = "commentId"
    }

    case explore
    case post(id: String)
    case postFromCommunity(communityId: String, postId: String)
    case postFromUser(userId: String, postId: String)
    case community(id: String)
    case user(id: String)
    case commentFromCommunity(communityId: String, postId: String, commentId: String)
    case commentFromUser(userId: String, postId: String, commentId: String)
    
    case none

    // Utility meethod to init from query parameters
    public init?(from queryItems: [String: String]) {
        guard let routeType = queryItems[QueryItemName.routeType] else {
            return nil
        }

        switch routeType {
        case "explore":
            self = .explore
        case "post":
            guard let postId = queryItems[QueryItemName.postId] else {
                return nil
            }
            self = .post(id: postId)
        case "postFromCommunity":
            guard let postId = queryItems[QueryItemName.postId],
                  let communityId = queryItems[QueryItemName.communityId] else {
                return nil
            }
            self = .postFromCommunity(communityId: communityId, postId: postId)
        case "postFromUser":
            guard let postId = queryItems[QueryItemName.postId],
                  let userId = queryItems[QueryItemName.userId] else {
                return nil
            }
            self = .postFromUser(userId: userId, postId: postId)
        case "community":
            guard let communityId = queryItems[QueryItemName.communityId] else {
                return nil
            }
            self = .community(id: communityId)
        case "user":
            guard let userId = queryItems[QueryItemName.userId] else {
                return nil
            }
            self = .user(id: userId)
        case "commentFromCommunity":
            guard let commentId = queryItems[QueryItemName.commentId],
                  let postId = queryItems[QueryItemName.postId],
                  let communityId = queryItems[QueryItemName.communityId] else {
                return nil
            }
            self = .commentFromCommunity(communityId: communityId, postId: postId, commentId: commentId)
        case "commentFromUser":
            guard let commentId = queryItems[QueryItemName.commentId],
                  let postId = queryItems[QueryItemName.postId],
                  let userId = queryItems[QueryItemName.userId] else {
                return nil
            }
            self = .commentFromUser(userId: userId, postId: postId, commentId: commentId)
        case "none":
            self = .none
        default:
            return nil
        }
    }

    public var deeplinkQueryItems: [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: self.routeType, value: QueryItemName.routeType)
        ]
        switch self {
        case .explore:
            break
        case .post(let postId):
            queryItems.append(URLQueryItem(name: QueryItemName.postId, value: postId))
        case .postFromCommunity(let communityId, let postId):
            queryItems.append(URLQueryItem(name: QueryItemName.postId, value: postId))
            queryItems.append(URLQueryItem(name: QueryItemName.communityId, value: communityId))
        case .postFromUser(let userId, let postId):
            queryItems.append(URLQueryItem(name: QueryItemName.postId, value: postId))
            queryItems.append(URLQueryItem(name: QueryItemName.userId, value: userId))
        case .community(let communityId):
            queryItems.append(URLQueryItem(name: QueryItemName.communityId, value: communityId))
        case .user(let userId):
            queryItems.append(URLQueryItem(name: QueryItemName.userId, value: userId))
        case .commentFromCommunity(let communityId, let postId, let commentId):
            queryItems.append(URLQueryItem(name: QueryItemName.postId, value: postId))
            queryItems.append(URLQueryItem(name: QueryItemName.communityId, value: communityId))
            queryItems.append(URLQueryItem(name: QueryItemName.commentId, value: commentId))
        case .commentFromUser(let userId, let postId, let commentId):
            queryItems.append(URLQueryItem(name: QueryItemName.postId, value: postId))
            queryItems.append(URLQueryItem(name: QueryItemName.userId, value: userId))
            queryItems.append(URLQueryItem(name: QueryItemName.commentId, value: commentId))
        case .none:
            break
        }
        return queryItems
    }

    private var routeType: String {
        switch self {
        case .explore:
            return "explore"
        case .post:
            return "post"
        case .postFromCommunity:
            return "postFromCommunity"
        case .postFromUser:
            return "postFromUser"
        case .community:
            return "community"
        case .user:
            return "user"
        case .commentFromCommunity:
            return "commentFromCommunity"
        case .commentFromUser:
            return "commentFromUser"
        case .none:
            return "none"
        }
    }

    public func webURL(baseURL: URL) -> URL? {
        switch self {
        case .none:
            return nil
        case .explore:
            return baseURL.appendingPathComponent("explore")
        case .post:
            return nil
        case .postFromCommunity(let communityId, let postId):
            return baseURL.appendingPathComponent("community/\(communityId)/post/\(postId)")
        case .postFromUser(let userId, let postId):
            return baseURL.appendingPathComponent("user/\(userId)/post/\(postId)")
        case .community(let communityId):
            return baseURL.appendingPathComponent("community/\(communityId)")
        case .user(let userId):
            return baseURL.appendingPathComponent("user/\(userId)")
        case .commentFromCommunity(let communityId, let postId, let commentId):
            return baseURL.appendingPathComponent("community/\(communityId)/post/\(postId)/comment/\(commentId)")
        case .commentFromUser(userId: let userId, postId: let postId, commentId: let commentId):
            return baseURL.appendingPathComponent("user/\(userId)/post/\(postId)/comment/\(commentId)")
        }
    }
}

class AmityRouter {
    var rootController: AmityRootViewController?
    var pendingRoute: AmityRoute {
        didSet {
            if canRoute {
                maybeRoute()
            }
        }
    }

    var canRoute: Bool {
        didSet {
            if canRoute {
                maybeRoute()
            }
        }
    }

    init() {
        rootController = nil
        pendingRoute = .none
        canRoute = false
    }

    func maybeRoute() {
        guard let rootController = rootController else {
            return
        }
        switch pendingRoute {
        case .explore:
            if rootController.canShowExplore() {
                rootController.navigationController?.popToViewController(rootController, animated: true)
                rootController.showExplore()
            }
        case .post(let postId),
                .postFromCommunity(_, let postId),
                .postFromUser(_, let postId),
                .commentFromCommunity(_, let postId, _),
                .commentFromUser(_, let postId, _):
            if let postVC =  rootController.navigationController?.viewControllers.first(where: { vc in
                    (vc as? AmityPostDetailViewController)?.postId
                        .map({ $0 == postId }) ?? false
                }) {
                rootController.navigationController?.popToViewController(postVC, animated: true)
            } else {
                AmityEventHandler.shared.postDidtap(from: rootController, postId: postId)
            }
        case .community(let id):
            AmityEventHandler.shared.communityDidTap(from: rootController, communityId: id)
        case .none:
            return
        case .user(let userId):
            AmityEventHandler.shared.userDidTap(from: rootController, userId: userId)
        }
        self.pendingRoute = .none
    }
}
