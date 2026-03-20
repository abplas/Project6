//
//  Lab_6App.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/13/26.
//

import SwiftUI
import FirebaseCore

@main
struct TranslationMeApp: App {

    @State private var translationManager: TranslationManager

    init() {
        FirebaseApp.configure()
        _translationManager = State(initialValue: TranslationManager())
    }

    var body: some Scene {
        WindowGroup {
            TranslationHomeView()
                .environment(translationManager)
        }
    }
}
