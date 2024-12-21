//
//  UIImage+Extension.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//
import UIKit

extension UIImage {
    func resize(width: CGFloat, height: CGFloat) -> UIImage {
        let scaledImageSize = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaleImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        return scaleImage
    }
}
