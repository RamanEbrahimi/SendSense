//
//  ContentView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

//
//  ContentView.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ClimbingSessionInputView()
                .tabItem {
                    Image(systemName: "pencil.and.outline")
                    Text("Session & Prediction")
                }

            PredictionView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Past Sessions")
                }

            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Analytics")
                }
        }
        .accentColor(Color.themeGold) // Set tab selection color to gold
        .background(Color.themeBackground) // Set background to dark
    }
}

#Preview {
    ContentView()
}
