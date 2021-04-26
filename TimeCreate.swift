//
//  TimeCreate.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-23.
//

import SwiftUI
import Foundation


struct TimerItem: View {
    @State var value : Int = 0
    var body: some View {
        Text("Hello World!")
    }
}


class NumbersOnly: ObservableObject {
    
    var amt : Int = 0
    
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            if value != filtered {
                value = filtered
            }
            amt = Int(filtered) ?? 0
            print(amt)
        }
    }
}
