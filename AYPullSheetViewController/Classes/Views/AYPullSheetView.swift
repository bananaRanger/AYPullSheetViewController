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

//MARK: - AYPullSheetView class
public class AYPullSheetView: UIView, AYPullControlView {
  
  //MARK: - Properties
  public static var height: CGFloat = 32

  public var arrow: AYArrowView?
  public var topCornerRadius: CGFloat?

  //MARK: - inits
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    guard let topCornerRadius = topCornerRadius else { return }
    roundCorners(corners: [.topLeft, .topRight], radius: topCornerRadius)
  }
}

//MARK: - AYPullSheetView fileprivate extension
fileprivate extension AYPullSheetView {
  func setup() {
    let arrow = AYDirectionalLineView(frame: .zero)
    addSubview(arrow)
    arrow.addAllSidesAnchors(to: self)
    self.arrow = arrow
  }
}
