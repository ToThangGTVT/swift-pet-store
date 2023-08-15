//
//  PagingItemView.swift
//  iOSTemplate
//
//  Created by ThangTQ on 15/08/2023.
//

import UIKit
import Parchment

class PagingItemView: PagingItem {
    var identifier: Int = 0
    
    func isEqual(to item: Parchment.PagingItem) -> Bool {
        true
    }
    
    func isBefore(item: Parchment.PagingItem) -> Bool {
        true
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
