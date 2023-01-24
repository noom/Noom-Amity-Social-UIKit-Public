//
//  AmityPostDetailDeletedTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 22/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityPostDetailDeletedTableViewCell: UITableViewCell, Nibbable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(deletedAt: Date) {
    }
    
    static var height: CGFloat {
        return 0
    }
    
}
