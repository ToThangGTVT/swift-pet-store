//
//  LoginViewController.swift
//  iOSTemplate
//
//  Created by ThangTQ on 14/08/2023.
//

import Foundation
import RxSwift
import Alamofire

protocol LoginViewModelInterface: class {
    func submitLogin(username: String, password: String) -> Observable<Bool>
}

class LoginViewModel: LoginViewModelInterface {

    var networkService: BaseCallApiInterface?
    
    func submitLogin(username: String, password: String) -> Observable<Bool>{
        let parameters = [
            "username": username,
            "password": password
        ]
        
        let apiObsever = networkService?.callApi(url: "https://setdanh.io.vn/api/login", method: .post, parameters: parameters , type: LoginEntity.self)
        guard let apiObsever = apiObsever else { return Observable.error(AppError.customError)}

        return apiObsever.flatMap { val -> Observable<Bool> in
            if let _ = val?.refreshToken,  let _ = val?.authToken {
                return Observable.just(true)
            }
            return Observable.just(false)
        }
    }

}
