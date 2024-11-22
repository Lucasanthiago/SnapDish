import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var savedRecipes: [Recipe]
    @Environment(\.dismiss) var dismiss
    private let mlProcessor = MLProcessor(modelName: "FoodClassificator 1") // Substitua pelo nome do modelo

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.mlProcessor?.classify(image: image) { identifiedIngredient in
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true) {
                            if let ingredient = identifiedIngredient {
                                self.parent.showRecipeSelection(for: ingredient)
                            }
                        }
                    }
                }
            } else {
                picker.dismiss(animated: true)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    private func showRecipeSelection(for ingredient: String) {
        DispatchQueue.main.async {
            let recipeListView = RecipeListView(
                ingredient: ingredient,
                onRecipeSelected: { recipe in
                    savedRecipes.append(recipe)
                    dismiss()
                }
            )
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(UIHostingController(rootView: recipeListView), animated: true)
            }
        }
    }
}
