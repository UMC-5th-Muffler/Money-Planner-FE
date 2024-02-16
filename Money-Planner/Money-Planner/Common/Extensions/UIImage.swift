//
//  UIImage.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/12.
//

import Foundation
import UIKit

//이미지 리사이징
extension UIImage {
  func resizeImage(size: CGSize) -> UIImage {
    let originalSize = self.size
    let ratio: CGFloat = {
        return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                          1 / (size.height / originalSize.height)
    }()

    return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
  }
    
//    func scaled(toHeight: CGFloat) -> UIImage? {
//        let scale = toHeight / self.size.height
//        let newWidth = self.size.width * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
//        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
}
