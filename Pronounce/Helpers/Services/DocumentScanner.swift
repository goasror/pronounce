//
//  DocumentScanner.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import VisionKit
import AVFoundation

struct DocumentScanner: UIViewControllerRepresentable {
    var onFinish: ([UIImage]) -> Void
    var onCancel: () -> Void

    // MARK: - Static Permission Checker
    /// Handles the logic of checking and requesting camera access
    static func prepareScanner(completion: @escaping (Bool) -> Void) {
        // 1. Check if the device even supports Document Scanning (hardware check)
        guard VNDocumentCameraViewController.isSupported else {
            print("Document scanning is not supported on this device.")
            completion(false)
            return
        }

        // 2. Check Camera Authorization
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        default:
            // Denied or Restricted
            completion(false)
        }
    }

    // MARK: - Representable Methods
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish, onCancel: onCancel)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var onFinish: ([UIImage]) -> Void
        var onCancel: () -> Void

        init(onFinish: @escaping ([UIImage]) -> Void, onCancel: @escaping () -> Void) {
            self.onFinish = onFinish
            self.onCancel = onCancel
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = (0..<scan.pageCount).map { scan.imageOfPage(at: $0) }
            onFinish(images)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            onCancel()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            onCancel()
        }
    }
}
