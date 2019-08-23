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

//MARK: - AYPullSheetViewFactory struct
public struct AYPullSheetViewFactory {
  
  //MARK: - properties
  private let parent: UIView
  
  var initialAppearancePercent: Int?
  var horizontalSpacing: CGFloat?
  
  //MARK: - inits
  init(parent: UIView) {
    self.parent = parent
  }
  
  //MARK: - methods
  func pullContainerView() -> AYPullContainerView {
    let containerView = AYPullSheetContainerView(frame: .zero)
    containerView.backgroundColor = .clear
    
    let pullView = AYPullSheetView(frame: .zero)
    pullView.backgroundColor = .red
    let contentView = AYPullSheetContentView(frame: .zero)
    
    containerView.pullView = pullView
    containerView.contentView = contentView
    
    pullView.backgroundColor = UIColor.white
    contentView.backgroundColor = UIColor.white
    
    containerView.addSubview(pullView)
    pullView.translatesAutoresizingMaskIntoConstraints = false
    pullView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    pullView.heightAnchor.constraint(equalToConstant: 0).isActive = true
    pullView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    pullView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    
    containerView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    contentView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    contentView.topAnchor.constraint(equalTo: pullView.bottomAnchor).isActive = true
    
    let initial = initialAppearancePercent ?? 0
    let space = horizontalSpacing ?? 0
    let containerHeight = parent.frame.size.height
    let percentValue = containerHeight - CGFloat.percent(initial, from: containerHeight)
    
    parent.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -space).isActive = true
    containerView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    containerView.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: space).isActive = true
    containerView.topAnchor.constraint(equalTo: parent.topAnchor, constant: percentValue).isActive = true
    
    return containerView
  }
}
