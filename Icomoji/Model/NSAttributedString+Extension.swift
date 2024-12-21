//
//  NSAttributedString+Extension.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//

import Foundation
import UIKit
import SwiftUI

// https://www.createwithswift.com/enabling-genmoji-in-your-app/
extension NSAttributedString {
    func serialize() -> Data? {
        do {
            let rtfData = try self.data(from: NSRange(location: 0, length: self.length),
                                        documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            return rtfData
        } catch {
            print("Error serializing text: \(error)")
            return nil
        }
    }
    
    static func deserialize(data: Data) -> NSAttributedString? {
        do {
            let attributedString = try NSAttributedString(data: data, documentAttributes: nil)
            return attributedString
        } catch {
            print("Error deserializing text: \(error)")
            return nil
        }
    }
    
    // get Genmoji image by AdaptiveImageGlyph
    func getGenmoji() -> UIImage? {
        let range = NSRange(location: 0, length: self.length)
        var image: UIImage?
        
        self.enumerateAttribute(.adaptiveImageGlyph, in: range) { adaptiveImageProvider, range, _ in
            let imageGlyph = (adaptiveImageProvider as? NSAdaptiveImageGlyph)
            
            if let imageGlyph {
                print(imageGlyph.contentDescription)
                
                image = UIImage(data: imageGlyph.imageContent)
            }
        }
        
        return image
    }
    
    // get Emoji string
    func getEmojiString() -> String? {
        if self.string.count == 0 {
            return nil
        }
        return self.string.getEmoji()
    }

}
