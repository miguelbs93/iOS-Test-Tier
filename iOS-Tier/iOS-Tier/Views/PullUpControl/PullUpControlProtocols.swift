//
//  PullUpControlProtocols.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import UIKit

protocol PullUpControlDataSource: AnyObject {
    func pullUpViewController() -> UIViewController
    func pullUpViewExpandedViewHeight() -> CGFloat
}

protocol PullUpControlDelegate: AnyObject {
    func didDismissPullUpControl()
}
