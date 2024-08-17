//
//  MainViewController.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit

protocol IMainViewController: AnyObject {
    func viewReady(model: [Category])
}


final class MainViewController: UIViewController {
    
    private let  viewModel: MainViewModel

    private var elements = MokData().category()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController: IMainViewController {
    func viewReady(model: [Category]) {
        elements = model
    }
}
