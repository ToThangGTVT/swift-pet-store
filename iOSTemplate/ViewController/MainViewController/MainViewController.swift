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
    
    var viewModel: MainViewModelInterface?
    let pageViewController = PagingViewController()
    var listCategories: [CategoryEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        pageViewController.dataSource = self

        view.backgroundColor = .white
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.constrainToEdges(pageViewController.view, paddingTop: topbarHeight)
        pageViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getDataCategory()
        viewModel?.categories.subscribe { [weak self] category in
            self?.listCategories = category.element
            self?.pageViewController.reloadData()
            self?.hideIndicator()
        }.disposed(by: disposeBag)
    }
}

extension MainViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return self.listCategories?.count ?? 0
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        if index > ListViewPaging.allCases.count - 1 {
            return UIViewController()
        }
        return ListViewPaging.allCases[index].getVC()
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: self.listCategories?[index].name ?? "")
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
