//
//  Created by Sergei E. on 01/2/19.
//  (c) 2018 Ambrosus. All rights reserved.
//

import UIKit

class AMINavigationController: UINavigationController, UINavigationControllerDelegate {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return AMINavigationControllerAnimation(operation: operation)
    }
    
}

class AMINavigationControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        
        if operation == .push {
            toViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
            containerView.addSubview(toViewController.view)
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: [.curveEaseOut],
                animations: {
                    toViewController.view.frame = containerView.bounds
                    fromViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width, dy: 0)
                },
                completion: { (finished) in
                    transitionContext.completeTransition(true)
                }
            )
        } else if operation == .pop {
            toViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width, dy: 0.0)
            containerView.addSubview(toViewController.view)
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: [.curveEaseOut],
                animations: {
                    fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.width, dy: 0)
                    toViewController.view.frame = containerView.bounds
                },
                completion: { (finished) in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}
