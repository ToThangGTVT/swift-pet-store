//
//  MainViewController.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwinjectStoryboard
import Parchment

class MainViewController: PagingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.register(PagingIndexItem, for: PagingIndexItem.s)
        
        self.dataSource = self
        self.delegate = self
        self.select(index: 0)
    }
}

extension MainViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 10
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return ListPostViewController()
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "View \(index)")
    }
}

extension MainViewController: PagingViewControllerDelegate {
    func pagingViewController(_: Parchment.PagingViewController, isScrollingFromItem currentPagingItem: Parchment.PagingItem, toItem upcomingPagingItem: Parchment.PagingItem?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
        
    }
    
    func pagingViewController(_: Parchment.PagingViewController, willScrollToItem pagingItem: Parchment.PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        
    }
    
    func pagingViewController(_ pagingViewController: Parchment.PagingViewController, didScrollToItem pagingItem: Parchment.PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        
    }
    
    func pagingViewController(_ pagingViewController: Parchment.PagingViewController, didSelectItem pagingItem: Parchment.PagingItem) {
        
    }

}
