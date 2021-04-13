//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Pavlin Hristov on 25.01.21.
//

import SwiftUI

struct ContentView: View {
   @State private var countries = ["estonia", "france",
                     "germany", "ireland", "italy", "nigeria", "poland", "russia", "spain", "uk", "us"] .shuffled()
   @State private var correctAnswer = Int.random(in:0...2)
    
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var previousScore = 0
    
    @State private var isCorrect = false
    @State private var selectedNumber = 0
    @State private var fadeoutOpacity = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:[.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation{
                            self.flagTapped(number)
                        }
                    }
                    ) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth:  1))
                            .shadow(color: .black, radius: 2)
                    }
                    .rotation3DEffect(
                        .degrees(self.isCorrect && self.selectedNumber == number ? 360 : 0),
                        axis: (x:0, y:1, z:0)
                    )
                    .opacity(self.fadeoutOpacity && self.selectedNumber != number ? 0.25 : 1)
                    
                }
                Text("Current score \(score)")
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(previousScore)"),
                  dismissButton: .default(Text("Continue")) {self.askQestion()
                    
                  })
        }
    }
    
    func flagTapped(_ number: Int){
        self.selectedNumber = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            self.isCorrect = true
            self.fadeoutOpacity = true
            previousScore = score
        } else {
            scoreTitle = "Wrong thats the flag of \(countries[number])"
            previousScore = score
            score = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showingScore = true
        }
        
    }
    func askQestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.isCorrect = false
        self.fadeoutOpacity = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
