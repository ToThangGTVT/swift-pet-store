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
        
        return apiObserver.retry { [weak self] error in
            return error.flatMapLatest { error -> Observable<Error> in
                if error is AppError, (error as? AppError) != AppError.unAuthorized {
                    return Observable.error(error)
                }
                guard let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN) else {
                    return Observable.error(AppError.unAuthorized)
                }

                return (self?.callRefreshToken(refreshToken: refreshToken)
                    .flatMapLatest { respone -> Observable<Error> in
                        return Observable.error(error)
                    })!
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
        
        return networkService.callApi(urlPostfix: AppConstant.Api.REFRESH_TOKEN, method: .post, parameters: param, encoding: URLEncoding.queryString, type: LoginEntity.self)
    }
    
}
