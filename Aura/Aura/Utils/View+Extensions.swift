//
//  View+Extensions.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        if let windowsScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene{
            let windows = windowsScene.windows
            windows.forEach{
                $0.endEditing(force)}
        }
    }
}
