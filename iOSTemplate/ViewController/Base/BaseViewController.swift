//
//  BaseViewController.swift
//  iOSTemplate
//
//  Created by Thắng Tô on 15/08/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
