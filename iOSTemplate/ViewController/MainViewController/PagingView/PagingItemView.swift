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
}
