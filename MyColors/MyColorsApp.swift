//
//  MyColorsApp.swift
//  MyColors
//
//  Created by Rand Alhassoun on 05/01/2023.
//

import SwiftUI

@main
struct MyColorsApp: App {
    @StateObject private var manager: dataManager = dataManager()
    
    var body: some Scene {
        WindowGroup {
//            MainScreen_Camera()

            MyColors()
                .environmentObject(manager)
                               .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
