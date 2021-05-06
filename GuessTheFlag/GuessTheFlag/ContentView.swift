//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mabast on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var selectedFlag = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                VStack() {
                    Text("Tap the flag...")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.heavy)
                }
                .padding(.top, 50)
                
                ForEach(0 ..< 3) { item in
                    Button(action: {
                        flagTapped(item)
                    }, label: {
                        Image(countries[item])
                            .renderingMode(.original)
                            .flagImage()
                    })
                    
                }
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore , content: {
            Alert(title: Text(scoreTitle), message: Text("That’s the flag of \(countries[selectedFlag])."), dismissButton: .default(Text("Continue")) {
                askQuestion()
            })
        })
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            countries.shuffle()
        } else {
            scoreTitle = "Wrong"
            showingScore = true
            if score > 0 {
                score -= 1
            }
            selectedFlag = number
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: Color.black ,radius: 2)
    }
}

extension View {
    func flagImage() -> some View {
        modifier(FlagImage())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
