//
//  Budget_BuddyApp.swift
//  Budget-Buddy
//
//  Created by Maureen Fox on 4/24/25.
//


import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseStorage


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main

struct BudgetBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        
        WindowGroup {
            LoginView()
                //.modelContainer(for: Purchase.self)
        }
    }
    //directory of simulatory data
//    init() {
//        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//    }
}
