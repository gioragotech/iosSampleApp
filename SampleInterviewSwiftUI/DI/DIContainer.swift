//
//  DIContainer.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation

protocol DIContainer {
    func resolve<T>(_ type: T.Type) -> T
}

class DefaultDIContainer: DIContainer {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        services[key] = instance
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        if let factory = services[key] as? () -> T {
            return factory()
        }
        
        if let instance = services[key] as? T {
            return instance
        }
        
        fatalError("Service of type \(type) not registered")
    }
}

// MARK: - DI Setup

extension DefaultDIContainer {
    static func setup() -> DIContainer {
        let container = DefaultDIContainer()
        
        // Register Repository
        container.register(Repository.self) {
            MainRepository(networkActions: NetworkActionsImpl())
        }
        
        
        // You can add more dependencies here as your app grows
        // container.register(SomeOtherService.self) {
        //     DefaultSomeOtherService()
        // }
        
        return container
    }
} 
