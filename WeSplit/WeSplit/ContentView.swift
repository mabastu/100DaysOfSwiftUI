//
//  ContentView.swift
//  WeSplit
//
//  Created by Mabast on 4/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    @State private var tipIndex = false
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople) ?? 0 + 2
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var totalCheck: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount per person")) {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    Section {
                        TextField("Number Of People", text: $numberOfPeople)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section(header: Text("How much tips do you want to leave?")) {
                    Picker("Tip Percentages", selection: $tipPercentage) {
                        ForEach (0 ..< tipPercentages.count) {
                            Text("\(tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Check Amount")) {
                    Text("$\(totalCheck,specifier: "%.2f")")
                }
                Section(header: Text("Amount Per Person")) {
                    Text("$\(totalPerPerson,specifier: "%.2f")")
                        .foregroundColor(tipPercentages[tipPercentage] == 0 ? .red : .black)
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
