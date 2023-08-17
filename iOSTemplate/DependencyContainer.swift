//
//  DependencyContainer.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    class public func setup() {
        let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
        assembler.apply(assemblies: [
            ViewControllerAssembly(),
            DependencyAssembly(),
            NetworkAssembly(),
        ])
    }
    
    class ViewControllerAssembly : Assembly {
        func assemble(container: Swinject.Container) {
            
            container.register(LoginViewController.self) { resolver in
                let vc = LoginViewController()
                vc.viewModel = resolver.resolve(LoginViewModelInterface.self)
                return vc
            }
                        
            container.register(ListPostViewController.self) { resolver in
                let vc = ListPostViewController()
                vc.viewModel = resolver.resolve(ListPostViewModelInterface.self)
                return vc
            }
            
            container.storyboardInitCompleted(BaseViewController.self) { resolve, vc in
                vc.baseViewModel = resolve.resolve(BaseViewModelInterface.self)
            }
            
            container.storyboardInitCompleted(MainViewController.self) { resolve, vc in
                vc.viewModel = resolve.resolve(MainViewModelInterface.self)
            }

            container.storyboardInitCompleted(LoginViewController.self) { resolve, vc in
                vc.viewModel = resolve.resolve(LoginViewModelInterface.self)
            }
        }
    }
    
    class DependencyAssembly : Assembly {
        func assemble(container: Swinject.Container) {
            container.register(BaseViewModelInterface.self) { resolver in
                let viewModel = BaseViewModel()
                return viewModel
            }.inObjectScope(.container)

            container.register(MainViewModelInterface.self) { resolver in
                let viewModel = MainViewModel()
                return viewModel
            }.inObjectScope(.container)
            
            container.register(ListPostViewModelInterface.self) { resolver in
                let viewModel = ListPostViewModel()
                return viewModel
            }.inObjectScope(.container)
            
            container.register(LoginViewModelInterface.self) { resolver in
                let viewModel = LoginViewModel()
                return viewModel
            }.inObjectScope(.container)
        }
    }

    class NetworkAssembly: Assembly {
        func assemble(container: Swinject.Container) {
            container.register(BaseCallApiInterface.self) { resolve in
                return BaseCallApi()
            }
        }
    }
}

