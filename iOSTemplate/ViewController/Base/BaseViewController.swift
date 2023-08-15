//
//  BaseViewController.swift
//  iOSTemplate
//
//  Created by Thắng Tô on 15/08/2023.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var baseViewModel: BaseViewModelInterface?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseViewModel?.loadingError401Occurred.subscribe { event in
            print("xxxxxxxxxxxxxxxxx")
        }.disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
