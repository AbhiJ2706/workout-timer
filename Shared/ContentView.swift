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
    @State var allTimers = load(filename: "timers.json")
    @State var showAlert = false;
    @Binding var nav : Bool;
    
    func switchNav(){
        nav = !nav;
    }
    func delete() {
        showAlert = true;
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("All timers")
                        .padding()
                    Spacer()
                    Button(action: switchNav) {
                        Image(systemName: "minus")
                    }
                    NavigationLink(
                        destination: TimerBuild(alltimers : $allTimers),
                        isActive: $GoToTime,
                        label: {
                            Image(systemName: "plus")
                        }).padding()
                }
                List(allTimers) { ts in
                    HStack (alignment: .center) {
                        Text(ts.name).padding()
                        Spacer()
                        if !nav {
                            Button(action: delete) {
                                Image(systemName: "trash").foregroundColor(.red)
                            }.alert(isPresented: $showAlert) {
                                Alert(title: Text("Delete?"),
                                      message: Text("Are you sure you want to delete?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                                        var index : Int = 0;
                                                        for i in 0...allTimers.count {
                                                            if ts.name == allTimers[i].name {
                                                                index = i;
                                                                break;
                                                            }
                                                        }
                                                        allTimers.remove(at: index)
                                                        save(filename: "timers.json", t: allTimers)
                                                      },
                                      secondaryButton: .cancel())
                            }
                        } else {
                            NavigationLink(destination: RunTime(allTimes: ts)) {
                                Spacer()
                                Text("Run")
                            }.id(UUID())
                        }
                    }
                }
                Spacer()
            }
        }
        Spacer()
    }
}

/*struct ContentView_Previews: PreviewProvider {
    @S
    static var previews: some View {
        ContentView(nav: )
    }
}*/
