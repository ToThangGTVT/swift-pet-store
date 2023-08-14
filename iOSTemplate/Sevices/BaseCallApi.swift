//
//  BaseCallApi.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import Alamofire
import RxSwift

protocol BaseCallApiInterface: class {
    func callApi<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T?>
}

class BaseCallApi: BaseCallApiInterface {
    var headers: HTTPHeaders?
    
    func callApi<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, type: T.Type) -> Observable<T?> {
        
        if let _ = UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: AppConstant.Authorization.AUTH_TOKEN) ?? "")",
                "Content-Type": "application/json"
            ]
        }

        guard let url = URL(string: url) else {
            return Observable.error(URLError(URLError.Code.badURL))
        }
                
        return Observable.create { observer in
            AF.request(url, method: method, parameters: parameters, headers: self.headers).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(_):
                    observer.onNext(response.value)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
