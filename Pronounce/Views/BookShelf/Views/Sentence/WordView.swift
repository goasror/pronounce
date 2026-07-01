
import SwiftUI
import UIKit
import Combine
import CoreData
import PencilKit

struct WordView: View {
    @ObservedObject var word: WordEntity
    let language: Languages
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var speech = SpeechManager()
    let recorder = Recorder()
    @Binding var isScripting: Bool
    @State private var isRecording: Bool = false
    @State private var showDictionary = false
    @State private var showHistory = false
    
    @Namespace var animation
    
    var body: some View {
        NavigationStack {
            VStack {
                // 1. Core Word Display
                WordDisplaySection(word: word) {
                    speech.speak(word.viewWordText, language: language)
                } onDoubleTap: {
                    showDictionary = true
                }
                
                // 2. Conditional Scripting Area
                if isScripting {
                    WordScriptingView(word: word, isScripting: $isScripting, animation: animation)
                        .padding(.horizontal)
                        .transition(.opacity)
                } else {
                    HStack(spacing: 20) {
                        RecordButton(systemName: isRecording ? "stop" : "mic", label: isRecording ? "Save" : "Pronounce")
                            .onTapGesture {
                                isRecording.toggle()
                                if isRecording{
                                    let data = recorder.stop()
                                    let record = RecordEntity(context: moc)
                                    record.recordData = data
                                    record.createdDate = .now
                                    word.addToRecordEntities(record)
                                    try? moc.save()
                                } else {
                                    recorder.record()
                                }
                                
                            }
                        ScriptButton(systemName: "pencil", label: "Script", animation: animation, id: "script")
                            .onTapGesture { withAnimation { isScripting = true } }
                    }
                    .padding()
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    showHistory = true
                } label: {
                    HStack {
                        Image(systemName: "clock")
                        Text("History")
                    }
                }
                .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 32, withSpacer: false))
                .padding(.top, 2)
                .padding(.trailing, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showDictionary) {
            DictionaryView(term: word.viewWordText)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showHistory) {
            WordHistoryView(word: word)
        }
    }
}
