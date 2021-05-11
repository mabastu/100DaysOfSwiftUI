//
//  ContentView.swift
//  iExpense
//
//  Created by Mabast on 5/7/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()

            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false

    func amountColor(amount: Int) -> Color {
        if amount > 100 {
            return .red
        } else {
            return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
                Text("iExpense")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    .padding(.top, 20)
            
                HStack {
                    EditButton()
                    Spacer()
                    Button(action: {
                        showingAddExpense = true
                    }, label: {
                        Image(systemName: "plus")

                    })

                }
                .padding(.horizontal, 20)
                List {
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .foregroundColor(Color(UIColor.darkGray))
                            }
                            Spacer()
                            Text("$\(item.amount)")
                                .foregroundColor(amountColor(amount: item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .padding()
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)
                }
            }

    }

    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
