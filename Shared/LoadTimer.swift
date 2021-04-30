//
//  LoadTimer.swift
//  Workout Timer
//
//  Created by Abhi Jain on 2021-04-26.
//

import Foundation


func load(filename: String)-> [TimeStore] {
    let data: String
    let data2: Data
    do {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent(filename)
        print(path)
        data2 = try Data(contentsOf: path)
        data = try String(contentsOf: path)
        print(data)
        let decoder = JSONDecoder()
        return try decoder.decode([TimeStore].self, from: data2)
    } catch {
        print(error)
        return [TimeStore()]
    }
}


func save(filename: String, t : [TimeStore]) {
    print("hrer")
    do {
        if (t.count == 1) {
            let x : TimeStore = t[0]
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(x)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)?.data(using: String.Encoding.utf8)!
            
            let path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(filename)
            print(t[0].times)
            
            try? json!.write(to: path)
        } else {
            let x : [TimeStore] = t
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(x)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)?.data(using: String.Encoding.utf8)!
            
            let path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(filename)
            print(t[0].times)
            
            try? json!.write(to: path)
        }
        
        print("made it")
    } catch {
        print("haha no")
    }
}
