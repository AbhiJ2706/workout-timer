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
    
    var body : some View {
        Text(timePrettyFormat(time: 3600 * t.Hours + 60 * t.Minutes + t.Seconds))
    }
}


class TimeStore : ObservableObject, Codable, Identifiable {
    var name : String = ""
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
    
    func submit() -> Void {
        let t : Times = Times(Hours : Hours.amt, Minutes : Minutes.amt, Seconds : Seconds.amt, id : id)
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
                    destination: RunTime(allTimes : time),
                    isActive: $GoToTime,
                    label: {
                        Text("run")
                    })
                Button("Save") {
                    alltimers.append(time)
                    save(filename : "timers.json", t : alltimers)
                }
            }
            Form {
                List(Items, id : \.id) { Times in
                    TimeView(t : Times)
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
