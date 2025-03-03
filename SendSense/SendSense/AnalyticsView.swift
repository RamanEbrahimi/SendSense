//
//  AnalyticsView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI
import Charts
import CoreData

struct AnalyticsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClimbingSession.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<ClimbingSession>

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Analytics & Insights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themeGold)
                        .padding()

                    // Success Rating Over Time Chart
                    Text("Sesison Rating Over Time")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themeGold)
                    SuccessOverTimeChart(sessions: sessions)
                        .frame(height: 200)
                        .padding()

                    // Dynamic Feature Selection Chart
                    Text("Session Rating vs. Selected Factor")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themeGold)
                    FeatureSelectionChartView(sessions: sessions)
                        .padding()

                    // Text-based Insights
                    Text(getInsights())
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themeGold)
                        .padding()
                }
            }
            .navigationTitle("Analytics")
        }
    }

    // MARK: - Generate Insights Based on Data
    private func getInsights() -> String {
        guard !sessions.isEmpty else { return "No data available yet." }

        let avgTemp = sessions.map { $0.sessionTemperature }.reduce(0, +) / Float(sessions.count)
        let avgHumidity = sessions.map { $0.sessionHumidity }.reduce(0, +) / Float(sessions.count)

        return """
        - Average climbing temperature is \(String(format: "%.1f", avgTemp))°C.
        - Average humidity during sessions is \(String(format: "%.0f", avgHumidity))%.
        - Trends indicate you perform best in temperatures between 20°C and 25°C.
        """
    }
}
