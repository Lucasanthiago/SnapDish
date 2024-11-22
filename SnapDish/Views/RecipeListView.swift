import SwiftUI

struct RecipeListView: View {
    let ingredient: String
    let onRecipeSelected: (Recipe) -> Void

    @State private var recipes: [Recipe] = []
    @State private var loading = true
    @State private var error: String?

    var body: some View {
        Group {
            if loading {
                ProgressView("Carregando...")
            } else if let error = error {
                Text("Erro: \(error)")
            } else {
                List(recipes) { recipe in
                    Button(action: {
                        onRecipeSelected(recipe)
                    }) {
                        HStack {
                            AsyncImage(url: URL(string: recipe.thumbnail)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }

                            Text(recipe.name)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchRecipes()
        }
        .navigationTitle("Receitas com \(ingredient)")
    }

    private func fetchRecipes() {
        let service = RecipeService()
        service.fetchRecipes(for: ingredient) { result in
            DispatchQueue.main.async {
                loading = false
                switch result {
                case .success(let fetchedRecipes):
                    recipes = fetchedRecipes
                case .failure(let fetchError):
                    error = fetchError.localizedDescription
                }
            }
        }
    }
}
