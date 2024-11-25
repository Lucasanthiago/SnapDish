import SwiftUI

struct HomeView: View {
    @State private var savedRecipes: [Recipe] = []
    @State private var showingCamera = false

    var body: some View {
        NavigationView {
            VStack {
                if savedRecipes.isEmpty {
                    Text("Nenhuma receita salva ainda.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(savedRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
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
                        .onDelete(perform: deleteRecipe)
                    }
                }

                Button(action: {
                    showingCamera = true
                }) {
                    Text("Adicionar Receita")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showingCamera) {
                    CameraView(savedRecipes: $savedRecipes)
                }
            }
            .navigationTitle("Receitas Salvas")
        }
    }

    private func deleteRecipe(at offsets: IndexSet) {
        savedRecipes.remove(atOffsets: offsets)
    }
}
