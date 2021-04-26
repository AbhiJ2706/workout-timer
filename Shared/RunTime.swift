//
//  RunTime.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-24.
//

import SwiftUI
import AVFoundation

struct RunTime: View {
    @State var allTimes : TimeStore
    @State var benchmarks : [Int] = []
    @State var totTime : Int = 0
    @State var cTime : Decimal = 0
    @State var player : AVAudioPlayer?
    
    func calcSum() {
        for t in allTimes.times {
            print(t.Seconds)
            totTime += t.Hours * 3600 + t.Minutes * 60 + t.Seconds
            benchmarks.append(totTime)
        }
    }
    
    func true_run(i : Decimal, ind : Int) {
        if ind >= benchmarks.count || i > Decimal(totTime) {
            return
        }
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            let url = Bundle.main.url(forResource : "preview", withExtension: "mp3")!
            do {
                var new_ind : Int = ind
                if i * 10 == Decimal(benchmarks[ind] * 10) {
                    print("Timer fired!" + " \(i)")
                    player = try AVAudioPlayer(contentsOf: url)
                    guard let player = player else { return }

                    player.prepareToPlay()
                    player.play()
                    new_ind += 1
                }
                var tot_time : Decimal = i
                if new_ind < benchmarks.count {
                    tot_time += 0.1
                }
                cTime = tot_time
                true_run(i : tot_time, ind : new_ind)
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(allTimes.name)
            Text(NSDecimalNumber(decimal: cTime).stringValue).padding()
            Button(action: {
                calcSum()
                true_run(i : 0, ind : 0)
            }) {
                Text("run")
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.black)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
    }
}

struct RunTime_Previews: PreviewProvider {
    
    @State var timeArray : [Times]
    
    static var previews: some View {
        RunTime(allTimes: TimeStore())
    }
}
