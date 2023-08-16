//
//  BaseViewModal.swift
//  iOSTemplate
//
//  Created by Thắng Tô on 14/08/2023.
//

import Foundation
import Alamofire
import RxSwift

protocol BaseViewModelInterface: class {
    func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T>
}

struct RequestData {
    var urlPostfix: String
    var method: HTTPMethod
    var parameters: Parameters?
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding?
}

struct StatusRefreshToken {
    var isRefreshingToken: Bool = false
}

class BaseViewModel: BaseViewModelInterface {
    var networkService: BaseCallApiInterface?
    var disposeBag = DisposeBag()
    var isCallRefreshToken: Bool = false
    let queue = DispatchQueue(label: "com.example.queue")
    let group = DispatchGroup()
    static var isRefreshToken: Bool = false
    static var isWaitingRefreshToken: Bool = false
    
    final func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T> {
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }

        let apiObserver = networkService.callApi(requestData: requestData, returnType: returnType)
        
        let catchApiObsever = apiObserver.catch { error in
            if (error as? AppError) ==  AppError.unAuthorized {
                if BaseViewModel.isRefreshToken == false {
                    self.group.enter()
                    BaseViewModel.isWaitingRefreshToken = true
                }
                
                if !BaseViewModel.isWaitingRefreshToken {
                    return self.callApi(requestData: requestData, returnType: returnType)
                }
                BaseViewModel.isRefreshToken = true
                let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN)
                return self.callRefreshToken(refreshToken: refreshToken).observe(on: MainScheduler.instance).flatMap { token in
                    UserDefaults.standard.set(token.authToken, forKey: AppConstant.Authorization.AUTH_TOKEN)
                    if BaseViewModel.isRefreshToken {
                        self.group.leave()
                    }
                   
                    self.group.wait()
                    BaseViewModel.isRefreshToken = false
                    BaseViewModel.isWaitingRefreshToken = false
                    return self.callApi(requestData: requestData, returnType: returnType)
                }.catch { error in
                    throw error
                }
            } else {
                throw error
            }
        }
        return catchApiObsever
    }
    
    private func callRefreshToken(refreshToken: String?) -> Observable<LoginEntity> {
        guard let refreshToken = refreshToken else {
            return Observable.error(AppError.unAuthorized)
        }
        
        let param: Parameters = [
            "refreshToken": refreshToken
        ]
        
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }
        
        var requestData = RequestData(urlPostfix: AppConstant.Api.REFRESH_TOKEN, method: .post)
        requestData.parameters = param
        requestData.encoding = URLEncoding.queryString
        return networkService.callApi(requestData: requestData, returnType: LoginEntity.self)
    }
    
}
