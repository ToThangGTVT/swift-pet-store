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
    func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T>
    var loadingError401Occurred: Observable<Error> { get }
}

class BaseViewModel: BaseViewModelInterface {
    var networkService: BaseCallApiInterface?
    var disposeBag = DisposeBag()
    
    private let _loadingError401Occurred = PublishSubject<Error>()
    let loadingError401Occurred: Observable<Error>
    
    init() {
        self.loadingError401Occurred = _loadingError401Occurred
    }
    
    final func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T> {
        
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }
        let apiObserver = networkService.callApi(urlPostfix: urlPostfix, method: method, parameters: parameters, type: type)
        
        return apiObserver.catch { error in
            if (error as? AppError) ==  AppError.unAuthorized {
                let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN)
                return self.callRefreshToken(refreshToken: refreshToken).flatMap { token in
                    UserDefaults.standard.set(token.authToken, forKey: AppConstant.Authorization.AUTH_TOKEN)
                    return self.callApi(urlPostfix: urlPostfix, method: method, parameters: parameters, type: type)
                }.catch { error in
                    throw error
                }
            } else {
                throw error
            }
        }
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
        
        return networkService.callApi(urlPostfix: AppConstant.Api.REFRESH_TOKEN, method: .post, parameters: param, encoding: URLEncoding.queryString, type: LoginEntity.self)
    }
    
}
