//
//  ClimbingSessionInputView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI
import CoreData

struct ClimbingSessionInputView: View {
    @Environment(\.managedObjectContext) private var viewContext  // Access CoreData

    // MARK: - State Variables for User Input
    @State private var date = Date()
    @State private var temperature: String = ""
    @State private var isFahrenheit = false  // Toggle for Celsius/Fahrenheit
    @State private var humidity: String = ""
    @State private var skinCondition: Double = 5
    @State private var restDays: String = "0"
    @State private var climbingDays: String = "0"
    @State private var successRating: Double = 5
    @State private var notes: String = ""

    var predictedScore: Int {
        predictSessionQuality()
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Session Details Section
                Section(header: Text("Session Conditions")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundColor(Color.themeGold)

                    // Temperature input with a toggle for °C/°F
                    HStack {
                        Text("Temperature")
                            .foregroundColor(Color.themeGold)
                        TextField("Enter temperature", text: $temperature)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.themeGold)
                        Toggle(isOn: $isFahrenheit) {
                            Text(isFahrenheit ? "°F" : "°C")
                                .foregroundColor(Color.themeGold)
                        }
                    }

                    // Humidity input
                    HStack {
                        Text("Humidity (%)")
                            .foregroundColor(Color.themeGold)
                        TextField("Enter humidity", text: $humidity)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.themeGold)
                    }
                }
                
                // MARK: - Pre-Session Conditions Section
                Section(header: Text("Pre-Session Factors")) {
                    Stepper(value: $skinCondition, in: 1...10, step: 1) {
                        Text("Skin Condition: \(Int(skinCondition))")
                            .foregroundColor(Color.themeGold)
                    }

                    // Rest Days input
                    HStack {
                        Text("Rest Days")
                            .foregroundColor(Color.themeGold)
                        TextField("Days", text: $restDays)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.themeGold)
                    }

                    // Climbing Days input
                    HStack {
                        Text("Climbing Days")
                            .foregroundColor(Color.themeGold)
                        TextField("Days", text: $climbingDays)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.themeGold)
                    }
                }

                // MARK: - Predicted Session Quality Section
                Section(header: Text("Predicted Rating")) {
                    VStack {
                        Text("\(predictedScore) / 10")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(predictedScore > 5 ? .green : .red)

                        // Show explanation of what affects the score
                        Text(getPredictionExplanation())
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    }

                }

                // MARK: - Actual Performance Entry
                Section(header: Text("Actual Performance (After Climb)")) {
                    Stepper(value: $successRating, in: 0...10, step: 1) {
                        Text("Session Rating: \(Int(successRating))")
                            .foregroundColor(Color.themeGold)
                    }

                    TextField("Notes (optional)", text: $notes)
                        .foregroundColor(Color.themeGold)
                }

                // MARK: - Save Button
                Button(action: saveSession) {
                    Text("Save Session")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themeGold)
                        .foregroundColor(.black) // Contrast text for readability
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Session & Prediction")
        }
    }

    // MARK: - Compute Predicted Score Based on Inputs
    private func predictSessionQuality() -> Int {
        var score = 10  // Start with perfect conditions
        
        // Fatigue Factor: More climbing days, lower score
        score -= Int((Float(climbingDays) ?? 0) * 2)

        // Rest Factor: More rest days, better score
        score += Int(Float(restDays) ?? 0)

        // Weather Adjustments
        let temp = Float(temperature) ?? 20  // Default 20°C
        let humidityValue = Float(humidity) ?? 50  // Default 50%

        if humidityValue > 80 { score -= 1 }
        if temp < 5 { score -= 2 }
        if temp > 35 { score -= 2 }
        
        // Skin Condition: Higher = better
        score += Int(skinCondition) / 2

        // Ensure score stays within bounds
        return max(0, min(score, 10))
    }
    
    private func getPredictionExplanation() -> String {
        var reasons: [String] = []

        let temp = Float(temperature) ?? 20
        let humidityValue = Float(humidity) ?? 50

        if temp < 5 { reasons.append("It's too cold man!") }
        if temp > 28 { reasons.append("Get the fan it's hot!") }
        if humidityValue > 70 { reasons.append("What is this humidity are we swimming?") }
        if skinCondition < 3 { reasons.append("Fingertips are destroyed!") }
        if Float(climbingDays) ?? 0 > 3 { reasons.append("Some rest days por favor...?") }

        return reasons.isEmpty ? "No excuses you gotta send it!" : "Factors affecting your score: " + reasons.joined(separator: " ")
    }


    // MARK: - Save the Session for Future Predictions
    private func saveSession() {
        let newSession = ClimbingSession(context: viewContext)
        newSession.date = date
        newSession.setTemperature(Float(temperature) ?? 0, inFahrenheit: isFahrenheit)
        newSession.sessionHumidity = Float(humidity) ?? 0
        newSession.skinCondition = Int16(skinCondition)
        newSession.restDays = Int16(restDays) ?? 0
        newSession.climbingDays = Int16(climbingDays) ?? 0
        newSession.successRating = Int16(successRating)
        newSession.notes = notes.isEmpty ? nil : notes

        // Save session to CoreData
        do {
            try viewContext.save()
            print("Session saved successfully!")
        } catch {
            print("Error saving session: \(error)")
        }
    }
}
