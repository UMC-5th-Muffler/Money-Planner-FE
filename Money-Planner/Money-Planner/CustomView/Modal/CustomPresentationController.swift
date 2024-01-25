import UIKit

class CustomPresentationController: UIPresentationController {

    // MARK: - Properties

    override var frameOfPresentedViewInContainerView: CGRect {
        // Define the size and position of the presented view
        let screenBounds = UIScreen.main.bounds
        let size = CGSize(width: screenBounds.width, height: screenBounds.height * 0.25)
        let origin = CGPoint(x: 0, y: screenBounds.height * 0.75)
        return CGRect(origin: origin, size: size)
    }

    // MARK: - Transition Animation

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // Perform animations or setup when the view is presented
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // Perform animations or cleanup when the view is dismissed
    }
}



