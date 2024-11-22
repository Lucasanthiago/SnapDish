//
//  CameraView.swift
//  SnapDish
//
//  Created by Lucas Santos on 22/11/24.
//

import SwiftUI
import UIKit

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var items: [Item]
    @Environment(\.dismiss) var dismiss
    private let mlProcessor = MLProcessor(modelName: "FoodClassificator 1") // Substitua pelo nome do seu modelo

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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.mlProcessor?.classify(image: image) { recognizedName in
                    DispatchQueue.main.async {
                        let name = recognizedName ?? "Desconhecido"
                        let newItem = Item(name: name, image: image)
                        self.parent.items.append(newItem)
                        self.parent.dismiss()
                    }
                }
            } else {
                parent.dismiss()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}




