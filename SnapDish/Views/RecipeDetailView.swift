import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }

            Text(recipe.name)
                .font(.title)
                .padding()

            Spacer()
        }
        .navigationTitle("Detalhes")
        .padding()
    }
}
