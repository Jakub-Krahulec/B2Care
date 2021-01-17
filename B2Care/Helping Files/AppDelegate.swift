//
//  AppDelegate.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // Volá se pokud uživatel reaguje na notifikaci (aplikace není na popředí)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
                                    completionHandler: @escaping () -> Void) {
        return completionHandler()
    }
    
    // Volá se když je aplikace na popředí
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
                                    notification: UNNotification, withCompletionHandler completionHandler:
                                        @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Zobrazí alert když je aplikace na popředí
        return completionHandler(.banner)
    }
    
}

