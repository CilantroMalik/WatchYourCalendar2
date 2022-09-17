//
//  ExtensionDelegate.swift
//  CilantroWYC-WatchCompanion WatchKit Extension
//
//  Created by Rohan Malik on 9/13/22.
//

import Foundation
import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                reloadActiveComplications()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func applicationDidFinishLaunching() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { print("All set!") }
            else if let error = error { print(error.localizedDescription) }
        }
        
        scheduleRefresh()
//        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { success, error in
//            if success { print("Authorized") } else if let error = error { print(error.localizedDescription) }
//        }
//        let category1 = UNNotificationCategory(identifier: "sports", actions: [], intentIdentifiers: [], options: [])
//        let category2 = UNNotificationCategory(identifier: "lunch", actions: [], intentIdentifiers: [], options: [])
//        let category3 = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category1, category2, category3])
//
//        scheduleSportsNotification()
//        scheduleLunchNotification() FIXME: Notifications, but later
        let ud = UserDefaults.standard
        guard let temp = ud.stringArray(forKey: "eventsList") else { return }
        print("-- Before --")
        print(EventsListObs.evList)
        print("-- Temp -- ")
        print(temp)
        for str in temp {
            let comps = str.split(separator: "-")
            print("- Comps -")
            print(comps)
            print("- Block Event -")
            print(blockEvent(String(comps[2])).toString())
            EventsListObs.evList[Int(String(comps[0]))!][Int(String(comps[1]))!]?.append(blockEvent(String(comps[2])))
        }
        print("-- After --")
        print(EventsListObs.evList)
        
//        guard var temp = ud.array(forKey: "ZLunch") else { return }
//        var newZ = [Int: Int]()
//        for i in 0...5 {
//            newZ[i] = (temp[i] as! Int)
//        }
//        print("before update z lunch")
//        Connectivity.shared.updateZLunch(newZ: newZ)
//        print("after update z lunch")
//
//        guard let temp = ud.stringArray(forKey: "classes") else { return }
//        let a = temp[0]
//        let b = temp[1]
//        let c = temp[2]
//        let d = temp[3]
//        let e = temp[4]
//        let f = temp[5]
//        let g = temp[6]
//        let h = temp[7]
//        let z = temp[8]
//        var newCl = [Int: [String]]()
//        newCl[0] = ["", "", "", "", ""]
//        newCl[1] = [a, b, c, z, d]
//        newCl[2] = [e, f, g, z, h]
//        newCl[3] = [d, a, b, z, c]
//        newCl[4] = [h, e, f, z, g]
//        newCl[5] = [c, d, a, z, b]
//        newCl[6] = [g, h, e, z, f]
//        Connectivity.shared.updateClasses(newCl: newCl)
//
//        guard let temp = ud.stringArray(forKey: "sports") else { return }
//        print(temp)
//        var newSp = ["", "", "", "", "", "", ""]
//        for i in 0...6 {
//            newSp[i] = temp[i]
//        }
//        Connectivity.shared.updateSports(newSp: newSp)
//        let userData = UserData()
//        userData.updateClasses(classes)
//        userData.updateLunch(ZLunch)
//        userData.updateSports(sports)
        
        guard let temp = ud.string(forKey: "uinfo") else { return }
        let uinfo = try! JSONDecoder().decode(UserScheduleInfo.self, from: temp.data(using: .utf8)!)
        Connectivity.shared.updateClasses(newCl: uinfo.classes)
        Connectivity.shared.updateZLunch(newZ: uinfo.ZLunch)
        Connectivity.shared.updateSports(newSp: uinfo.sports)
    }
    
    func applicationWillResignActive() {
        let ud = UserDefaults.standard
        var allEvents: [String] = []
        for (i, month) in (EventsListObs.evList).enumerated() {
            for key in month.keys {
                for event in month[key]! {
                    allEvents.append("\(i)-\(key)-\(event.toString())")
                }
            }
        }
        print(allEvents)
        ud.set(allEvents, forKey: "eventsList")
    }
}
