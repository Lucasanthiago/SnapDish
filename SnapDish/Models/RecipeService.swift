//
//  RecipeService.swift
//  SnapDish
//
//  Created by Lucas Santos on 25/11/24.
//
import Foundation

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
                let response = try JSONDecoder().decode([String: [Recipe]].self, from: data)
                completion(.success(response["meals"] ?? []))
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
