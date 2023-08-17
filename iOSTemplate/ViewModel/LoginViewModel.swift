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

class LoginViewModel: BaseViewModel, LoginViewModelInterface {
    
    func submitLogin(username: String, password: String) -> Observable<Bool>{
        let parameters = [
            "username": username,
            "password": password
        ]
        
        var requestData = RequestData(urlPostfix: AppConstant.Api.LOGIN, method: .get)
        requestData.parameters = parameters
        
//        let apiObsever = BaseCallApi.callApi(requestData: requestData, returnType: LoginEntity.self)
//        baseCallApi(requestData: requestData, returnType: LoginEntity.self) { observer in
//            
//        }
//
//        return apiObsever.flatMap { val -> Observable<Bool> in
//            if !val.refreshToken.isEmpty,  !val.authToken.isEmpty {
//                UserDefaults.standard.setValue(val.refreshToken, forKey: AppConstant.Authorization.REFRESH_TOKEN)
//                UserDefaults.standard.setValue(val.authToken, forKey: AppConstant.Authorization.AUTH_TOKEN)
//                return Observable.just(true)
//            }
//            return Observable.just(false)
//        }
        return Observable.just(false)
    }

}
