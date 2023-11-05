//
//  ImageCoordinator.swift
//  HackRPI
//
//  Created by Scott Bauer on 11/4/23.
//

import SwiftUI
import UIKit
import CoreML
import Vision

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var classification: String

    init(isShown: Binding<Bool>, image: Binding<Image?>, classify: Binding<String>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _classification = classify
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        classify(image: unwrapImage)
        isCoordinatorShown = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }

    lazy var classificationRequest: VNCoreMLRequest = {
        let visionModel = try! VNCoreMLModel(for: PlantModel().model)
        let request = VNCoreMLRequest(model: visionModel) { [unowned self] request, _ in
            self.processObservations(for: request)
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()

    func classify(image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: image)!
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)

            try! handler.perform([self.classificationRequest])
        }
    }

    func processObservations(for request: VNRequest) {
        DispatchQueue.main.async {
            let result = request.results?.first as! VNClassificationObservation
            self.classification =  {
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 1
                return "\(result.identifier)"
            }()
            
        }
    }
}

