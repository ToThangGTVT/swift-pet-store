//
//  PetViewModel.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import RxSwift

protocol PetViewModelInterface: class {
    func getData() -> Observable<[Pet]>
}

class PetViewModel: PetViewModelInterface {
    
    var networkService: BaseCallApiInterface?
        
    func getData() -> Observable<[Pet]> {
        let observerApi = networkService?.getData(url: "https://petstore.swagger.io/v2/pet/findByStatus?status=available", type: [Pet].self)
        guard let observerApi = observerApi else { return Observable.error(Error.self as! Error)}
        return observerApi.flatMap { obVal -> Observable<[Pet]> in
            if let obVal = obVal {
                return Observable.just(obVal)
            } else {
                return Observable.error(Error.self as! Error)
            }
        }
    }
}
