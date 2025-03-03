//
//  SendSenseApp.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI

import SwiftUI

@main
struct SendSenseApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        preloadSampleData()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.themeDarkGray)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.themeGold)]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Color.themeGold) // Back Button Color

        UITabBar.appearance().backgroundColor = UIColor(Color.themeDarkGray)
        UITabBar.appearance().tintColor = UIColor(Color.themeGold) // Active Tab Color
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force Dark Mode
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    // MARK: - Preload Sample Data if CoreData is Empty
    private func preloadSampleData() {
        let viewContext = persistenceController.container.viewContext

        let fetchRequest = ClimbingSession.fetchRequest()
        do {
            let count = try viewContext.count(for: fetchRequest)
            if count == 0 {  // If no sessions exist, insert sample data
                for i in 1...10 {
                    let newSession = ClimbingSession(context: viewContext)
                    newSession.date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                    newSession.setTemperature(Float.random(in: 10...30), inFahrenheit: false)
                    newSession.sessionHumidity = Float.random(in: 30...90)
                    newSession.skinCondition = Int16.random(in: 1...10)
                    newSession.restDays = Int16.random(in: 0...3)
                    newSession.climbingDays = Int16.random(in: 0...5)
                    newSession.successRating = Int16.random(in: 0...10)
                    newSession.notes = "Sample session #\(i)"
                }
                try viewContext.save()
                print("Sample data added!")
            }
        } catch {
            print("Error checking CoreData: \(error)")
        }
    }
}
