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
            }
            
            Section("Vertical Acceleration") {
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.verticalAcceleration)
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.filteredVerticalAcceleration)
                JumpDataChart(jumpAnalysisViewModel: self.jumpCalculatorViewModel, dataKeyPath: \.relativeVerticalAcceleration)
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
