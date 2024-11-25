import Foundation

struct RecipeDetail: Identifiable, Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let instructions: String
    let ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case instructions = "strInstructions"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decodificação segura dos valores principais
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions) ?? "Sem instruções disponíveis."

        // Extração dinâmica de ingredientes e medidas
        var ingredients: [String] = []
        for i in 1...20 {
            guard
                let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)"),
                let measureKey = CodingKeys(stringValue: "strMeasure\(i)")
            else {
                continue
            }

            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let measure = try container.decodeIfPresent(String.self, forKey: measureKey)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            // Adicionar ingrediente somente se houver valores válidos
            if !ingredient.isEmpty || !measure.isEmpty {
                let combined = measure.isEmpty ? ingredient : "\(ingredient) - \(measure)"
                ingredients.append(combined)
            }
        }

        self.ingredients = ingredients
    }
}
