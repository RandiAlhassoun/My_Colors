//
//  dataManager.swift
//  MyColors
//
//  Created by roba on 08/01/2023.
//

import CoreData
import Foundation

/// Main data manager to handle the todo items
class dataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var savedColors: [savedColor] = [savedColor]()
    
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "Model")
    
    /// Default init method. Load the Core Data container
       override init() {
           super.init()
           container.loadPersistentStores { _, _ in }
       }
}
