import UIKit

class FadeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransition()
    }
}

class FadeInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
// PopupViewController.swift

// PopupViewController.swift

class PopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to semi-transparent
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Calculate the size of the pop-up (four-fifths of the screen)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let popupWidth = screenWidth * 0.8
        let popupHeight = screenHeight * 0.8
        
        // Calculate the position to center the pop-up
        let popupX = (screenWidth - popupWidth) / 2
        let popupY = (screenHeight - popupHeight) / 2
        
        // Add your ReadMessageViewController as a child view controller
        let readMessageVC = ReadMessageViewController()
        addChild(readMessageVC)
        view.addSubview(readMessageVC.view)
        readMessageVC.didMove(toParent: self)
        
        // Set the frame of the readMessageVC's view
        readMessageVC.view.frame = CGRect(x: popupX, y: popupY, width: popupWidth, height: popupHeight)
    }
}
