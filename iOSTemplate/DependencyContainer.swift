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
            container.storyboardInitCompleted(MainViewController.self) { resolve, vc in
                vc.viewMode = resolve.resolve(PetViewModelInterface.self)
            }
        }
    }
    
    class DependencyAssembly : Assembly {
        func assemble(container: Swinject.Container) {
            container.register(PetViewModelInterface.self) { resolver in
                let viewModel = PetViewModel()
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

