//
//  ImageViewCapture.swift
//  HackRPI
//
//  Created by Scott Bauer on 11/4/23.
//

import SwiftUI
import UIKit



struct CaptureImageView {
    
       @Binding var isShown: Bool
       @Binding var image: Image?
       @Binding var classification: String
       
       func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, classify: $classification)
       }
    
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
    

}

extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
    case .up: self = .up
    case .upMirrored: self = .upMirrored
    case .down: self = .down
    case .downMirrored: self = .downMirrored
    case .left: self = .left
    case .leftMirrored: self = .leftMirrored
    case .right: self = .right
    case .rightMirrored: self = .rightMirrored
    @unknown default:
      fatalError()
    }
  }
}

extension CGImagePropertyOrientation {
  init(_ orientation: UIDeviceOrientation) {
    switch orientation {
    case .portraitUpsideDown: self = .left
    case .landscapeLeft: self = .up
    case .landscapeRight: self = .down
    default: self = .right
    }
  }
}


