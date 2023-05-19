//
//  FinalApp.swift
//  Final
//
//  Created by Yuqing Yang on 3/21/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

@main
struct FinalApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var login = LoginModel()
    @StateObject var signup = SignUpModel()
    
    @StateObject var userInfo = UserInfoModel()
    
    @StateObject var locationViewModel = LocationViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            LogInView()
                .environmentObject(HTTP())
                .environmentObject(login)
                .environmentObject(signup)
                .environmentObject(userInfo)
                .environmentObject(locationViewModel)
        }
    }
}
