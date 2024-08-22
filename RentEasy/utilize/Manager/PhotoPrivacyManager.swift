//
//  PhotoPrivacyManager.swift
//  RentEasy
//
//  Created by Apple on 22/8/24.
//

import Foundation
import Photos
import UIKit

class PhotoPrivacyManager {
    
    // Check and request photo library access
    static func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        case .denied, .restricted:
            completion(false)
        case .limited:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    // Show alert for photo library access
    static func showAccessAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Photo Library Access",
            message: "This app requires access to your photo library to select photos. Please enable access in the Settings app.",
            preferredStyle: .alert
        )
        
        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(openSettingsAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Get the maximum number of photos user can select for posting
    static func getPostPhotoLimit() -> Int {
        return 6
    }
    
    // Optionally, get the actual device photo library limit if needed
    static func getDevicePhotoLimit() -> Int {
        return 0
    }
}
