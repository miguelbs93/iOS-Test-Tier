//
//  PullUpControlProtocols.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import UIKit

protocol PullUpControlDelegate: AnyObject {
    func pullUpHandleArea(_ sender: UIViewController) -> UIView
}

protocol PullUpControlDataSource: AnyObject {
    func pullUpViewController() -> UIViewController
    func pullUpViewExpandedViewHeight() -> CGFloat
    func pullUpViewCollapsedViewHeight() -> CGFloat
}
