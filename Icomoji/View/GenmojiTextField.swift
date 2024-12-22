//
//  GenmojiTextField.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//

// https://www.createwithswift.com/enabling-genmoji-in-your-app/
import SwiftUI
import UIKit

struct GenmojiTextField: UIViewRepresentable {
    @Binding var text: NSAttributedString?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.attributedText = text
        // Enabling editability
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        
        // Enabling the genmoji creation
        textView.supportsAdaptiveImageGlyph = true
        textView.allowsEditingTextAttributes = true
        
        textView.delegate = context.coordinator
        
        // Initialize with the current text if available
        if let initialText = text {
            textView.attributedText = initialText
        }

        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText != text {
            uiView.attributedText = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: GenmojiTextField
        
        init(_ parent: GenmojiTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Update the binding
            if let currentText = textView.attributedText {
                parent.text = currentText
            }
        }
    }
}
