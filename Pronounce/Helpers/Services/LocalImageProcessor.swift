//
//  LocalImageProcessor.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import Foundation
import Vision
import NaturalLanguage
import UIKit
import CoreData
import SwiftUI

class LocalImageProcessor {
//    func processImage(page: PageEntity, moc: NSManagedObjectContext) async {
//        do {
//            let request = WordEntity.fetchRequest()
//            var wordEntities = try moc.fetch(request)
//            let text = try await recognizeText(from: page.viewPageImage, language: page.viewLanguage)
//            let sentences = extractSentences(from: text)
//            for sentence in sentences {
//                let sentenceEntity = SentenceEntity(context: moc)
//                sentenceEntity.sentenceText = sentence
//                let words = extractWords(from: sentence)
//                for word in words {
//                    if let matchingWord = wordEntities.first(where: { $0.viewWordText == word }) {
//                        sentenceEntity.addToWordEntities(matchingWord)
//                    } else {
//                        let wordEntity = WordEntity(context: moc)
//                        wordEntity.wordText = word
//                        sentenceEntity.addToWordEntities(wordEntity)
//                        wordEntities.append(wordEntity)
//                    }
//                }
//                
//                page.addToSentenceEntities(sentenceEntity)
//            }
//            
//            try moc.save()
//        } catch {
//            print("Couldn't process image: \(error)")
//        }
//    }
    func processImage(for page: PageEntity, moc: NSManagedObjectContext) async {
        // 1. Get the raw text first
        guard let text = try? await recognizeText(from: page.viewPageImage, language: page.viewLanguage) else { return }
        
        // 2. Pre-calculate: Extract all words from this page into a Set to remove duplicates
        // We lowercase them immediately to ensure "The" matches "the"
        let sentences = extractSentences(from: text)
        let allWordsOnPage = Set(sentences.flatMap { extractWords(from: $0).map { $0.lowercased() } })
        
        // 3. OPTIMIZED FETCH: Only fetch WordEntities that match words on THIS page.
        let request = WordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "wordText IN %@", allWordsOnPage)
        
        do {
            let existingEntities = try moc.fetch(request)
            
            // 4. Create a Lookup Dictionary (Map)
            // Key: String (lowercased), Value: WordEntity
            // This makes checking if a word exists INSTANT (O(1)).
            var wordMap = Dictionary(uniqueKeysWithValues: existingEntities.map { ($0.wordText ?? "", $0) })
            
            // 5. Processing Loop
            for sentenceText in sentences {
                let sentenceEntity = SentenceEntity(context: moc)
                sentenceEntity.sentenceText = sentenceText
                
                let wordsInSentence = extractWords(from: sentenceText)
                
                for wordString in wordsInSentence {
                    let key = wordString.lowercased()
                    
                    let wordEntity: WordEntity
                    if let existing = wordMap[key] {
                        wordEntity = existing
                    } else {
                        // Create new only if missing
                        let newWord = WordEntity(context: moc)
                        newWord.wordText = key // Store normalized (lowercase)
                        wordMap[key] = newWord // Add to map so we don't create duplicates within the same page
                        wordEntity = newWord
                    }
                    
                    sentenceEntity.addToWordEntities(wordEntity)
                }
                
                page.addToSentenceEntities(sentenceEntity)
            }
            
            // 6. Save once at the end
            try moc.save()
            
        } catch {
            print("Error processing page: \(error)")
        }
    }
    
    enum OCRError: Error {
        case conversionFailed
        case processingError
    }
    
    private func recognizeText(from uiImage: UIImage, language: Languages?) async throws -> String {
        guard let cgImage = uiImage.cgImage else {
            throw OCRError.conversionFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                continuation.resume(returning: recognizedStrings.joined(separator: " "))
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            if let language {
                request.recognitionLanguages = [language.rawValue]
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func extractSentences(from text: String) -> [String] {
        var sentences: [String] = []
        
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            let sentence = String(text[tokenRange])
            
            let cleanSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !cleanSentence.isEmpty {
                sentences.append(cleanSentence)
            }
            return true
        }
        
        return sentences
    }
    func extractWords(from sentence: String) -> [String] {
        var words: [String] = []
        
        // 1. Initialize tokenizer for words
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = sentence
        
        // 2. Iterate through the tokens
        tokenizer.enumerateTokens(in: sentence.startIndex..<sentence.endIndex) { tokenRange, _ in
            let word = String(sentence[tokenRange])
            
            // 3. Clean up: ensure we aren't including standalone punctuation or whitespace
            let cleanWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Basic check: only add if it contains at least one alphanumeric character
            // This prevents things like "." or "!" being treated as "words"
            if cleanWord.rangeOfCharacter(from: .alphanumerics) != nil {
                words.append(cleanWord)
            }
            
            return true
        }
        
        return words
    }
}
