//
//  RecordingChart.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 15.01.23.
//

import SwiftUI
import Charts

struct RecordingChart: View {
    var chartData: Chart3dDataOverTime
    
    var body: some View {
        Chart {
            ForEach(self.chartData, id: \.axis) { item in
                ForEach(Array(item.data.enumerated()), id: \.offset) { (index, dataElement) in
                    LineMark(
                        x: .value("Time", index),
                        y: .value("Data", dataElement)
                    )
                }
                .foregroundStyle(by: .value("Axis", item.axis))
            }
        }
    }
}

struct RecordingChart_Previews: PreviewProvider {
    static var previews: some View {
        RecordingChart(chartData: [])
    }
}
