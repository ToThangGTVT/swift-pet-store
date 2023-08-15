//
//  LoginViewController.swift
//  iOSTemplate
//
//  Created by ThangTQ on 14/08/2023.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var viewModel: LoginViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let username = textFieldUsername.text else { return }
        guard let password = textFieldPassword.text else { return }
        viewModel?.submitLogin(username: username, password: password).subscribe { event in
            if event.element == true {
                self.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
    }
}
