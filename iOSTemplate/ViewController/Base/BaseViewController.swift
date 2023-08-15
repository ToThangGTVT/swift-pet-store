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
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }

        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
    }
}
