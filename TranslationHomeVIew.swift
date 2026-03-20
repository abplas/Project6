//
//  TranslationHomeVIew.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/20/26.
//

import SwiftUI

struct TranslationHomeView: View {

    @Environment(TranslationManager.self) var manager

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter text")
                            .foregroundStyle(.white)
                            .font(.headline)

                        TextField("Type something to translate...", text: Bindable(manager).inputText)
                            .padding()
                            .background(Color(.systemGray6).opacity(0.15))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    HStack(spacing: 12) {
                        Picker("From", selection: Bindable(manager).sourceLanguage) {
                            ForEach(Language.allCases) {
                                Text($0.displayName).tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(.systemGray6).opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .tint(.white)

                        Picker("To", selection: Bindable(manager).targetLanguage) {
                            ForEach(Language.allCases) {
                                Text($0.displayName).tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(.systemGray6).opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .tint(.white)
                    }

                    Button {
                        manager.translate()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Translate")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Translation")
                            .foregroundStyle(.white)
                            .font(.headline)

                        Text(manager.translatedText.isEmpty ? "Translation appears here" : manager.translatedText)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                            .background(Color(.systemGray6).opacity(0.15))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Divider()
                        .overlay(Color.white.opacity(0.2))

                    HStack {
                        Text("History")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Spacer()

                        Button("Clear") {
                            manager.clearHistory()
                        }
                        .foregroundStyle(.red)
                    }

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(manager.history) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.sourceText.isEmpty ? "(no source text)" : item.sourceText)
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Text(item.translatedText.isEmpty ? "(no translation)" : item.translatedText)
                                        .foregroundColor(.cyan)

                                    Text("\(item.sourceLanguageCode.uppercased()) → \(item.targetLanguageCode.uppercased())")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("TranslationMe")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TranslationHomeView()
        .environment(TranslationManager())
        .preferredColorScheme(.dark)
}
