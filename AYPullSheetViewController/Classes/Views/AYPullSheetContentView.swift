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

//MARK: - AYPullSheetContentView class
public class AYPullSheetContentView: UIView, AYPullContentView {
  
  //MARK: - Properties
  private var scrollView: UIScrollView?
  private var stack: UIStackView?
  
  public var views: [UIView] {
    return stack?.arrangedSubviews ?? [UIView]()
  }
  
  //MARK: - Inits
  override internal init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  internal required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public init(with frame: CGRect = .zero) {
    super.init(frame: frame)
    setup()
  }
  
  //MARK: - Methods
  public func addItem(view: UIView) {
    stack?.addArrangedSubview(view)
  }
}

//MARK: - Fileprivate extension of LeafContentView
fileprivate extension AYPullSheetContentView {
  func setup() {
    let stack = UIStackView(frame: .zero)
    stack.axis = .vertical
    
    scrollView = UIScrollView(frame: .zero)
    scrollView?.delegate = self
    scrollView?.addSubview(stack)
    
    scrollView?.showsVerticalScrollIndicator = false
    scrollView?.showsHorizontalScrollIndicator = false

    stack.translatesAutoresizingMaskIntoConstraints = false
    scrollView?.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView?.topAnchor.constraint(
      equalTo: stack.topAnchor
      ).isActive = true
    
    scrollView?.bottomAnchor.constraint(
      equalTo: stack.bottomAnchor
      ).isActive = true
    
    scrollView?.leadingAnchor.constraint(
      equalTo: stack.leadingAnchor
      ).isActive = true
    
    scrollView?.trailingAnchor.constraint(
      equalTo: stack.trailingAnchor
      ).isActive = true
    
    scrollView?.widthAnchor.constraint(
      equalTo: stack.widthAnchor
      ).isActive = true
    
    self.stack = stack
    
    let heightAnchor = scrollView?.heightAnchor.constraint(equalTo: stack.heightAnchor)
    heightAnchor?.priority = .defaultLow
    heightAnchor?.isActive = true
    
    if let scrollView = scrollView {
      addSubview(scrollView)
      scrollView.addAllSidesAnchors(to: self)
    }
  }
}

//MARK: - UIScrollViewDelegate
extension AYPullSheetContentView: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x != 0 {
      scrollView.contentOffset.x = 0
    }
  }
}
