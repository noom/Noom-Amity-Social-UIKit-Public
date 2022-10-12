//
//  File.swift
//  
//
//  Created by Matias Crespillo on 9/7/22.
//

import Foundation

protocol AmityRootViewController: AmityViewController {
    func canShowExplore() -> Bool
    func showExplore()
    var exitClosure: (() -> Void)? { get }
}
