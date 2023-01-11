//
//  savedColor.swift
//  MyColors
//
//  Created by roba on 08/01/2023.
//

import UIKit
import SwiftUI

/// A simple model to keep track of tasks
class savedColor: NSObject, ObservableObject, Identifiable {

    var selectedColor: Color
    var hexValue: String
    var redValue: String
    var blueValue: String
    var greenValue: String
    var colorName: String

    init(selectedColor: Color, hexValue: String, redValue: String, blueValue: String, greenValue: String, colorName: String) {
        self.selectedColor = selectedColor
        self.hexValue = hexValue
        self.redValue = redValue
        self.blueValue = blueValue
        self.greenValue = greenValue
        self.colorName = colorName
    }


}
