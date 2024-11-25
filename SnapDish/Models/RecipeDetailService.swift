import Foundation

class RecipeDetailService {
    func fetchRecipeDetails(for id: String, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
        let baseUrl = "https://www.themealdb.com/api/json/v1/1/lookup.php"
        guard let url = URL(string: "\(baseUrl)?i=\(id)") else {
            print("Erro: URL inválida para ID: \(id)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        print("Requisição para URL: \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro de rede: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Erro: Sem dados retornados pela API.")
                completion(.failure(NetworkError.noData))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Resposta da API: \(jsonString)")
            } else {
                print("Erro: Não foi possível converter os dados em string.")
            }

            do {
                let response = try JSONDecoder().decode([String: [RecipeDetail]].self, from: data)
                if let recipeDetail = response["meals"]?.first {
                    print("Detalhes da receita decodificados com sucesso.")
                    completion(.success(recipeDetail))
                } else {
                    print("Erro: JSON não contém os detalhes esperados.")
                    completion(.failure(NetworkError.noData))
                }
            } catch {
                print("Erro de decodificação: \(error.localizedDescription)")
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
