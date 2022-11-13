//
//  PersistenceController.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 07.11.22.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        for i in 0..<10 {
            let recording: Recording = Recording(context: controller.container.viewContext)
            recording.startTime = Date(timeIntervalSince1970: TimeInterval(4000 * i))
        }
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        self.container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = self.container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error while saving context")
            }
        }
    }
}
