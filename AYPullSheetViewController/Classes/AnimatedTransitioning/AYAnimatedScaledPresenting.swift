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

class AYAnimatedScaledPresenting: NSObject {
  
  //MARK: - Private structs
  private struct AnimationConfiguration {
    static let scaling: (from: CGFloat, to: CGFloat) = (1.0, 0.9)
    static let cornerRadius: (from: CGFloat, to: CGFloat) = (0.0, 16.0)
    static let maskToBounds: Bool = true
  }
  
  //MARK: - Properties
  let duration: TimeInterval = 0.36
  
}

//MARK: - UIViewControllerAnimatedTransitioning
extension AYAnimatedScaledPresenting: UIViewControllerAnimatedTransitioning {
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
    
    let groupAnimation = CAAnimationGroup()
    let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
    
    CATransaction.begin()
    CATransaction.setAnimationTimingFunction(timing)
    scaleAnimation.fromValue = AnimationConfiguration.scaling.from
    scaleAnimation.toValue = AnimationConfiguration.scaling.to
    cornerRadiusAnimation.fromValue = AnimationConfiguration.cornerRadius.from
    cornerRadiusAnimation.toValue = AnimationConfiguration.cornerRadius.to
    groupAnimation.duration = duration
    groupAnimation.animations = [scaleAnimation, cornerRadiusAnimation]
    
    fromView.layer.add(groupAnimation, forKey: "scale")
    fromView.layer.transform = CATransform3DMakeScale(
      AnimationConfiguration.scaling.to,
      AnimationConfiguration.scaling.to,
      AnimationConfiguration.scaling.from)
    fromView.layer.cornerRadius = AnimationConfiguration.cornerRadius.to
    fromView.layer.masksToBounds = AnimationConfiguration.maskToBounds
    CATransaction.commit()
  }
}
