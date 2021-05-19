//
//  RunTime.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-24.
//

import SwiftUI
import AVFoundation


func timePrettyFormat(time: Float) -> String {
    let seconds : Int = Int(time) % 60
    var minutes : Int = (Int(time) - seconds) / 60
    if minutes >= 60 {
        while (minutes >= 60 ) {
            minutes -= 60
        }
    }
    let hours : Int = Int(time) / 3600
    let part : Int = Int(time.truncatingRemainder(dividingBy: 1) * 10)
    return String(hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) + "." + String(format: "%01d", part)
}


struct RunTime: View {
    @State var allTimes : TimeStore
    @State var benchmarks : [Int] = []
    @State var totTime : Int = 0
    @State var cTime : Decimal = 0
    @State var player : AVAudioPlayer?
    @Binding var progressValue : CGFloat
    @State var pause : Bool = false
    
    func calcSum() {
        progressValue = 0
        for t in allTimes.times {
            totTime += t.Hours * 3600 + t.Minutes * 60 + t.Seconds
            benchmarks.append(totTime)
        }
    }
    
    func doPause() {
        pause = !pause
    }
    
    func true_run(i : Decimal, ind : Int) {
        if ind >= benchmarks.count || i > Decimal(totTime) {
            return
        }
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            let url = Bundle.main.url(forResource : "preview", withExtension: "mp3")!
            do {
                var new_ind : Int = ind
                while pause {
                    continue
                }
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
                progressValue = CGFloat(NSDecimalNumber(decimal: tot_time).floatValue / Float(totTime))
                true_run(i : tot_time, ind : new_ind)
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(allTimes.name)
            Text(timePrettyFormat(time : NSDecimalNumber(decimal: cTime).floatValue)).padding().font(.largeTitle)
            ZStack {
                VStack {
                    ZStack {
                        Button(action: {
                            calcSum()
                            true_run(i : 0, ind : 0)
                        }) {
                            Text("Run").font(.largeTitle)
                                .frame(width: 250, height: 250)
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(Circle()).padding()
                        }
                        Circle()
                            .stroke(lineWidth: 20.0)
                            .opacity(0.3)
                            .foregroundColor(Color.red)
                        Circle()
                            .trim(from: 0.0, to: progressValue)
                            .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.red)
                    }.frame(width: 250.0, height: 250.0).padding(40.0)
                    Spacer()
                }
            }
            Button(action: doPause){
                Text("pause")
            }
        }
    }
}

/*struct RunTime_Previews: PreviewProvider {
    
    @State var timeArray : [Times]
    @State var progress : Float
    
    static var previews: some View {
        RunTime(allTimes: TimeStore(), progressValue: $progress)
    }
}*/
