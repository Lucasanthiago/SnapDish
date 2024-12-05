import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var recipeDetail: RecipeDetail?
    @State private var loading = true
    @State private var error: String?

    var body: some View {
        Group {
            if loading {
                ProgressView("Carregando detalhes...")
                    .onAppear {
                        fetchRecipeDetails()
                    }
            } else if let error = error {
                Text("Erro ao carregar detalhes: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if let recipeDetail = recipeDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: recipeDetail.thumbnail)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                        }

                        Text(recipeDetail.name)
                            .font(.title)
                            .padding(.bottom, 8)

                        Text("Ingredientes")
                            .font(.headline)

                        // Verifique se os ingredientes estão sendo exibidos
                        if recipeDetail.ingredients.isEmpty {
                            Text("Nenhum ingrediente disponível.")
                        } else {
                            ForEach(recipeDetail.ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                            }
                        }

                        Text("Instruções")
                            .font(.headline)
                            .padding(.top, 8)

                        Text(recipeDetail.instructions)
                            .font(.body)
                    }
                    .padding()
                }
            } else {
                Text("Detalhes da receita não encontrados.")
            }
        }
        .navigationTitle(recipe.name)
    }

    private func fetchRecipeDetails() {
        let service = RecipeDetailService()
        service.fetchRecipeDetails(for: recipe.id) { result in
            DispatchQueue.main.async {
                loading = false
                switch result {
                case .success(let detail):
                    recipeDetail = detail
                    print("Ingredientes carregados na view: \(detail.ingredients)") // Log de depuração
                case .failure(let fetchError):
                    error = fetchError.localizedDescription
                    print("Erro ao buscar detalhes: \(fetchError.localizedDescription)")
                }
            }
        }
    }
}
