//
//  ContentView.swift
//  TimeConversion
//
//  Created by Mabast on 4/23/21.
//

import SwiftUI

struct ContentView: View {
    @State private var insertedValue = ""
    @State private var selectedTime = 0
    let time = ["Second", "Minute", "Hour", "Day"]
    
    
    var calculatedValue: Int {
        if selectedTime == 0 {
            return Int(insertedValue) ?? 0
        } else if selectedTime == 1 {
            return (Int(insertedValue) ?? 0) * 60
        } else if selectedTime == 2 {
            return (Int(insertedValue) ?? 0) * 60 * 60
        } else if selectedTime == 3 {
            return (Int(insertedValue) ?? 0) / 24
        } else {
            return 0
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Time to convert", text: $insertedValue)
                    .keyboardType(.decimalPad)
            }
            Section {
                Picker("Select a conversion",selection: $selectedTime) {
                    ForEach(0 ..< time.count) {
                        Text("\(time[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section {
                Text("\(calculatedValue) \(time[selectedTime])s")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
