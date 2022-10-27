//
//  PullUpControl.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 26.10.22.
//

import UIKit

class PullUpControl {
    
    enum PullUpState {
        case collapsed
        case expanded
    }
    
    var state: PullUpState = .collapsed
    
    private var widthView: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var parentView: UIView?
    public var pullUpVC: UIViewController!
    
    var visualEffectView:UIVisualEffectView!
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    public weak var dataSource: PullUpControlDataSource?
    public weak var delegate: PullUpControlDelegate?
  
    var endCardHeight:CGFloat = 0.0
    var startCardHeight:CGFloat = 0.0
    
    var topAnchor: NSLayoutConstraint?
    
    private var defaultHeight: CGFloat {
        UIScreen.main.bounds.height * 0.7
    }
    
    public func setupCard(from view: UIView) {
        endCardHeight = dataSource?.pullUpViewExpandedViewHeight() ?? defaultHeight
        startCardHeight = 0.0
        
        parentView = view
        
        //setup pullUpVC
        guard let pullUpViewController = dataSource?.pullUpViewController() else {return}
        pullUpVC = pullUpViewController
        pullUpVC.view.translatesAutoresizingMaskIntoConstraints = false
        pullUpVC.view.isHidden = true
        
        pullUpVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: widthView, height: endCardHeight)
        
        view.addSubview(pullUpVC.view)
        setupConstraints()
        
        pullUpVC.view.clipsToBounds = true
        pullUpVC.view.layer.cornerRadius = 15
        
        setupPanGesture()
    }
    
    private func setupConstraints() {
        guard let pullUpView = pullUpVC.view,
              let parentView = parentView else { return }
        let height = dataSource?.pullUpViewExpandedViewHeight() ?? defaultHeight
        let heightAnchor = pullUpView.heightAnchor.constraint(equalToConstant: height)
        topAnchor = pullUpView.topAnchor.constraint(equalTo: parentView.bottomAnchor)
        let widthAnchor = pullUpView.widthAnchor.constraint(equalToConstant: widthView)
        
        NSLayoutConstraint.activate([
            heightAnchor,
            topAnchor!,
            widthAnchor
        ])
    }
    
}

// MARK: Show/Hide
extension PullUpControl {
    
    public func show(completion: ((Bool) -> Void)? = nil) {
        //check if the view is already shown in the view
        guard state == .collapsed else { return }
        pullUpVC.view.isHidden = false
        let height = dataSource?.pullUpViewExpandedViewHeight() ?? defaultHeight
        topAnchor?.constant = -height
        updateViewLayout {[weak self] success in
            self?.state = .expanded
            completion?(success)
        }
    }
    
    public func hide(completion: ((Bool) -> Void)? = nil) {
        guard state == .expanded else { return }
        topAnchor?.constant = 0
        updateViewLayout {[weak self] success in
            self?.state = .collapsed
            completion?(success)
        }
    }
    
    private func updateViewLayout(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.parentView?.layoutIfNeeded()
        } completion: { success in
            completion(success)
        }
    }
    
}

// MARK: PanGesture Handling
extension PullUpControl {
    
    private func setupPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        pullUpVC.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.pullUpVC.view)
        switch recognizer.state {
        case .began:
            break
            
        case .changed:
            guard translation.y > 0 else { return }
            pullUpVC.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        case .ended:
            guard translation.y > 0 else { return }
            pullUpVC.view.transform = CGAffineTransform(translationX: 0, y: endCardHeight)
            hide {[weak self] _ in
                self?.pullUpVC.view.transform = .identity
                self?.delegate?.didDismissPullUpControl()
            }
            
        default:
            break
        }
    }
}
