//
//  MainModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import Foundation

// MARK: - Category

struct Category: Decodable {
    /// Unique id for each checkBox
    let id : Int
    /// CheckBox's title
    let title : String
    /// Flag is checkBox required
    let required: Bool
    /// Flag is checkBox tap on select All
    let tappedOnSelectAll: Bool
    
    /// enum for decode to camelCase
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case required
        case tappedOnSelectAll = "tapped_on_select_all"
    }
}
