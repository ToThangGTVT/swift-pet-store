//
//  PetViewModel.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import RxSwift

protocol PetViewModelInterface: class {
    func getData()
    var posts: Observable<[PostEntity]> { get }
    var loadingErrorOccurred: Observable<Error> { get }
}

class PetViewModel: PetViewModelInterface {
    private let _posts = PublishSubject<[PostEntity]>()
    private let _loadingErrorOccurred = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    let posts: Observable<[PostEntity]>
    let loadingErrorOccurred: Observable<Error>
    
    var networkService: BaseCallApiInterface?

    init() {
        self.posts = _posts.asObserver()
        self.loadingErrorOccurred = _loadingErrorOccurred.asObserver()
    }
        
    func getData() {
        
        let observerApi = networkService?.callApi(url: "https://setdanh.io.vn/api/post", method: .get, parameters: nil, type: [PostEntity].self)
        
        guard let observerApi = observerApi else { return }
        observerApi.catchError { error in
            // Xử lý lỗi và trả về một Observable hoặc giá trị mặc định
            print("Error occurred: \(error)")
            return Observable.just("Fallback data")
        }

    }
}
