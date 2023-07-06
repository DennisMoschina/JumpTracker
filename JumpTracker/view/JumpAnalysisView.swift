//
//  JumpAnalysis.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import SwiftUI

struct JumpAnalysisView: View {
    @ObservedObject var jumpCalculatorViewModel: JumpCalculatorViewModel
    
    var body: some View {
        Form {
            Section {
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
        }
    }
}

struct JumpAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        JumpAnalysisView(jumpCalculatorViewModel: JumpCalculatorViewModel(recording: Recording()))
    }
}
