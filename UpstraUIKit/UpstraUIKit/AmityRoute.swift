//
//  AmityRoute.swift
//  
//
//  Created by Matias Crespillo on 9/7/22.
//

import Foundation
import UIKit

public enum AmityRoute: Equatable {
    case explore
    case post(id: String)
    case community(id: String)
    case none
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
        case .post(let id):
            if let postVC =  rootController.navigationController?.viewControllers.first(where: { vc in
                    (vc as? AmityPostDetailViewController)?.postId
                        .map({ $0 == id }) ?? false
                }) {
                rootController.navigationController?.popToViewController(postVC, animated: true)
            } else {
                AmityEventHandler.shared.postDidtap(from: rootController, postId: id)
            }
        case .community(let id):
            AmityEventHandler.shared.communityDidTap(from: rootController, communityId: id)
        case .none:
            return
        }
        self.pendingRoute = .none
    }
}
