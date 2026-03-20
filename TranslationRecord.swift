//
//  TranslationRecord.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/20/26.
//

import Foundation

struct TranslationRecord: Identifiable, Hashable {
    let id: String
    let sourceText: String
    let translatedText: String
    let sourceLanguageCode: String
    let targetLanguageCode: String
    let createdAt: Date
}
