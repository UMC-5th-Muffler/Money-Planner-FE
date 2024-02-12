//
//  UIImage.swift
//  Money-Planner
//
//  Created by 유철민 on 2/11/24.
//

import Foundation
import UIKit

extension UIImage {
    func scaled(toHeight: CGFloat) -> UIImage? {
        let scale = toHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
