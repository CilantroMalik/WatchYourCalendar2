//
//  CilantroWYCApp.swift
//  CilantroWYC-WatchCompanion WatchKit Extension
//
//  Created by Rohan Malik on 9/13/22.
//

import SwiftUI
import WatchKit

@main
struct CilantroWYCApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "sports")
        WKNotificationScene(controller: LunchNotificationController.self, category: "lunch")
        WKNotificationScene(controller: ScheduleNotificationController.self, category: "event")
    }
}
