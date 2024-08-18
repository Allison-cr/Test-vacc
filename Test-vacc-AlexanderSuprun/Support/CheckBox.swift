//
//  UIView+.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit
import RxSwift
import RxCocoa


// MARK: - CheckboxButton

/// The `CheckboxButton` class represents a custom checkbox button that allows users
/// to toggle its selection state, with support for reactive programming using RxSwift.
class CheckboxButton: UIButton {
    
    // MARK: - Properties
    
    let title: String
    let required: Bool
    let tappedAll: Bool
    var isChecked: Bool = false
    
    let stateTappedOnSelectAll = BehaviorRelay<Bool>(value: false)
    let stateRequired = BehaviorRelay<Bool>(value: false)

    // MARK: - Initializers
       
    /// Initializes a checkbox button with the specified title, required status, and select-all status.
    /// - Parameters:
    ///   - title: The text to be displayed next to the checkbox.
    ///   - required: Indicates whether the checkbox is required.
    ///   - tappedAll: Indicates whether the checkbox should be selected when the "select all" option is toggled.
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
    
    // MARK: - Setup Methods
    
    /// Sets up the button's appearance and actions.
    private func setupButton() {
        self.setTitle(title, for: .normal)  
        self.setTitleColor(.black, for: .normal)
        self.setImage(UIImage(systemName: "square"), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        self.tintColor = .black
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: Margins.spacing, bottom: 0, right: -Margins.spacing)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
       
    /// Handles the button tap, toggling its selection state.
    @objc private func buttonTapped() {
        self.isChecked.toggle()
        self.isSelected = self.isChecked
        updateState()
    }
    
    // MARK: - State Update Methods
      
    /// Updates the state of the button with an animation.
    func updateState() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.stateTappedOnSelectAll.accept(self.tappedAll ? self.isChecked == self.tappedAll : true)
            self.stateRequired.accept(self.required ? self.isChecked == self.required : true)
            self.setImage(self.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
        })
    }
    
    /// Updates the state of the button with the option to set its checked state explicitly.
    /// - Parameter isChecked: Sets the button's checked state (selected/unselected).
    func updateState(isChecked: Bool) {
          self.isChecked = isChecked
          self.isSelected = isChecked
          updateState()
      }
}

// MARK: - Reactive Extensions
/// Reactive extension for integrating with RxSwift, enabling reactive binding for the `isChecked` state.
extension Reactive where Base: CheckboxButton {
    var isChecked: Binder<Bool> {
        return Binder(self.base) { checkbox, isChecked in
                checkbox.isSelected = isChecked
                checkbox.updateState()
        }
    }
}
