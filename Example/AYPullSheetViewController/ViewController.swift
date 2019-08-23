//
//  ViewController.swift
//  AYPullSheetViewController
//
//  Created by antonyereshchenko@gmail.com on 08/23/2019.
//  Copyright (c) 2019 antonyereshchenko@gmail.com. All rights reserved.
//

import UIKit
import AYPullSheetViewController

class ViewController: UIViewController {
  
  let pullSheet = AYPullSheetViewController.create(
    initialAppearancePercent: 32,
    finalAppearancePercent: 92,
    horizontalSpacing: 16,
    animationType: .scaled)

  override func viewDidLoad() {
    super.viewDidLoad()
    pullSheet.containerView?.pullView?.topCornerRadius = 16
    pullSheet.containerView?.pullView?.arrow?.strokeColor = .action
    
    pullSheet.addRow(actionView: AYPullItemActionView.make(with: "Home", image: nil, clickHandler: nil))
    pullSheet.addRow(actionView: AYPullItemActionView.make(with: "About", image: nil, clickHandler: nil))
    pullSheet.addRow(actionView: AYPullItemActionView.make(with: "Settings", image: nil, clickHandler: nil))
  }
  
  @IBAction func openVCButtonTouchUpInside(_ sender: UIButton) {
    present(pullSheet, animated: true, completion: nil)
  }
}

