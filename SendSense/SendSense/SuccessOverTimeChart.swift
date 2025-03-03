//
//  SuccessOverTimeChart.swift
//  SendSense
//
//  Created by Raman on 2/25/25.
//

import SwiftUI
import Charts

struct SuccessOverTimeChart: View {
    let sessions: FetchedResults<ClimbingSession>

    var body: some View {
        Chart {
            ForEach(sessions) { session in
                if let date = session.date {
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Success Rating", session.successRating)
                    )
                    .foregroundStyle(.blue)
                }
            }
        }
    }
}
