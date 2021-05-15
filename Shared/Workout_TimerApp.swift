//
//  Workout_TimerApp.swift
//  Shared
//
//  Created by Abhi Jain on 2021-04-23.
//

import SwiftUI

@main
struct Workout_TimerApp: App {
    @State var temp = true;
    var body: some Scene {
        WindowGroup {
            ContentView(nav: $temp)
        }
    }
}
