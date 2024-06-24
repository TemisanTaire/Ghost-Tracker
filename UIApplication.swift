//
//  UIApplication.swift
//  Ghost Chain
//
//  Created by Temisan Taire on 5/19/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
