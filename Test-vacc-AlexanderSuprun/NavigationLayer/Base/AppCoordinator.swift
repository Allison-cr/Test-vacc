//
//  AppCoordinator.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
     
    // MARK: Main navigation flow
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.start()
    }
}
