//
//  MainViewModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import RxSwift
import RxCocoa

protocol IMainViewModel: AnyObject {
    func loadData()
}

final class MainViewModel: IMainViewModel {
    weak var coordinator: MainCoordinator?
    private weak var viewController: IMainViewController?

    let dataSubject = PublishSubject<[Category]>()
    
    func loadData() {
        let model = MokData().category()
        dataSubject.onNext(model)
    }
    
    func goNext() {
        coordinator?.runDetailScreen()
    }
}
