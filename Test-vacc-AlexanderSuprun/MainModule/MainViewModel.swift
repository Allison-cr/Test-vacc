//
//  MainViewModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import Foundation

protocol IMainViewModel: AnyObject {
    func loadData()
}

final class MainViewModel: IMainViewModel {
    weak var viewController: IMainViewController?

    func loadData() {
        let model = MokData().category()
        viewController?.viewReady(model: model)
    }
}
