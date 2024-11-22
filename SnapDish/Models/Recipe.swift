import Foundation
import SwiftUI


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




class RecipeService {
    func fetchRecipes(for ingredient: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let baseUrl = "https://www.themealdb.com/api/json/v1/1/filter.php"
        guard let url = URL(string: "\(baseUrl)?i=\(ingredient)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
                completion(.success(response.meals ?? []))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
