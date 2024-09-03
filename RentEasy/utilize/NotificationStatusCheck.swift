//
//  NotificationStatusCheck.swift
//  RentEasy
//
//  Created by Apple on 3/9/24.
//

import Foundation
import UserNotifications
import UIKit

class NotificationStatusCheck {
    
    var window: UIWindow?
    private var currentViewController: UIViewController? = nil
    
    static let shared = NotificationStatusCheck()
    
    // Change 'private' to 'internal' or remove it to make the method accessible
    func setCurrentViewController(_ vc: UIViewController?) {
        self.currentViewController = vc
        checkNotificationsAuthorizationStatus()
    }
    
    private func checkNotificationsAuthorizationStatus() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .authorized:
                print("The app is authorized to schedule or receive notifications.")
                
            case .denied:
                print("The app isn't authorized to schedule or receive notifications.")
                self.requestNotificationAuthorization()
                
            case .notDetermined:
                print("The user hasn't yet made a choice about whether the app is allowed to schedule notifications.")
                self.requestNotificationAuthorization()
                
            case .provisional:
                print("The application is provisionally authorized to post noninterruptive user notifications.")
                self.requestNotificationAuthorization()
                
            case .ephemeral:
                print("The application is temporarily authorized to post notifications.")
                self.requestNotificationAuthorization()
                
            @unknown default:
                print("Unknown authorization status encountered.")
                self.requestNotificationAuthorization()
            }
        }
    }
    
    private func requestNotificationAuthorization() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User granted notification permission.")
            } else {
                print("User denied notification permission.")
                self.NotificationPopup()
            }
        }
    }
    
    private func NotificationPopup() {
        let alertController = UIAlertController(title: "Notification Alert", message: "Please turn on notifications to receive updates.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            self.currentViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
