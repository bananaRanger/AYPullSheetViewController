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

//MARK: - properties
public class AYDirectionalLineView: UIView, AYArrowView {
  
  //MARK: - properties
  public var size: CGSize = .zero {
    didSet {
      setNeedsLayout()
    }
  }
  
  public var strokeWidth: CGFloat {
    get {
      return shapeLayer.lineWidth
    } set {
      shapeLayer.lineWidth = newValue
      invalidateIntrinsicContentSize()
    }
  }
  
  public var strokeColor: UIColor {
    get {
      return UIColor(cgColor: shapeLayer.strokeColor ?? UIColor.clear.cgColor)
    } set {
      shapeLayer.strokeColor = newValue.cgColor
    }
  }
  
  var direction: AYArrowDirection = .up {
    didSet {
      update()
    }
  }
  
  var shapeLayer: CAShapeLayer {
    return layer as! CAShapeLayer
  }
  
  override public class var layerClass: AnyClass {
    return CAShapeLayer.self
  }
  
  private var boundsUsedForCurrentPath: CGRect = .zero
  
  //MARK: - init
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  //MARK: - methods
  override public func layoutSubviews() {
    super.layoutSubviews()
    if (boundsUsedForCurrentPath != bounds) {
      boundsUsedForCurrentPath = bounds
      shapeLayer.path = pathForBounds(bounds, direction: direction).cgPath
    }
  }
}

//MARK: - AYDirectionalLineView extension
extension AYDirectionalLineView {
  func setup() {
    backgroundColor = .clear
    size = CGSize(width: 30, height: 6)
    strokeWidth = 5
    strokeColor = .lightGray
    shapeLayer.lineCap = .round
    shapeLayer.lineJoin = .round
    shapeLayer.fillColor = UIColor.clear.cgColor
  }
  
  public func update(direction: AYArrowDirection, animated: Bool = true) {
    self.direction = direction
    update(animated: animated)
  }
  
  func pathForBounds(_ bounds: CGRect, direction: AYArrowDirection) -> UIBezierPath {
    let arrowHeight = size.height
    let arrowSpan = CGSize(width: size.width / 2, height: arrowHeight / 2)
    var offsetMultiplier = CGFloat(0)
    
    switch direction {
      case .up:       offsetMultiplier = -1
      case .straight: offsetMultiplier = 0
      case .down:     offsetMultiplier = 1
    }
    
    let centerY = bounds.midY + offsetMultiplier * arrowHeight / 2
    let centerX = bounds.midX
    let wingsY = centerY - offsetMultiplier * arrowHeight

    let center = CGPoint(x: centerX, y: centerY)
    let centerRight = CGPoint(x: centerX + arrowSpan.width, y: wingsY)
    let centerLeft = CGPoint(x: centerX - arrowSpan.width, y: wingsY)

    let bezierPath = UIBezierPath()
    bezierPath.move(to: centerLeft)
    bezierPath.addLine(to: center)
    bezierPath.addLine(to: centerRight)
    return bezierPath
  }
}

//MARK: - AYDirectionalLineView fileprivate
fileprivate extension AYDirectionalLineView {
  func update(animated: Bool = true) {
    let path = pathForBounds(bounds, direction: direction)

    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = shapeLayer.path
    shapeLayer.path = path.cgPath
    animation.toValue = shapeLayer.path
    animation.duration = animated ? 0.32 : 0.0
    shapeLayer.add(animation, forKey: "path")
  }
}
