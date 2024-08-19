//
//  LoadinManager.swift
//  RentEasy
//
//  Created by Apple on 19/8/24.
//

import Foundation
import UIKit
import SnapKit

class LoadingOverlay {
    
    static let shared = LoadingOverlay()
    
    private var overlayView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    func showLoadingOverlay(on view: UIView) {
        DispatchQueue.main.async {
            guard self.overlayView == nil else { return } // Prevent multiple overlays
            
            self.overlayView = UIView(frame: view.bounds)
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.overlayView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.activityIndicator = UIActivityIndicatorView(style: .large)
            self.activityIndicator?.color = .white
            self.activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            
            if let overlayView = self.overlayView, let activityIndicator = self.activityIndicator {
                overlayView.addSubview(activityIndicator)
                
                activityIndicator.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                
                view.addSubview(overlayView)
                activityIndicator.startAnimating()
                
                print("Loading overlay shown") // Debug statement
            } else {
                print("Failed to initialize overlay or activity indicator") // Debug statement
            }
        }
    }
    
    func hideLoadingOverlay() {
        DispatchQueue.main.async {
            print("Hiding loading overlay") // Debug statement
            
            guard let overlayView = self.overlayView else {
                print("No overlay view found") // Debug statement
                return
            }
            
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            overlayView.removeFromSuperview()
            
            // Clean up references
            self.overlayView = nil
            self.activityIndicator = nil
        }
    }
}
