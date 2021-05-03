//
//  ContentView.swift
//  BetterRest
//
//  Created by Mabast on 4/28/21.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("Desiered amount of slepp")) {
                    Stepper(value: $sleepAmount, in: 4 ... 12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }

                Section(header: Text("Daily Coffee intake")) {
                    Stepper(value: $coffeeAmount, in: 1 ... 20) {
                        if coffeeAmount == 1 {
                            Text("1 Cup")
                        } else {
                            Text("\(coffeeAmount) Cups")
                        }
                    }
                }
                Text("Your ideal bedtime is: \(calculateBedTime)")
            }
            .navigationTitle("Better Rest")
        }
    }

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    var calculateBedTime: String {
        let model: SleepCalculator = {
            do {
                let config = MLModelConfiguration()
                return try SleepCalculator(configuration: config)
            } catch {
                fatalError("Couldn't create SleepCalculator")
            }
        }()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minutes = (components.minute ?? 0) * 60

        do {
            let predictions = try model.prediction(wake: Double(hour + minutes), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - predictions.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, there was a problem calculating your bedtime!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
