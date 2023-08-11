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
    func getData<T: Codable>(url: String, type: T.Type) -> Observable<T?>
}

class BaseCallApi: BaseCallApiInterface {

    func getData<T: Codable>(url: String, type: T.Type) -> Observable<T?> {
        guard let url = URL(string: url) else {
            return Observable.error(URLError(URLError.Code.badURL))
        }
                
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: T.self) { response in
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
