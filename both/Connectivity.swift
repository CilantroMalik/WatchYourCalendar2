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
        print("receiving data")
        self.data = userInfo
        let dat = userInfo["transferDat"] as! String
        let decoded = try! JSONDecoder().decode(UserScheduleInfo.self, from: dat.data(using: .utf8)!)
        print(decoded)
        self.classes = decoded.classes
        self.ZLunchDict = decoded.ZLunch
        self.sports = decoded.sports
        
        let dat3 = userInfo["eventsList"] as! String
        let allEvents = try! JSONDecoder().decode([String].self, from: dat3.data(using: .utf8)!)
        var newEvList: [[Int: [blockEvent]]] = [
            // January 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // February 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
            // March 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // April 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // May 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // June 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // July 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // August 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // September 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // October 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // November 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // December 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]]
        ]
        for str in allEvents {
            let comps = str.split(separator: "-")
            print("- Comps -")
            print(comps)
            print("- Block Event -")
            print(blockEvent(String(comps[2])).toString())
            newEvList[Int(String(comps[0]))!][Int(String(comps[1]))!]?.append(blockEvent(String(comps[2])))
        }
        EventsListObs().replaceList(newList: newEvList, sendRefresh: false)
        
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
        let dat = userInfo["eventsList"] as! String
        let allEvents = try! JSONDecoder().decode([String].self, from: dat.data(using: .utf8)!)
        var newEvList: [[Int: [blockEvent]]] = [
            // January 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // February 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
            // March 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // April 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // May 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // June 2023
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // July 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // August 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // September 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // October 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
            // November 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
            // December 2022
            [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]]
        ]
        for str in allEvents {
            let comps = str.split(separator: "-")
            print("- Comps -")
            print(comps)
            print("- Block Event -")
            print(blockEvent(String(comps[2])).toString())
            newEvList[Int(String(comps[0]))!][Int(String(comps[1]))!]?.append(blockEvent(String(comps[2])))
        }
        EventsListObs().replaceList(newList: newEvList, sendRefresh: false)
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
