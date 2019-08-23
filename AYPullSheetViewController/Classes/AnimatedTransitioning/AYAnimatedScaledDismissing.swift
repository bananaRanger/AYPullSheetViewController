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

class AYAnimatedScaledDismissing: NSObject {
  
  //MARK: - Private structs
  private struct AnimationConfiguration {
    static let delay: TimeInterval = 0
    static let colorKeyframe: (startTime: Double, duration: Double) = (0, 1)
    static let positionKeyframe: (startTime: Double, duration: Double) = (0, 0.5)
    
    static let scaling: (from: CGFloat, to: CGFloat) = (0.9, 1.0)
    static let cornerRadius: (from: CGFloat, to: CGFloat) = (16, 0.0)
    static let maskToBounds: Bool = true
  }
  
  //MARK: - Properties
  let duration: TimeInterval = 0.64
  
}

//MARK: - UIViewControllerAnimatedTransitioning
extension AYAnimatedScaledDismissing: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let from = transitionContext.viewController(forKey: .from) as? AYPullSheetViewController,
      let to = transitionContext.viewController(forKey: .to),
      let fromView = from.view,
      let toView = to.view
      else { return }
    
    let animationOptions: UIView.AnimationOptions = .curveEaseOut
    let keyframeAnimationOptions: UIView.KeyframeAnimationOptions = UIView.KeyframeAnimationOptions(rawValue: animationOptions.rawValue)

    UIView.animateKeyframes(
      withDuration: duration,
      delay: AnimationConfiguration.delay,
      options: [keyframeAnimationOptions], animations: {
        
        UIView.addKeyframe(
          withRelativeStartTime: AnimationConfiguration.colorKeyframe.startTime,
          relativeDuration: AnimationConfiguration.colorKeyframe.duration) {
            from.containerView?.pullView?.heightConstraint?.constant = 0
            fromView.backgroundColor = .clear
        }
        UIView.addKeyframe(
          withRelativeStartTime: AnimationConfiguration.positionKeyframe.startTime,
          relativeDuration: AnimationConfiguration.positionKeyframe.duration) {
            fromView.topConstraint?.constant = fromView.bounds.height
            fromView.layoutIfNeeded()
        }
        
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      if transitionContext.transitionWasCancelled {
        fromView.removeFromSuperview()
      }
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
    groupAnimation.duration = duration / 2
    groupAnimation.animations = [scaleAnimation, cornerRadiusAnimation]
    
    toView.layer.add(groupAnimation, forKey: "scale")
    toView.layer.transform = CATransform3DIdentity
    toView.layer.cornerRadius = AnimationConfiguration.cornerRadius.to
    CATransaction.commit()
  }
  
}
