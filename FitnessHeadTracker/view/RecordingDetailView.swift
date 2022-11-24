//
//  RecordingsDetailView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 17.11.22.
//

import SwiftUI
import Charts

struct RecordingDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: RecordingViewModel
    
    @State private var pressedDelete: Bool = false
    
    var body: some View {
        Form {
            Section {
                if self.editMode?.wrappedValue == .active {
                    TextField("Name of this recording", text: self.$viewModel.recordingName)
                }
            }
            
            if self.editMode?.wrappedValue == .inactive {
                Section {
                    HStack {
                        Text("Time")
                        
                        Spacer()
                        
                        Text(self.viewModel.recording.startTime?.description ?? "N/A")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Duration")
                        
                        Spacer()
                        
                        Text("\(self.viewModel.recordingDuration, specifier: "%.2f") s")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Chart {
                        ForEach(self.viewModel.accelerationChartData, id: \.axis) { item in
                            ForEach(Array(item.data.enumerated()), id: \.offset) { (_, data) in
                                LineMark(
                                    x: .value("Time", data.timestamp),
                                    y: .value("Data", data.data)
                                )
                            }
                            .foregroundStyle(by: .value("Axis", item.axis))
                        }
                    }
                    .chartYScale(domain: -1...1)
                    .padding()
                }
            }
            
            Section {
                if (self.editMode!.wrappedValue == .inactive) {
                    ShareLink(item: self.viewModel.recording, preview: SharePreview(""))
                }
                
                Button {
                    self.pressedDelete = true
                } label: {
                    Label("Löschen", systemImage: "trash")
                }.foregroundColor(.red)
            }
        }
        .toolbar {
            HStack {
                EditButton()
            }
        }
        .navigationTitle(self.viewModel.recordingName)
        .navigationBarTitleDisplayMode(.automatic)
        
        .alert("Delete recording", isPresented: self.$pressedDelete) {
            Button(role: .destructive) {
                self.managedObjectContext.delete(self.viewModel.recording)
                self.dismiss.callAsFunction()
            } label: {
                Text("Delete")
            }

        } message: {
            Text("This action can not be reversed")
        }


    }
}

struct RecordingsDetailView_Previews: PreviewProvider {
    static var recording: Recording = (PersistenceController.preview.container.viewContext.registeredObjects.first as? Recording)!
    
    static var previews: some View {
        NavigationView {
            RecordingDetailView(viewModel: RecordingViewModel(recording: recording))
        }
    }
}
