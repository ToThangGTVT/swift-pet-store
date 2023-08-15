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
    func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding?, type: T.Type) -> Observable<T>
}

extension BaseCallApiInterface {
    func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T> {
        return callApi(urlPostfix: urlPostfix, method: method, parameters: parameters, encoding: nil, type: type)
    }
}

class BaseCallApi: BaseCallApiInterface {
    var headers: HTTPHeaders?
    
    func callApi<T: Codable>(urlPostfix: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding? = nil, type: T.Type) -> Observable<T> {
        let log = OSLog(subsystem: "com.example.iOSTemplate", category: "\(#function)")
        
        if let _ = UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) ?? "")",
                "Content-Type": "application/json"
            ]
        }
        let urlApi = AppConstant.Api.BASE_URL + urlPostfix
        os_log("==================================", log: log, type: .debug)
        os_log("API: %@.", log: log, type: .debug, urlApi)

        guard let urlApi = URL(string: urlApi) else {
            return Observable.error(URLError(URLError.Code.badURL))
        }
                
        return Observable.create { observer in
            AF.request(urlApi, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.httpBody, headers: self.headers).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(_):
                    if let value = response.value {
                        observer.onNext(value)
                    } else {
                        observer.onError(AppError.haveNoDataError)
                    }
                case .failure(let error):
                    os_log("ERROR: %@.", log: log, type: .debug, error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        observer.onError(AppError.unAuthorized)
                    }
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
