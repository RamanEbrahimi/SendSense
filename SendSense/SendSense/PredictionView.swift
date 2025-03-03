//
//  PredictionView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI
import CoreData

struct PredictionView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch all stored climbing sessions
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClimbingSession.date, ascending: false)],
        animation: .default)
    private var sessions: FetchedResults<ClimbingSession>

    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.date ?? Date(), style: .date)
                            .font(.headline)
                        
                        HStack {
                            Text("Temp: \(formatTemperature(session))")
                            Spacer()
                            Text("Humidity: \(String(format: "%.0f", session.sessionHumidity))%")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        
                        HStack {
                            Text("Predicted Score: \(predictSessionQuality(for: session)) / 10")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Spacer()
                            Text("Success: \(session.successRating)/10")
                        }
                    }
                    .padding(5)
                }
            }
            .navigationTitle("Session Predictions")
        }
    }

    // MARK: - Format Temperature for Display
    private func formatTemperature(_ session: ClimbingSession) -> String {
        let temp = session.usesFahrenheit ? session.temperatureInFahrenheit : session.sessionTemperature
        let unit = session.usesFahrenheit ? "°F" : "°C"
        return "\(String(format: "%.1f", temp))\(unit)"
    }

    // MARK: - Basic Prediction Logic
    private func predictSessionQuality(for session: ClimbingSession) -> Int {
        var score = 10  // Start with perfect conditions
        
        // Fatigue Factor: More climbing days, lower score
        score -= Int(session.climbingDays * 2)

        // Rest Factor: More rest days, better score
        score += Int(session.restDays)

        // Weather Adjustments
        if session.sessionHumidity > 80 { score -= 1 }  // High humidity = harder grip
        if session.sessionTemperature < 5 { score -= 2 } // Too cold = harder performance
        if session.sessionTemperature > 35 { score -= 2 } // Too hot = more exhaustion
        
        // Skin Condition: Higher = better
        score += Int(session.skinCondition) / 2

        // Ensure score stays within bounds
        return max(0, min(score, 10))
    }
}
