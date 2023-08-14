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
}

class BaseViewModel: BaseViewModelInterface {
    var networkService: BaseCallApiInterface?
    var disposeBag = DisposeBag()
        
    final func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T> {
        
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }
        let apiObserver = networkService.callApi(urlPostfix: urlPostfix, method: method, parameters: parameters, type: type)
        
        return apiObserver.catch { [weak self] err -> Observable<T> in
            guard let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN) else {
                return Observable.error(AppError.unAuthorized)
            }
            guard let refreshTokenObserver = self?.callRefreshToken(refreshToken: refreshToken) else {
                return Observable.error(AppError.unAuthorized)
            }
            
            return refreshTokenObserver.flatMap { [weak self] loginEntity -> Observable<T> in
                guard let self = self else {
                    return Observable.error(AppError.unAuthorized)
                }
                return self.callApi(urlPostfix: urlPostfix, method: method, parameters: parameters, type: type)
            }
        }
    }
    
    private func callRefreshToken(refreshToken: String) -> Observable<LoginEntity> {
        let param: Parameters = [
            "refreshToken": refreshToken
        ]
        
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }

        return networkService.callApi(urlPostfix: AppConstant.Api.REFRESH_TOKEN, method: .post, parameters: param, type: LoginEntity.self)
    }

}
