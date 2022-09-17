//
//  ContentView.swift
//  CilantroWYC
//
//  Created by Rohan Malik on 9/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RichDayView().tabItem { Label("Home", systemImage: "house.fill") }
            WatchConfig().tabItem { Label("Config", systemImage: "gearshape.fill") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
