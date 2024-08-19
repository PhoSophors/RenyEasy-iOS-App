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
    
    private var overlayView: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    static let shared = LoadingOverlay()

    private init() {
        setupOverlay()
    }

    private func setupOverlay() {
        overlayView = UIView()
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.layer.cornerRadius = 10
        overlayView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true

        overlayView.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func show(over view: UIView) {
        guard overlayView.superview == nil else { return }

        overlayView.alpha = 0
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        activityIndicator.startAnimating()

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
        }) { _ in
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
}
