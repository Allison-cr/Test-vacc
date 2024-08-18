//
//  UIView+.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit
import RxSwift
import RxCocoa


class CheckboxButton: UIButton {
    
    // MARK: - Properties
    let title: String
    let required: Bool
    let tappedAll: Bool
    var isChecked: Bool = false
    
    // default state
     let stateTappedOnSelectAll = BehaviorRelay<Bool>(value: false)
     let stateRequired = BehaviorRelay<Bool>(value: false)

    // first monitored states for TappedOnSelectAll
    var isCheckedObservable: Observable<Bool> {
        return stateTappedOnSelectAll.asObservable()
    }
    // second monitored states for Reqired
    var isCheckedObservable2: Observable<Bool> {
        return stateRequired.asObservable()
    }
    

    init(title: String, required: Bool, tappedAll: Bool) {
        self.title = title
        self.required = required
        self.tappedAll = tappedAll
        super.init(frame: .zero)
        setupButton()
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // setup button
    private func setupButton() {
        self.setTitle(title, for: .normal)  
        self.setTitleColor(.black, for: .normal)
        self.setImage(UIImage(systemName: "square"), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        self.tintColor = .black
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        self.isChecked.toggle()
        self.isSelected = self.isChecked
        updateState()
    }
    
    // for uptade 
    func updateState() {
        stateTappedOnSelectAll.accept(tappedAll ? isChecked == tappedAll : true)
        stateRequired.accept(required ?  isChecked == required : true)
    }
    
    func updateState(isChecked: Bool) {
          self.isChecked = isChecked
          self.isSelected = isChecked
          updateState()
      }
}

// bind for changing from outside
extension Reactive where Base: CheckboxButton {
    var isChecked: Binder<Bool> {
        return Binder(self.base) { checkbox, isChecked in
                checkbox.isSelected = isChecked
                checkbox.updateState()
        }
    }
}
