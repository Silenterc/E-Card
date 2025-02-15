//
//  Container.swift
//  E-Card
//
//  Created by Lukas Zima on 15.02.2025.
//

import Foundation

import Swinject

class AppContainer {
    static let shared = AppContainer()
    
    let container: Container
    
    private init() {
        container = Container()
        
        // Register NavigationCoordinator
        container.register(AppCoordinator.self) { _ in
            AppCoordinator()
        }
        .inObjectScope(.container)
        
        // Register ECardGame with injected dependencies
        container.register(ECardGame.self) { resolver in
            ECardGame(appCoordinator: resolver.resolve(AppCoordinator.self)!)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(T.self)!
    }
}

