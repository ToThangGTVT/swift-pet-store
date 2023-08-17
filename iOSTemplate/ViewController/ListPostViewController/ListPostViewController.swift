//
//  ListPostViewController.swift
//  iOSTemplate
//
//  Created by ThangTQ on 15/08/2023.
//

import UIKit
import SwinjectStoryboard

class ListPostViewController: BaseViewController {
    
    var viewModel: ListPostViewModelInterface?
    var categoryId: Int?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PetTableCell", bundle: nil), forCellReuseIdentifier: "Cell")
        bindView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let categoryId = categoryId else { return }
        viewModel?.getData(categoryId: categoryId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func bindView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        viewModel?.posts.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: PetTableCell.self)) { index, element, cell in
            cell.bindView(post: element)
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
