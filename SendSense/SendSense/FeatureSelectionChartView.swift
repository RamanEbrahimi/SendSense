//
//  FeatureSelectionChartView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI
import Charts

struct FeatureSelectionChartView: View {
    let sessions: FetchedResults<ClimbingSession>

    // Features available for selection
    @State private var selectedFeature: FeatureType = .temperature

    var body: some View {
        VStack {
            // Picker to choose which feature to analyze
            Picker("Select Factor", selection: $selectedFeature) {
                ForEach(FeatureType.allCases, id: \.self) { feature in
                    Text(feature.rawValue).tag(feature)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Dynamic Chart Based on User Selection
            Chart {
                ForEach(sessions) { session in
                    PointMark(
                        x: .value("Feature", getFeatureValue(session, feature: selectedFeature)),
                        y: .value("Session Rating", session.successRating)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 200)
        }
        .padding()
    }

    // MARK: - Extract Feature Value from Session
    private func getFeatureValue(_ session: ClimbingSession, feature: FeatureType) -> Float {
        switch feature {
        case .temperature:
            return session.sessionTemperature
        case .humidity:
            return session.sessionHumidity
        case .skinCondition:
            return Float(session.skinCondition)
        case .restDays:
            return Float(session.restDays)
        case .climbingDays:
            return Float(session.climbingDays)
        }
    }
}

// MARK: - Enum for Feature Selection
enum FeatureType: String, CaseIterable {
    case temperature = "Temp (°C)"
    case humidity = "Humidity (%)"
    case skinCondition = "Skin"
    case restDays = "Rest"
    case climbingDays = "Climbing Days"
}
