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
        var ingredientsArray: [String] = []
        for i in 1...20 {
            // Criação segura das chaves para ingredientes e medidas
            guard
                let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)"),
                let measureKey = CodingKeys(stringValue: "strMeasure\(i)")
            else { continue }

            // Decodificação dos valores
            let ingredient = (try? container.decodeIfPresent(String.self, forKey: ingredientKey)?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
            let measure = (try? container.decodeIfPresent(String.self, forKey: measureKey)?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""

            // Ignorar entradas vazias
            if !ingredient.isEmpty {
                let combined = measure.isEmpty ? ingredient : "\(ingredient) - \(measure)"
                ingredientsArray.append(combined)
            }
        }

        // Atribuir os ingredientes ao modelo
        self.ingredients = ingredientsArray

        // Log de depuração para confirmar o armazenamento
        print("Ingredientes armazenados no modelo: \(ingredients)")
    }
}
