//
//  ContentView.swift
//  GuessTheFlag.
//
//  Created by Sebastien REMY on 13/06/2020.
//  Copyright © 2020 MonkeyDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var score = 0
    
    
    
    @State private var rotationAmount = 0.0
    @State private var showOpacity = false
    @State private var revealCorrect = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack (spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach (0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        withAnimation {
                            self.rotationAmount += 360
                            self.showOpacity = true
                        }
                    })
                    {
                        Image(self.countries[number].lowercased())
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule()
                                .stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .scaleEffect((number == self.correctAnswer && self.revealCorrect) ? 1.3 : 1)
                            .animation(.spring())
                        
                    }
                        
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity( (number == self.correctAnswer || self.revealCorrect) ? 1.0 : self.showOpacity ? 0.2 : 1.0 )
                               
                        
                }
                VStack {
                    Text("Score")
                        .foregroundColor(.white)
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("Continue"))  {
                        self.askQuestion()
                    })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            withAnimation {
                score += 1
            }
            alertTitle = "Win"
            alertMessage = "You score is \(score)!"
        } else {
            withAnimation {
                revealCorrect = true
            }
            alertTitle = "Wrong"
            alertMessage = "You chosse \(countries[number])'s flag."
        }
        
        showingAlert = true
        
    }
    
    func askQuestion() {
        withAnimation {
            self.revealCorrect = false
            self.showOpacity = false
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
