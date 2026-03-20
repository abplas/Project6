//
//  TranslationManager.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/20/26.
//

import Foundation
import FirebaseFirestore

@Observable
class TranslationManager {

    var inputText: String = ""
    var translatedText: String = ""
    var history: [TranslationRecord] = []
    var sourceLanguage: Language = .english
    var targetLanguage: Language = .spanish
    var isLoading: Bool = false
    var errorMessage: String?

    private let db = Firestore.firestore()
    private let service = TranslationService()
    private var listener: ListenerRegistration?

    init() {
        fetchHistory()
    }

    deinit {
        listener?.remove()
    }

    func translate() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await service.translate(
                    text: trimmed,
                    source: sourceLanguage,
                    target: targetLanguage
                )

                await MainActor.run {
                    self.translatedText = result
                }

                saveTranslation(
                    sourceText: trimmed,
                    translatedText: result,
                    sourceLanguageCode: sourceLanguage.rawValue,
                    targetLanguageCode: targetLanguage.rawValue
                )

                await MainActor.run {
                    self.isLoading = false
                }

            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    // MARK: - Firestore (Manual Mapping)

    func saveTranslation(
        sourceText: String,
        translatedText: String,
        sourceLanguageCode: String,
        targetLanguageCode: String
    ) {
        let data: [String: Any] = [
            "sourceText": sourceText,
            "translatedText": translatedText,
            "sourceLanguageCode": sourceLanguageCode,
            "targetLanguageCode": targetLanguageCode,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("translations").addDocument(data: data) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func fetchHistory() {
        listener = db.collection("translations")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.history = []
                    return
                }

                self.history = documents.compactMap { document in
                    let data = document.data()

                    let sourceText = data["sourceText"] as? String ?? ""
                    let translatedText = data["translatedText"] as? String ?? ""
                    let sourceLanguageCode = data["sourceLanguageCode"] as? String ?? "?"
                    let targetLanguageCode = data["targetLanguageCode"] as? String ?? "?"
                    
                    let createdAt: Date
                    if let timestamp = data["createdAt"] as? Timestamp {
                        createdAt = timestamp.dateValue()
                    } else {
                        createdAt = Date()
                    }

                    print("Firestore data:", data)
                    return TranslationRecord(
                        id: document.documentID,
                        sourceText: sourceText,
                        translatedText: translatedText,
                        sourceLanguageCode: sourceLanguageCode,
                        targetLanguageCode: targetLanguageCode,
                        createdAt: createdAt
                    )
                }
            }
    }

    func clearHistory() {
        let ids = history.map { $0.id }

        for id in ids {
            db.collection("translations").document(id).delete()
        }
    }
}
