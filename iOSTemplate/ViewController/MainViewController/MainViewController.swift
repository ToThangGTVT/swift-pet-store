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

class MainViewController: BaseViewController {
    var viewModel: MainViewModelInterface?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PetTableCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getData()
        bindView()
    }
    
    func bindView() {
        viewModel?.posts.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: PetTableCell.self)) { index, element, cell in
            cell.title.text = element.category?.name
        }.disposed(by: disposeBag)
        
        viewModel?.loadingErrorOccurred.subscribe(onNext: ({ [weak self] error in
            guard let loginVC = SwinjectStoryboard.defaultContainer.resolve(LoginViewController.self) else { return }
            if (error as? AppError) == AppError.unAuthorized {
                self?.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            self?.showAlert(message: error.localizedDescription)
        })).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as? PetTableCell
            let vc = DetailPetViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.title = cell?.title.text
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)

    }
}

