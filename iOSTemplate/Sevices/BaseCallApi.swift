//
//  BaseCallApi.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import Alamofire
import RxSwift
import os.log

protocol BaseCallApiInterface: class {
    static func callApi<T: Codable>(requestData: RequestData, returnType: T.Type, completion: @escaping (Observable<T>) -> Void)
}

class BaseCallApi: BaseCallApiInterface {
    static var headers: HTTPHeaders?
    static var isRefreshingToken = false
    static var group = DispatchGroup()
    static var dispatchItem: [DispatchWorkItem] = []
    
    static func callApi<T: Codable>(requestData: RequestData, returnType: T.Type, completion: @escaping (Observable<T>) -> Void) {
        let log = OSLog(subsystem: "com.example.iOSTemplate", category: "\(#function)")
        
        if let _ = UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) ?? "")",
                "Content-Type": "application/json"
            ]
        }
        let urlApi = AppConstant.Api.BASE_URL + requestData.urlPostfix
        let method = requestData.method
        let encoding = requestData.encoding
        let parameters = requestData.parameters
        
        os_log("API: %@.", log: log, type: .debug, urlApi)
        
        guard let urlApi = URL(string: urlApi) else {
            completion(Observable.error(URLError(URLError.Code.badURL)))
            return
        }
        
        AF.request(urlApi, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.httpBody, headers: self.headers).responseDecodable(of: returnType) { response in
            switch response.result {
            case .success(_):
                if let value = response.value {
                    print(value)
                    completion(Observable.just(value))
                } else {
                    completion(Observable.error(AppError.haveNoDataError))
                }
            case .failure(let error):
                os_log("ERROR: %@.", log: log, type: .debug, error.localizedDescription)
                if response.response?.statusCode == 401 {
//                    completion(Observable.error(AppError.unAuthorized))
                    
                    let dwi = DispatchWorkItem {
                        completion(reCallApi(requestData: requestData, returnType: returnType))
                    }
                    dispatchItem.append(dwi)
                    
                    if !isRefreshingToken {
                        isRefreshingToken = true
                        group.enter()
                        
                        callApiRefreshToken().subscribe().disposed(by: DisposeBag())
                        group.notify(queue: .main) {
                            for task in dispatchItem {
                                task.perform()
                            }
                            isRefreshingToken = false
                        }
                    }
                }
//                completion(Observable.error(error))
            }
        }
    }
    
    static func reCallApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T> {
        let log = OSLog(subsystem: "com.example.iOSTemplate", category: "\(#function)")
        if let _ = UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) ?? "")",
                "Content-Type": "application/json"
            ]
        }
        let urlApi = AppConstant.Api.BASE_URL + requestData.urlPostfix
        let method = requestData.method
        let encoding = requestData.encoding
        let parameters = requestData.parameters
        os_log("API: %@.", log: log, type: .debug, urlApi)

        guard let urlApi = URL(string: urlApi) else {
            //            completion(Observable.error(URLError(URLError.Code.badURL)))
            return Observable.error(URLError(URLError.Code.badURL))
        }
        return Observable.create { observer in
            AF.request(urlApi, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.httpBody, headers: self.headers).responseDecodable(of: returnType) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    observer.onNext(value)
                case .failure(let error):
                    os_log("ERROR: %@.", log: log, type: .debug, error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func callApiRefreshToken() -> Observable<Bool> {
        let log = OSLog(subsystem: "com.example.iOSTemplate", category: "\(#function)")
        
        let urlApi = AppConstant.Api.BASE_URL + AppConstant.Api.REFRESH_TOKEN
        os_log("API: %@.", log: log, type: .debug, urlApi)

        guard let urlApi = URL(string: urlApi) else {
            group.leave()
            return Observable.just(false)
        }
        guard let refreshToken = UserDefaults.standard.string(forKey: AppConstant.Authorization.REFRESH_TOKEN) else {
            group.leave()
            return Observable.just(false)
        }
        
        let param: Parameters = [
            "refreshToken" : refreshToken
        ]
        
        return Observable.create { observer in
            AF.request(urlApi, method: .post, parameters: param, encoding: URLEncoding.queryString).responseDecodable(of: LoginEntity.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    UserDefaults.standard.set(value.refreshToken, forKey: AppConstant.Authorization.REFRESH_TOKEN)
                    UserDefaults.standard.set(value.authToken, forKey: AppConstant.Authorization.AUTH_TOKEN)
                    group.leave()
                    observer.onNext(true)
                case .failure(let error):
                    os_log("ERROR: %@.", log: log, type: .debug, error.localizedDescription)
                    group.leave()
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
}
