//
//  CilantroWYCApp.swift
//  CilantroWYC
//
//  Created by Rohan Malik on 9/13/22.
//

import SwiftUI
import WatchConnectivity

@main
struct CilantroWYCApp: App {
    init() {
        print("initializing")
        WCSession.default.delegate = Connectivity.shared.self
        WCSession.default.activate()
        let ud = UserDefaults.standard
        guard let temp = ud.string(forKey: "uinfo") else { return }
        let uinfo = try! JSONDecoder().decode(UserScheduleInfo.self, from: temp.data(using: .utf8)!)
        classes = uinfo.classes
        ZLunch = uinfo.ZLunch
        sports = uinfo.sports
//        guard let temp = ud.array(forKey: "ZLunch") else { return }
//        for i in 0...5 {
//            ZLunch[i+1] = (temp[i] as! Int)
//        }
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
//        classes[1] = [a, b, c, z, d]
//        classes[2] = [e, f, g, z, h]
//        classes[3] = [d, a, b, z, c]
//        classes[4] = [h, e, f, z, g]
//        classes[5] = [c, d, a, z, b]
//        classes[6] = [g, h, e, z, f]
//        guard let temp = ud.stringArray(forKey: "sports") else { return }
//        for i in 0...6 {
//            sports[i] = temp[i]
//        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { print("notifications authorized") }
            else if let error = error { print(error.localizedDescription) }
        }
        
        UISegmentedControl.appearance().apportionsSegmentWidthsByContent = true
        
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
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
