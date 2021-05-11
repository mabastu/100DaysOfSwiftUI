//
//  AddView.swift
//  iExpense
//
//  Created by Mabast on 5/8/21.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var isNotInteger = false
    @ObservedObject var expenses: Expenses
    static let types = ["Business", "Personal"]
    @Environment(\.presentationMode) var  presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)

                Picker("Types", selection: $type) {
                    ForEach(AddView.types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add New Expense")
            .navigationBarItems(trailing:
                Button("Save") {
                    if let actualAmount = Int(amount) {
                        let item = ExpenseItem(name: name, type: type, amount: actualAmount)
                        expenses.items.append(item)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isNotInteger = true
                    }
                    
                }
            )
            .alert(isPresented: $isNotInteger) {
                Alert(title: Text("Warning!"), message: Text("The amount value must be numbers."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
