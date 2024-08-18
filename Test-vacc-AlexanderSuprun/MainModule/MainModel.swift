//
//  MainModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import Foundation

struct Category: Decodable {
    let id : Int
    let title : String
    let required: Bool
    let tappedOnSelectAll: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case required
        case tappedOnSelectAll = "tapped_on_select_all"
    }
}
