//
//  Connectivity.swift
//  CilantroWYC
//
//  Created by Rohan Malik on 9/13/22.
//

import Foundation
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
    static let shared = Connectivity()
    @Published var data: [String: Any] = [:]
    @Published var classes: [Int: [String]] = [
        1: ["Free", "(B Block)", "(C Block)", "(Z)","(D Block)"],
        2: ["(E Block)", "(F Block)", "(G Block)", "(Z)","(H Block)"],
        3: ["(D Block)", "(A Block)", "(B Block)", "(Z)","(C Block)"],
        4: ["(H Block)", "(E Block)", "(F Block)", "(Z)","(G Block)"],
        5: ["(C Block)", "(D Block)", "(A Block)", "(Z)","(B Block)"],
        6: ["(G Block)", "(H Block)", "(E Block)", "(Z)","(F Block)"]
    ]
    @Published var sports: [String] = ["Off", "Go Home 1!", "Go Home 2!", "Go Home 3!", "Go Home 4!", "Go Home 5!", "Go Home 6!"]
    @Published var ZLunchDict: [Int: Int] =  [0: 3, 1: 3, 2: 3, 3: 3, 4: 3, 5: 3, 6: 3]
    @Published var eventsList = [[Int: [blockEvent]]]()
    
    override private init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
        print("Activating Watch Connectivity session")
    }
    
    public func send(obj: [String: Any]) {
        guard WCSession.default.activationState == .activated else { WCSession.default.activate(); print("session not activated, activating"); return }
        #if os(watchOS)
            guard WCSession.default.isCompanionAppInstalled else { print("companion not installed"); return }
        #else
            guard WCSession.default.isWatchAppInstalled else { print("companion not installed"); return }
        #endif
        WCSession.default.transferUserInfo(obj)
        print("Initiated data transfer to watch")
    }
    
    public func updateClasses(newCl: [Int: [String]]) {
        self.classes = newCl
        objectWillChange.send()
    }
    
    public func updateZLunch(newZ: [Int: Int]) {
        self.ZLunchDict = newZ
        objectWillChange.send()
    }
    
    public func updateSports(newSp: [String]) {
        self.sports = newSp
        objectWillChange.send()
    }
}


extension Connectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activated session")
    }
    
    #if os(watchOS)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        self.data = userInfo
        let dat = userInfo["transferDat"] as! String
        let decoded = try! JSONDecoder().decode(UserScheduleInfo.self, from: dat.data(using: .utf8)!)
        print(decoded)
        self.classes = decoded.classes
        self.ZLunchDict = decoded.ZLunch
        self.sports = decoded.sports
        EventsListObs().replaceList(newList: userInfo["eventsList"] as! [[Int: [blockEvent]]], sendRefresh: false)
//        let lunches = userInfo["ZLunch"]! as! [Int]
//        let classArr = userInfo["classes"]! as! [String]
//        let sportsArr = userInfo["sports"]! as! [String]
//        //eventsList = userInfo["eventsList"] as! [[Int: [blockEvent]]]
//        EventsListObs().replaceList(newList: userInfo["eventsList"] as! [[Int: [blockEvent]]])
//
//        for i in 0...5 {
//            self.ZLunchDict[i+1] = lunches[i]
//            self.sports[i+1] = sportsArr[i] == "" ? "Go Home!" : sportsArr[i]
//        }
//        let a = classArr[0]
//        let b = classArr[1]
//        let c = classArr[2]
//        let d = classArr[3]
//        let e = classArr[4]
//        let f = classArr[5]
//        let g = classArr[6]
//        let h = classArr[7]
//        let z = classArr[8]
//        self.classes[0] = ["", "", "", "", ""]
//        self.classes[1] = [a, b, c, z, d]
//        self.classes[2] = [e, f, g, z, h]
//        self.classes[3] = [d, a, b, z, c]
//        self.classes[4] = [h, e, f, z, g]
//        self.classes[5] = [c, d, a, z, b]
//        self.classes[6] = [g, h, e, z, f]
        
//        UserDefaults.standard.set(lunches, forKey: "ZLunch")
//        UserDefaults.standard.set(classArr, forKey: "classes")
//        UserDefaults.standard.set(sports, forKey: "sports")
        let uinfo = UserScheduleInfo(classes: self.classes, ZLunch: self.ZLunchDict, sports: sports)
        let encoder = JSONEncoder()
        let dat2 = try! encoder.encode(uinfo)
        UserDefaults.standard.set(String(data: dat2, encoding: .utf8), forKey: "uinfo")
        

        print("Setting data from session: \(self.data)")
    }
    #endif

    #if os(iOS)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        self.data = userInfo
        // self.eventsList = userInfo["eventsList"] as! [[Int: [blockEvent]]]
        EventsListObs().replaceList(newList: userInfo["eventsList"] as! [[Int: [blockEvent]]], sendRefresh: false)
        print("Setting data from session: \(self.data)")
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        WCSession.default.activate()
    }

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}
