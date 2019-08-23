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

//MARK: AYArrowDirection enum
public enum AYArrowDirection: Int {
  case up
  case straight
  case down
}

//MARK: - AYArrowView protocol
public protocol AYArrowView: UIView {
  var size: CGSize { get set }
  var strokeWidth: CGFloat { get set }
  var strokeColor: UIColor { get set }
  func update(direction: AYArrowDirection, animated: Bool)
}

//MARK: - AYPullControlView protocol
public protocol AYPullControlView: UIView {
  static var height: CGFloat { get }
  
  var arrow: AYArrowView? { get }
  var topCornerRadius: CGFloat? { get set }
}

//MARK: - AYPullContentView protocol
public protocol AYPullContentView: UIView {
  var views: [UIView] { get }

  func addItem(view: UIView)
}

//MARK: - AYPullView protocol
public protocol AYPullContainerView: UIView {
  var pullView: AYPullControlView? { get set }
  var contentView: AYPullContentView? { get set }
}

//MARK: - AYPullController protocol
public protocol AYPullController: UIViewController {
  var containerView: AYPullContainerView? { get }
  var animatedPresenting: UIViewControllerAnimatedTransitioning? { get }
  var animatedDismissing: UIViewControllerAnimatedTransitioning? { get }
  
  func addView(_ view: UIView)
  func addRow(actionView: AYPullItemActionView)
}
