//
//  PetViewModel.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import RxSwift

protocol MainViewModelInterface: class {
    func getDataCategory()
    var categories: Observable<[CategoryEntity]> { get }
    var loadingErrorOccurred: Observable<Error> { get }
}

class MainViewModel: BaseViewModel, MainViewModelInterface {
    private let _posts = PublishSubject<[CategoryEntity]>()
    private let _loadingErrorOccurred = PublishSubject<Error>()
    
    let categories: Observable<[CategoryEntity]>
    let loadingErrorOccurred: Observable<Error>
    
    override init() {
        self.categories = _posts.asObserver()
        self.loadingErrorOccurred = _loadingErrorOccurred.asObserver()
    }
        
    func getDataCategory() {
                
        let requestData = RequestData(urlPostfix: AppConstant.Api.GET_CATEGORY, method: .get)
        
        baseCallApi(requestData: requestData, returnType: [CategoryEntity].self) { [self] observer in
            let observerApi = observer.share().asObservable().materialize()
            
            observerApi.compactMap { $0.element }.bind(to: _posts).disposed(by: disposeBag)
            observerApi.compactMap { $0.error }.bind(to: _loadingErrorOccurred).disposed(by: disposeBag)
        }
    }
}
