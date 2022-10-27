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
    
    private var state: PullUpState = .collapsed
    
    private var widthView: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var parentView: UIView?
    public var pullUpVC: UIViewController!
    
    var visualEffectView:UIVisualEffectView!
    
    public weak var dataSource: PullUpControlDataSource?
    public weak var delegate: PullUpControlDelegate?
    
    private var topAnchor: NSLayoutConstraint?
    
    private var defaultHeight: CGFloat {
        UIScreen.main.bounds.height * 0.7
    }
    
    public func setupCard(from view: UIView) {
        parentView = view
        
        visualEffectView = UIVisualEffectView()

        //setup pullUpVC
        guard let safePullUpViewController = dataSource?.pullUpViewController() else {return}
        pullUpVC = safePullUpViewController
        pullUpVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pullUpVC.view)
        setupConstraints()
        
        pullUpVC.view.clipsToBounds = true
        pullUpVC.view.layer.cornerRadius = 15
        
        //add tap gesture
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
    
    public func show(completion: @escaping (Bool) -> Void) {
        //check if the view is already shown in the view
        guard state == .collapsed else { return }
        let height = dataSource?.pullUpViewExpandedViewHeight() ?? defaultHeight
        topAnchor?.constant -= height
        updateViewLayout {[weak self] success in
            self?.state = .expanded
            completion(success)
        }
    }
    
    public func hide(completion: @escaping (Bool) -> Void) {
        guard state == .expanded else { return }
        topAnchor?.constant = 0
        updateViewLayout {[weak self] success in
            self?.state = .collapsed
            completion(success)
        }
    }
    
    private func updateViewLayout(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.pullUpVC.view.layoutIfNeeded()
        } completion: { success in
            completion(success)
        }
    }
    
}

// MARK: PanGesture Handling
extension PullUpControl {
    
    private func setupPanGesture() {
        let handleArea = delegate?.pullUpHandleArea(pullUpVC)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        handleArea?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
}
