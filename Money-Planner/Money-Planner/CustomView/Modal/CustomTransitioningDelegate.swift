//
//  CustomTransitioningDelegate.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/25/24.
//

import Foundation
import UIKit

class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        // Return the custom presentation controller
        return CustomPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
