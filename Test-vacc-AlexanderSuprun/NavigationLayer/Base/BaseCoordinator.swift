//
//  BaseCoordinator.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import Foundation

protocol ICoordinator: AnyObject {
    func start()
}

class BaseCoordinator: ICoordinator {
    var childCoordinator: [ICoordinator] = []
    func start() {
    }
    
    func addChild(_ coordinator: ICoordinator) {
        guard !childCoordinator.contains(where: { $0 === coordinator }) else { return }
        childCoordinator.append(coordinator)
    }
     
    func removeChild(_ coordinator: ICoordinator) {
        guard !childCoordinator.isEmpty else { return }
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinator.isEmpty {
            coordinator.childCoordinator.forEach { coordinator.removeChild($0) }
        }
        if let index = childCoordinator.firstIndex(where: { $0 === coordinator }) {
            childCoordinator.remove(at: index)
        }
    }
}
