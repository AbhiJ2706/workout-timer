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
    @State var GoToTime : Bool = false;
    
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
                Button("add") {
                    submit()
                }
                NavigationLink(
                    destination: RunTime(allTimes : time),
                    isActive: $GoToTime,
                    label: {
                        Text("run")
                    })
                Button("save") {
                    submit()
                }
                Button("brrrrrrr") {
                    do {
                        // Convert object to JSON as NSData
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(time)
                        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.data(using: String.Encoding.utf8)!
                        print("JSON string: \(json!)")
                        //let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        //print(dURL)
                        let directoryURL = URL(string: "file:///Users/abhijain/Documents/GitHub/workout-timer")
                        let fileURL = URL(fileURLWithPath: "timers", relativeTo: directoryURL).appendingPathExtension("json")
                        do {
                            try json!.write(to: fileURL)
                            print("File saved: \(fileURL.absoluteURL)")
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    } catch {
                        print("error writing JSON: \(error)")
                    }
                }
                Spacer()
                List(Items, id : \.id) { Times in
                    TimeView(t : Times)
                }
            }
            Spacer()
        }
    }
}

struct TimerBuild_Previews: PreviewProvider {
    static var previews: some View {
        TimerBuild()
    }
}
