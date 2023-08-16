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
    var loadingError401Occurred: Observable<Error> { get }
}

struct RequestData {
    var urlPostfix: String
    var method: HTTPMethod
    var parameters: Parameters?
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding?
}

class BaseViewModel: BaseViewModelInterface {
    var networkService: BaseCallApiInterface?
    var disposeBag = DisposeBag()
    var isCallRefreshToken: Bool = false
    let queue = DispatchQueue(label: "com.example.queue")
    
    private let _loadingError401Occurred = PublishSubject<Error>()
    let loadingError401Occurred: Observable<Error>
    
    init() {
        self.loadingError401Occurred = _loadingError401Occurred
    }
    
    final func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T> {
        
        guard let networkService = networkService else {
            return Observable.error(AppError.nilDependency)
        }
        let dispathGroup = DispatchGroup()

        let apiObserver = networkService.callApi(requestData: requestData, returnType: returnType)
        let catchApiObsever = apiObserver.catch { error in
            if (error as? AppError) ==  AppError.unAuthorized {
                dispathGroup.enter()
                let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN)
                return self.callRefreshToken(refreshToken: refreshToken).flatMap { token in
                    UserDefaults.standard.set(token.authToken, forKey: AppConstant.Authorization.AUTH_TOKEN)
                    dispathGroup.leave()
                    return self.callApi(requestData: requestData, returnType: returnType)
                }.catch { error in
                    throw error
                }
            } else {
                throw error
            }
        }
        
        dispathGroup.wait()

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
