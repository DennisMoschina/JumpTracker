//
//  LineChart.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 10.07.23.
//

import SwiftUI
import Charts

struct LineChart: View {
    var values: [Double]
    
    var body: some View {
        Chart(Array(self.values.enumerated()), id: \.offset) { value in
            LineMark(
                x: .value("Time", value.offset),
                y: .value("", value.element)
            )
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(values: [
            1, 2, 3, 4, 5, 6, 7, 8
        ])
    }
}
