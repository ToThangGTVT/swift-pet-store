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
    var disposeBag = DisposeBag()
    
    final func baseCallApi<T: Codable>(requestData: RequestData, returnType: T.Type, completion: @escaping (Observable<T>) -> Void) {
        completion(self.callApi(requestData: requestData, returnType: returnType))
    }
    
    final func callApi<T: Codable>(requestData: RequestData, returnType: T.Type) -> Observable<T> {
        let apiObserver = PublishSubject<T>()
        BaseCallApi.callApi(requestData: requestData, returnType: returnType) { observer in
            observer.bind(to: apiObserver).disposed(by: self.disposeBag)
        }
        return apiObserver
    }
}
