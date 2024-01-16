//
//  TimerBuild.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-23.
//

import SwiftUI
import AVFoundation



func timePrettyFormat(time: Int) -> String {
    let seconds : Int = Int(time) % 60
    var minutes : Int = (Int(time) - seconds) / 60
    if minutes >= 60 {
        while (minutes >= 60 ) {
            minutes -= 60
        }
    }
    let hours : Int = Int(time) / 3600
    return String(hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
}


struct Times : Codable {
    var Hours : Int
    var Minutes : Int
    var Seconds : Int
    var id : Int
}


struct TimeView : View {
    
    @State var t : Times
    @Binding var times : [Times]
    @Binding var gid : Int
    
    func del() {
        for i in 0...times.count - 1 {
            if i > t.id {
                times[i].id -= 1
            }
        }
        times.remove(at: t.id)
        gid -= 1
    }
    
    var body : some View {
        HStack {
            Text(timePrettyFormat(time: 3600 * t.Hours + 60 * t.Minutes + t.Seconds))
            Spacer()
            Button(action: del) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
    }
}


class TimeStore : ObservableObject, Codable, Identifiable {
    var name : String = "timer_" + String(Int.random(in: 1..<100000000))
    var times : [Times] = []
}


struct TimerBuild: View {
    @ObservedObject var Hours = NumbersOnly()
    @ObservedObject var Minutes = NumbersOnly()
    @ObservedObject var Seconds = NumbersOnly()
    @ObservedObject var time = TimeStore()
    
    @State var id : Int = 0
    @State var Items : [Times] = []
    @State var GoToTime : Bool = false
    @Binding var alltimers : [TimeStore]
    @Binding var timerRunning: Bool
    @Binding var currentTimerProgress: CGFloat
    @Binding var currentTimerTime: Decimal
    
    func submit() -> Void {
        let totTime : Int = Hours.amt * 3600 + Minutes.amt * 60 + Seconds.amt
        var t : Times
        if totTime >= 360000 {
            t = Times(Hours : 99, Minutes : 59, Seconds : 59, id : id)
        } else {
            t = Times(Hours : Hours.amt, Minutes : Minutes.amt, Seconds : Seconds.amt, id : id)
        }
        time.times.append(t)
        Items.append(t)
        id += 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                TextField("Name", text : $time.name)
                TextField("Hours", text : $Hours.value)
                    .keyboardType(.decimalPad)
                TextField("Minutes", text : $Minutes.value)
                    .keyboardType(.decimalPad)
                TextField("Seconds", text : $Seconds.value)
                    .keyboardType(.decimalPad)
                Button("Add") {
                    submit()
                }
                NavigationLink(
                    destination: RunTime(allTimes : time,
                                         cTime: $currentTimerTime,
                                         progressValue: $currentTimerProgress,
                                         timerRunning: $timerRunning),
                    isActive: $GoToTime,
                    label: {
                        Text("Run").foregroundColor(.blue)
                    })
                Button("Save") {
                    var found : Bool = false
                    if alltimers.count > 0 {
                        for i in 0...alltimers.count - 1 {
                            if alltimers[i].name == time.name {
                                alltimers[i] = time
                                found = true
                            }
                        }
                        if !found {
                            alltimers.append(time)
                        }
                    } else {
                        alltimers.append(time)
                    }
                    save(filename : "timers.json", t : alltimers)
                }
            }
            Form {
                List(Items, id : \.id) { Times in
                    TimeView(t : Times, times: $Items, gid: $id)
                }
            }.frame(alignment: .top)
        }
    }
}

/*struct TimerBuild_Previews: PreviewProvider {
    @State var x : [TimeStore] = []
    
    static var previews: some View {
        TimerBuild(alltimers: Binding<[TimeStore]>($x)!)
    }
}*/
