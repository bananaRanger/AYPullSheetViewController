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

//MARK: - AYPullSheetViewController class
public class AYPullSheetViewController: UIViewController, AYPullController {
  
  //MARK: - properties
  private var _initialAppearancePercent: Int?
  private var _finalAppearancePercent: Int?
  
  private var _horizontalSpacing: CGFloat?

  private var _scaledAnimation: Bool?

  var _topAppearanceY: CGFloat {
    let percent = _finalAppearancePercent ?? 0
    return view.frame.size.height - CGFloat.percent(percent, from: view.frame.size.height)
  }
  
  var _bottomAppearanceY: CGFloat {
    let percent = _initialAppearancePercent ?? 0
    return view.frame.size.height - CGFloat.percent(percent, from: view.frame.size.height)
  }
  
  var _appearanceYCenter: CGFloat {
    return (_bottomAppearanceY + _topAppearanceY) / 2
  }
  
  public var containerView: AYPullContainerView?
  
  public var animatedPresenting: UIViewControllerAnimatedTransitioning?
  public var animatedDismissing: UIViewControllerAnimatedTransitioning?
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: - methods
  public static func create(initialAppearancePercent: Int = 40,
                     finalAppearancePercent: Int = 80,
                     horizontalSpacing: CGFloat = 0,
                     animationType: AYAnimationType = .scaled) -> AYPullSheetViewController {
    let vc = AYPullSheetViewController()
    var factory = AYPullSheetViewFactory(parent: vc.view)
    factory.initialAppearancePercent = min(initialAppearancePercent, finalAppearancePercent)
    factory.horizontalSpacing = horizontalSpacing
    vc._initialAppearancePercent = min(initialAppearancePercent, finalAppearancePercent)
    vc._finalAppearancePercent = max(initialAppearancePercent, finalAppearancePercent)
    vc._horizontalSpacing = horizontalSpacing
    vc.containerView = factory.pullContainerView()
    vc.animatedPresenting = AYAnimatedFactory.animatedPresenting(with: animationType)
    vc.animatedDismissing = AYAnimatedFactory.animatedDismissing(with: animationType)
    vc.modalPresentationCapturesStatusBarAppearance = true
    vc.modalPresentationStyle = .overCurrentContext
    vc.view.backgroundColor = .clear
    vc.transitioningDelegate = vc
    return vc
  }
  
  public func addView(_ view: UIView) {
    containerView?.contentView?.addItem(view: view)
  }
  
  public func addRow(actionView: AYPullItemActionView) {
    addView(actionView)
  }
    
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let gesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(AYPullSheetViewController.wasDragged(gestureRecognizer:))
    )
    containerView?.pullView?.addGestureRecognizer(gesture)
    containerView?.pullView?.isUserInteractionEnabled = true
  }
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard touches.first?.view == view else { return }
    dismiss(animated: true) { [weak self] in
      self?.containerView?.pullView?.arrow?.update(direction: .up, animated: true)
    }
  }
  
  internal func topYBackgroundColorAlpha(duration: TimeInterval) {
    let alpha = 1 - (_topAppearanceY / view.bounds.size.height)
    view.backgroundColorAlpha(alpha, duration: duration)
  }
  
  internal func bottomYBackgroundColorAlpha(duration: TimeInterval) {
    let alpha = 1 - (_bottomAppearanceY / view.bounds.size.height)
    view.backgroundColorAlpha(alpha, duration: duration)
  }
  
}

//MARK: - AYPullSheetViewController extension
extension AYPullSheetViewController {
  private struct AnimationConfiguration {
    static let moving: TimeInterval = 0.16
    static let ending: TimeInterval = 0.36
  }
  
  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    bottomYBackgroundColorAlpha(duration: AnimationConfiguration.moving)
    view.topConstraint?.constant = view.bounds.height
    UIView.animate(withDuration: AnimationConfiguration.moving, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
  
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { [weak self] context in
      self?.view.topConstraint?.constant = self?._bottomAppearanceY ?? 0
    }, completion: nil)
  }
  
  @objc fileprivate func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
    guard let containerView = gestureRecognizer.view,
      containerView == containerView else { return }
    
    let translation = gestureRecognizer.translation(in: containerView)
    let point = gestureRecognizer.location(in: self.view)
    let constraint = view.topConstraint
    
    if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
      
      if(gestureRecognizer.velocity(in: view).y > 0) {
        self.containerView?.pullView?.arrow?.update(direction: .straight, animated: true)
      } else {
        self.containerView?.pullView?.arrow?.update(direction: .straight, animated: true)
      }
      
      if point.y >= _bottomAppearanceY +
        (self.containerView?.pullView?.bounds.height ?? 0) {
        dismiss(animated: true) { [weak self] in
          self?.containerView?.pullView?.arrow?.update(direction: .up, animated: true)
        }
        return
      }
      
      if point.y <= _topAppearanceY {
        UIView.animate(withDuration: AnimationConfiguration.moving, animations: { [weak self] in
          constraint?.constant = self?._topAppearanceY ?? 0
          self?.view.layoutIfNeeded()
        })
        return
      }
      
      UIView.animate(withDuration: AnimationConfiguration.moving, animations: { [weak self] in
        let alpha = 1 - (point.y / (self?.view.frame.height ?? 0))
        self?.view.backgroundColorAlpha(alpha, duration: AnimationConfiguration.ending)
        constraint?.constant += translation.y
        self?.view.layoutIfNeeded()
      })
    } else if gestureRecognizer.state == .ended {
      UIView.animate(withDuration: AnimationConfiguration.ending, animations: { [weak self] in
        if point.y >= (self?._appearanceYCenter ?? 0) {
          self?.containerView?.pullView?.arrow?.update(direction: .up, animated: true)
          self?.bottomYBackgroundColorAlpha(duration: AnimationConfiguration.ending)
          constraint?.constant = (self?._bottomAppearanceY ?? 0)
        } else {
          self?.containerView?.pullView?.arrow?.update(direction: .down, animated: true)
          self?.topYBackgroundColorAlpha(duration: AnimationConfiguration.ending)
          constraint?.constant = (self?._topAppearanceY ?? 0)
        }
        self?.view.layoutIfNeeded()
      })
    }
    gestureRecognizer.setTranslation(.zero, in: containerView)
  }
}

//MARK: - UIViewControllerTransitioningDelegate extension
extension AYPullSheetViewController: UIViewControllerTransitioningDelegate {
  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return animatedPresenting
  }
  
  public func animationController(
    forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return animatedDismissing
  }
}

//MARK: - extension of UIView
extension UIView {
  var topConstraint: NSLayoutConstraint? {
    var top: NSLayoutConstraint? = nil
    constraints.forEach { constraint in
      if constraint.firstAttribute == .top {
        top = constraint
        return
      }
    }
    return top
  }
  
  var heightConstraint: NSLayoutConstraint? {
    var height: NSLayoutConstraint? = nil
    constraints.forEach { constraint in
      if constraint.firstAttribute == .height {
        height = constraint
        return
      }
    }
    return height
  }
}
