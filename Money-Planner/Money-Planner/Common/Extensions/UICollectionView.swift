//
//  UICollectionView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/28.
//

import Foundation
import UIKit

extension UICollectionView {
    var currentPage: Int {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = indexPathForItem(at: visiblePoint) else {
            return 0
        }

        return indexPath.item
    }
}
