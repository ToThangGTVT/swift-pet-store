//
//  ListPostView.swift
//  iOSTemplate
//
//  Created by Thắng Tô on 15/08/2023.
//

import Foundation
import RxSwift
import Alamofire

protocol ListPostViewModelInterface: class {
    func getData(categoryId: Int)
    var posts: Observable<[ListPost]> { get }
    var loadingErrorOccurred: Observable<Error> { get }
}

class ListPostViewModel: BaseViewModel, ListPostViewModelInterface {
    private let _posts = PublishSubject<[ListPost]>()
    private let _loadingErrorOccurred = PublishSubject<Error>()
    
    let posts: Observable<[ListPost]>
    let loadingErrorOccurred: Observable<Error>
    
    override init() {
        self.posts = _posts.asObserver()
        self.loadingErrorOccurred = _loadingErrorOccurred.asObserver()
    }
        
    func getData(categoryId: Int) {
        let parameter: Parameters = [
            "categoryId": categoryId
        ]
        
        var requestData = RequestData(urlPostfix: AppConstant.Api.GET_POST_BY_CATEGORY_ID, method: .get)
        requestData.urlPostfix = AppConstant.Api.GET_POST_BY_CATEGORY_ID
        requestData.method = .get
        requestData.parameters = parameter
        requestData.encoding = URLEncoding.queryString
        
        let observerApi = callApi(requestData: requestData, returnType: [ListPost].self)
            .share()
            .asObservable()
            .materialize()
        
        observerApi.compactMap { $0.element }.bind(to: _posts).disposed(by: disposeBag)
        observerApi.compactMap { $0.error }.bind(to: _loadingErrorOccurred).disposed(by: disposeBag)
    }
}
