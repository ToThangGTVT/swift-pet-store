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
            container.storyboardInitCompleted(BaseViewController.self) { resolve, vc in
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
                viewModel.networkService = resolver.resolve(BaseCallApiInterface.self)
                return viewModel
            }.inObjectScope(.container)

            container.register(MainViewModelInterface.self) { resolver in
                let viewModel = MainViewModel()
                viewModel.networkService = resolver.resolve(BaseCallApiInterface.self)
                return viewModel
            }.inObjectScope(.container)
            container.register(LoginViewModelInterface.self) { resolver in
                let viewModel = LoginViewModel()
                viewModel.networkService = resolver.resolve(BaseCallApiInterface.self)
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

