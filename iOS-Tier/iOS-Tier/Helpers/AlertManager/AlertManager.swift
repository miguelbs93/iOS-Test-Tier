//
//  AlertManager.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import UIKit

protocol AlertManager {
    func showAlertWith(title: String, message: String, delay: Double, actions: [String: (() -> Void)])
}

extension AlertManager where Self: UIViewController {
    func showAlertWith(title: String, message: String, delay: Double = 0.0, actions: [String: (() -> Void)] = [String: (() -> Void)]()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (title, handler) in actions {
            let action = UIAlertAction(title: title, style: .default) { _ in
                handler()
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.present(alertController, animated: true)
        })
    }
}
