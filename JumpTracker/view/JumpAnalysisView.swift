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
        NavigationStack {
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
            .navigationTitle("Jump Analysis")
            .toolbar {
                Button("Done") {
                    self.dismiss()
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
