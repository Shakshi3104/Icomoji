//
//  GenmojiText.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//

// https://www.createwithswift.com/enabling-genmoji-in-your-app/
import SwiftUI

#if os(iOS)
import UIKit

struct GenmojiText: UIViewRepresentable {
    @Binding var text: NSAttributedString?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.attributedText = text
        // 2. Enabling editability
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 40)
        
        // 3. Enabling the genmoji creation
        textView.supportsAdaptiveImageGlyph = true
        textView.allowsEditingTextAttributes = true
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update the text view's content if the binding changes
        if let updatedText = text {
            uiView.attributedText = updatedText
        }
    }
}
#endif
