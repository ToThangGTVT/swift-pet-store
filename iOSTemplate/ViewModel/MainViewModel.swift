//
//  PetViewModel.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import RxSwift

protocol MainViewModelInterface: class {
    func getData()
    var posts: Observable<[PostEntity]> { get }
    var loadingErrorOccurred: Observable<Error> { get }
}

class MainViewModel: BaseViewModel, MainViewModelInterface {
    private let _posts = PublishSubject<[PostEntity]>()
    private let _loadingErrorOccurred = PublishSubject<Error>()
    
    let posts: Observable<[PostEntity]>
    let loadingErrorOccurred: Observable<Error>
    
    override init() {
        self.posts = _posts.asObserver()
        self.loadingErrorOccurred = _loadingErrorOccurred.asObserver()
    }
        
    func getData() {
                
        let observerApi = callApi(urlPostfix: AppConstant.Api.GET_POST, method: .get, parameters: nil, type: [PostEntity].self)
            .share()
            .asObservable()
            .materialize()
        
        observerApi.compactMap { $0.element }.bind(to: _posts).disposed(by: disposeBag)
        observerApi.compactMap { $0.error }.bind(to: _loadingErrorOccurred).disposed(by: disposeBag)
    }
}
