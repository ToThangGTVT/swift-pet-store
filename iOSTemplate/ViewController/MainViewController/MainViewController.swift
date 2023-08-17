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
    var isReloadData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        pageViewController.dataSource = self

        view.backgroundColor = .white
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.constrainToEdges(pageViewController.view, paddingTop: topbarHeight)
        pageViewController.didMove(toParent: self)
        
        viewModel?.categories.subscribe { [weak self] category in
            self?.listCategories = category.element
            guard let isReloadData = self?.isReloadData else { return }
            if isReloadData {
                self?.pageViewController.reloadMenu()
            } else {
                self?.pageViewController.reloadData()
            }
            self?.hideIndicator()
            self?.isReloadData = true
        }.disposed(by: disposeBag)
        
        viewModel?.loadingErrorOccurred.subscribe { [weak self] error in
            self?.showAlert(message: error.debugDescription)
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getDataCategory()
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
        let vc = ListViewPaging.allCases[index].getVC()
        (vc as? ListPostViewController)?.categoryId = self.listCategories?[index].id
        return vc
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: self.listCategories?[index].name ?? "")
    }
}

enum ListViewPaging: Int, CaseIterable {
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
