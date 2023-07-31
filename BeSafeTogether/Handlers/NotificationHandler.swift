//
//  NotificationHandler.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.07.2023.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options:
            [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification() {
        var trigger: UNNotificationTrigger?
        let content = UNMutableNotificationContent()
        
        content.title = "MY TITLE"
        content.body = "MY BODY"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
