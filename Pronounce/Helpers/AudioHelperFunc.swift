//
//  AudioHelperFunc.swift
//  Pronounce
//
//  Created by asror on 09/02/26.
//

import SwiftUI

func openVoiceSettings() {
    // This URL takes the user directly to the "Voices" sub-menu in Settings
    if let url = URL(string: "App-Prefs:Accessibility&path=SPOKEN_CONTENT/VOICES") {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // Fallback for newer iOS versions if App-Prefs is restricted
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}
