// MIT License
//
// Copyright (c) 2019 Anton Yereshchenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class AYAnimatedPresenting: NSObject {
  
  //MARK: - Properties
  let duration: TimeInterval = 0.36
  
}

//MARK: - UIViewControllerAnimatedTransitioning
extension AYAnimatedPresenting: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    
    guard let from = transitionContext.viewController(forKey: .from),
      let to = transitionContext.viewController(forKey: .to) as? AYPullSheetViewController,
      let fromView = from.view,
      let toView = to.view
      else { return }
    
    containerView.addSubview(toView)
    toView.addAllSidesAnchors(to: containerView)
    containerView.bringSubviewToFront(fromView)
    
    to.bottomYBackgroundColorAlpha(duration: duration)
    
    toView.topConstraint?.constant = toView.bounds.height
    toView.layoutIfNeeded()
        
    UIView.animate(withDuration: duration, animations: {
      toView.topConstraint?.constant = to._bottomAppearanceY
      to.containerView?.pullView?.heightConstraint?.constant = AYPullSheetView.height
      toView.layoutIfNeeded()
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
