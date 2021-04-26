//
//  ContentView.swift
//  Shared
//
//  Created by Abhi Jain on 2021-04-23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State var Hours : String = ""
    @State var Minutes : String = ""
    @State var Seconds : String = ""
    @State var GoToTime : Bool = false;
    @State var allTimers : [TimeStore] = load("timers.json")
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("All timers")
                        .padding()
                    Spacer()
                    NavigationLink(
                        destination: TimerBuild(),
                        isActive: $GoToTime,
                        label: {
                            Image(systemName: "plus")
                        }).padding()
                }
                List(allTimers) { ts in
                    NavigationLink(destination: RunTime(allTimes: ts)) {
                        HStack {
                            Text(ts.name).padding()
                            Spacer()
                            Text("run")
                        }
                    }.padding()
                }
                Button("brrrr") {
                    print(allTimers)
                    print(allTimers[0].times)
                    print(allTimers[1].times)
                }
                Spacer()
            }
        }
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
