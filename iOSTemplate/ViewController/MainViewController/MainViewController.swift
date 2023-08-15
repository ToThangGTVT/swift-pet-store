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

class MainViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageViewController = PagingViewController()
        pageViewController.dataSource = self
        pageViewController.delegate = self

        view.backgroundColor = .white
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.constrainToEdges(pageViewController.view, paddingTop: topbarHeight)
        pageViewController.didMove(toParent: self)
    }
}

extension MainViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 10
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        if index > ListViewPaging.allCases.count - 1 {
            return UIViewController()
        }
        return ListViewPaging.allCases[index].getVC()
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

enum ListViewPaging: CaseIterable {
    case home
    case category
    
    func getVC() -> UIViewController {
        switch(self) {
        case .home:
            return SwinjectStoryboard.defaultContainer.resolve(ListPostViewController.self) ?? UIViewController()
        case .category:
            return SwinjectStoryboard.defaultContainer.resolve(ListPostViewController.self) ?? UIViewController()
        }
    }
}
