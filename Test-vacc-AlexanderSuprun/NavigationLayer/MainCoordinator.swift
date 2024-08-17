//
//  MainCoordinator.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import Foundation
import UIKit

final class MainCoordinator: ICoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        runMainFlow()
    }
    
    func runMainFlow() {
        let viewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
}
