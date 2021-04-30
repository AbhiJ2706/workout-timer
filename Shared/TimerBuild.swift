//
//  TimerBuild.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-23.
//

import SwiftUI
import AVFoundation


struct Times : Codable {
    var Hours : Int
    var Minutes : Int
    var Seconds : Int
    var id : Int
}


struct TimeView : View {
    
    @State var t : Times
    
    var body : some View {
        HStack {
            Text(String(t.Hours) + " Hours, ")
            Text(String(t.Minutes) + " Minutes, ")
            Text(String(t.Seconds) + " Seconds")
        }
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
        VStack {
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
            List(Items, id : \.id) { Times in
                TimeView(t : Times)
            }.padding(.all).frame(width: 390, height: 30+50*CGFloat(Items.count < 6 ? Items.count : 6)).accentColor(.clear)
        }
    }
}

/*struct TimerBuild_Previews: PreviewProvider {
    @State var x : [TimeStore] = []
    
    static var previews: some View {
        TimerBuild(alltimers: Binding<[TimeStore]>($x)!)
    }
}*/
