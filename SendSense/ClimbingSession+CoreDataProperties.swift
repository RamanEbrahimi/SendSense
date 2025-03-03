//
//  ClimbingSession+CoreDataProperties.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//
//

import Foundation
import CoreData

extension ClimbingSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClimbingSession> {
        return NSFetchRequest<ClimbingSession>(entityName: "ClimbingSession")
    }

    @NSManaged public var date: Date?
    @NSManaged public var sessionTemperature: Float
    @NSManaged public var sessionHumidity: Float
    @NSManaged public var skinCondition: Int16
    @NSManaged public var restDays: Int16
    @NSManaged public var climbingDays: Int16
    @NSManaged public var successRating: Int16
    @NSManaged public var notes: String?
    @NSManaged public var usesFahrenheit: Bool  // New attribute to store user preference

    
}

extension ClimbingSession: Identifiable {
    
}

extension ClimbingSession {
    // Computed property to convert Celsius to Fahrenheit
    var temperatureInFahrenheit: Float {
        return (sessionTemperature * 9/5) + 32
    }

    // Computed property to return temperature in user’s preferred unit
    var temperatureForUser: Float {
        return usesFahrenheit ? temperatureInFahrenheit : sessionTemperature
    }
}

extension ClimbingSession {
    // Convert Fahrenheit to Celsius before saving
    func setTemperature(_ value: Float, inFahrenheit: Bool) {
        if inFahrenheit {
            self.sessionTemperature = (value - 32) * 5/9  // Convert to Celsius for storage
            self.usesFahrenheit = true
        } else {
            self.sessionTemperature = value
            self.usesFahrenheit = false
        }
    }
}

