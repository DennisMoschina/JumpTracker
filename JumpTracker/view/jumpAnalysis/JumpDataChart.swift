//
//  VerticalHipPositionChart.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 10.07.23.
//

import SwiftUI
import Charts

struct JumpDataChart: View {
    @ObservedObject var jumpAnalysisViewModel: JumpCalculatorViewModel
    let dataKeyPath: KeyPath<JumpCalculatorViewModel, [Double]>
    
    var body: some View {
        Group {
            if self.jumpAnalysisViewModel[keyPath: self.dataKeyPath].isEmpty {
                Text("N/A")
                    .font(.title)
            } else {
                GroupBox {
                    LineChart(values: self.jumpAnalysisViewModel[keyPath: self.dataKeyPath])
                }
            }
        }
    }
}

struct VerticalHipPositionChart_Previews: PreviewProvider {
    static var previews: some View {
        JumpDataChart(jumpAnalysisViewModel: JumpCalculatorViewModel(recording: Recording()), dataKeyPath: \.verticalHipPositions)
    }
}
