//
//  Untitled.swift
//  SnapDish
//
//  Created by Lucas Santos on 22/11/24.
//

import CoreML
import Vision
import UIKit

class MLProcessor {
    private let model: VNCoreMLModel

    init?(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc"),
              let compiledModel = try? MLModel(contentsOf: modelURL),
              let vnModel = try? VNCoreMLModel(for: compiledModel) else {
            return nil
        }
        self.model = vnModel
    }

    func classify(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(nil)
                return
            }
            completion(topResult.identifier) // Nome da classe mais provável.
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(nil)
            }
        }
    }
}
