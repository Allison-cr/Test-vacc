//
//  DataLoader.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 18.08.2024.
//

import Foundation

class DataLoader {
    static func loadCategories() -> [Category]? {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("Не удалось найти файл JSON")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let categories = try JSONDecoder().decode([Category].self, from: data)
            return categories
        } catch {
            print("Ошибка загрузки или декодирования данных: \(error)")
            return nil
        }
    }
}
