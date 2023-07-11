//
//  JumpAnalysis.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import SwiftUI

struct JumpAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var jumpCalculatorViewModel: JumpCalculatorViewModel
    
    var body: some View {
        Form {
            Section("Jump Height") {
                HStack {
                    Text("measured")
                    
                    Text("\(jumpCalculatorViewModel.measuredJumpHeight)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("calculated")
                    
                    Text("\(jumpCalculatorViewModel.calculatedJumpHeight)")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Measured vertical Position") {
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.verticalHipPositions)
                    .chartYAxisLabel(position: .overlay) {
                        Text("Measured Vertical Position [m]")
                            .font(.body)
                            .foregroundColor(.black)
                    }
            }
            
            Section("Vertical Acceleration") {
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.verticalAcceleration)
                    .chartYAxisLabel(position: .overlay) {
                        Text("Raw verticle Acceleration [m/s^2]")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.filteredVerticalAcceleration)
                    .chartYAxisLabel(position: .overlay) {
                        Text("Filtered verticle Acceleration [m/s^2]")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.relativeVerticalAcceleration)
                    .chartYAxisLabel(position: .overlay) {
                        Text("Relative verticle Acceleration [m/s^2]")
                            .font(.body)
                            .foregroundColor(.black)
                    }
            }
        }
        .navigationTitle("Jump Analysis")
        .toolbar {
            Button("Done") {
                self.dismiss()
            }
        }
    }
}

struct JumpAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        JumpAnalysisView(jumpCalculatorViewModel: JumpCalculatorViewModel(recording: Recording()))
    }
}
