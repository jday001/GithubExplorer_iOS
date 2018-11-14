//
//  UIViewController+ActivityIndicator.swift
//
//  Created by Jeff Day on 12/11/15.
//  Copyright © 2015 JDay Apps, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var activitySpinner: UIActivityIndicatorView?
        static var spinnerContainerView: UIView?
    }
    
    var activitySpinner: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.activitySpinner) as? UIActivityIndicatorView
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.activitySpinner,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var spinnerContainerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.spinnerContainerView) as? UIView
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.spinnerContainerView,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    
    
    // MARK: - Internal Functions
    
    func showActivitySpinner() {
        DispatchQueue.main.async { () -> Void in
            self.createContainerViewIfNeeded()
            self.createSpinnerViewIfNeeded()
            
            guard let window: UIWindow = UIApplication.shared.keyWindow,
                let containerView: UIView = self.spinnerContainerView,
                let spinner: UIActivityIndicatorView = self.activitySpinner else {
                    return
            }
            
            containerView.frame = window.bounds
            
            let horizontal: NSLayoutConstraint = NSLayoutConstraint(item: spinner,
                                                                    attribute: .centerX,
                                                                    relatedBy: .equal,
                                                                    toItem: containerView,
                                                                    attribute: .centerX,
                                                                    multiplier: 1.0,
                                                                    constant: 0.0)
            
            let vertical: NSLayoutConstraint = NSLayoutConstraint(item: spinner,
                                                                  attribute: .centerY,
                                                                  relatedBy: .equal,
                                                                  toItem: containerView,
                                                                  attribute: .centerY,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
            
            containerView.alpha = 0.0
            containerView.addSubview(spinner)
            containerView.addConstraints([horizontal, vertical])
            
            window.addSubview(containerView)
            window.bringSubviewToFront(containerView)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIView.AnimationOptions(),
                           animations: { () -> Void in
                            containerView.alpha = 1.0
            }, completion: { (finished) -> Void in
                spinner.startAnimating()
            })
        }
    }
    
    func hideActivitySpinner() {
        DispatchQueue.main.async { () -> Void in
            if let spinner: UIActivityIndicatorView = self.activitySpinner,
                let containerView: UIView = self.spinnerContainerView {
                
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: UIView.AnimationOptions(),
                               animations: { () -> Void in
                                containerView.alpha = 0.0
                }, completion: { (finished) -> Void in
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()
                    containerView.removeFromSuperview()
                })
            }
        }
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func createContainerViewIfNeeded() {
        guard let _: UIView = self.spinnerContainerView else {
            let containerView: UIView = UIView(frame: CGRect.zero)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.spinnerContainerView = containerView
            return
        }
    }
    
    private func createSpinnerViewIfNeeded() {
        guard let _: UIActivityIndicatorView = self.activitySpinner else {
            let activitySpinner = UIActivityIndicatorView(style: .whiteLarge)
            activitySpinner.translatesAutoresizingMaskIntoConstraints = false
            self.activitySpinner = activitySpinner
            return
        }
    }
}
