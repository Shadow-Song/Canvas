//
//  DocumentPickerView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import SwiftUI
import UIKit
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeItem as String], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.fileURL = urls.first
        }
    }
}
