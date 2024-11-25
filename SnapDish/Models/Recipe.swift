//
//  Recipe.swift
//  SnapDish
//
//  Created by Lucas Santos on 22/11/24.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: String
    let name: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}


struct RecipeResponse: Decodable {
    let meals: [Recipe]?
}




