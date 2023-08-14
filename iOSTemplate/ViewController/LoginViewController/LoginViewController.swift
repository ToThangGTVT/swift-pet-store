//
//  LoginViewController.swift
//  iOSTemplate
//
//  Created by ThangTQ on 14/08/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var viewModel: LoginViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginAction(_ sender: Any) {
        
    }
}
