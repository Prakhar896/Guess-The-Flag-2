//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Prakhar Trivedi on 24/2/23.
//

import SwiftUI

struct FlagImage: View {
    var flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOverAlert = false
    @State var playerScore = 0
    @State private var scoreTitle = ""
    @State private var alertMessage = ""
    @State private var questionsCount = 1
    @State var flagTappedNumber: Int? = nil
    @State var animationAmount = 0.0
    
    @State var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"
    ].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold)) // or .largeTitle.bold() for a shorter version
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                        }
                        .opacity(flagTappedNumber == nil ? 1: flagTappedNumber == number ? 1: 0.5)
                        .rotation3DEffect(flagTappedNumber == number ? .degrees(animationAmount): .degrees(0), axis: (x: 0, y: 1, z: 0))
                        .scaleEffect(flagTappedNumber == nil ? 1: flagTappedNumber == number ? 1: 0.5)
                        .blur(radius: flagTappedNumber == nil ? 0: flagTappedNumber == number ? 0: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Question: \(questionsCount)/8")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Game over!", isPresented: $showingGameOverAlert) {
            Button("Play again", action: resetGame)
        } message: {
            Text("Your score was \(playerScore)/8")
        }
    }
    
    func flagTapped(_ number: Int) {
        // Update UI
        withAnimation {
            flagTappedNumber = number
            animationAmount += 360
        }
        
        
        // Run logic
        if number == correctAnswer {
            scoreTitle = "Correct!"
            playerScore += 1
            alertMessage = "Your score is \(playerScore)."
        } else {
            scoreTitle = "Wrong!"
            alertMessage = "That's the flag of \(countries[number]). \nYour score is \(playerScore)."
        }
        
        if questionsCount == 8 {
            showingGameOverAlert = true
        } else {
            questionsCount += 1
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagTappedNumber = nil
        animationAmount = 0
    }
    
    func resetGame() {
        playerScore = 0
        questionsCount = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagTappedNumber = nil
        animationAmount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
