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
    func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T>
}

class BaseCallApi: BaseCallApiInterface {
    var headers: HTTPHeaders?
    
    func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T> {
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
        print(headers)
        

        guard let urlApi = URL(string: urlApi) else {
            return Observable.error(URLError(URLError.Code.badURL))
        }
                
        return Observable.create { observer in
            print("response.response?.statusCode")
            AF.request(urlApi, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.httpBody, headers: self.headers).responseDecodable(of: returnType) { response in
                print(response.response?.statusCode)
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
            }
            return Disposables.create()
        }
    }
}
