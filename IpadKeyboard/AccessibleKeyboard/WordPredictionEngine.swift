//
//  WordPredictionEngine.swift
//  AccessibleKeyboard
//
//  Advanced word prediction with learning and multi-language support
//

import Foundation
import UIKit

class WordPredictionEngine {
    
    // MARK: - Singleton
    
    static let shared = WordPredictionEngine()
    
    // MARK: - Supported Languages
    
    enum Language: String, CaseIterable {
        case english = "en"
        case portugueseBrazil = "pt-BR"
        
        var textCheckerLanguage: String {
            switch self {
            case .english: return "en_US"
            case .portugueseBrazil: return "pt_BR"
            }
        }
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .portugueseBrazil: return "Português (Brasil)"
            }
        }
    }
    
    // MARK: - Properties
    
    private var currentLanguage: Language = .portugueseBrazil
    private var learnedWords: [String: Int] = [:]
    private let userDefaultsKey = "learnedWords"
    private let textChecker = UITextChecker()
    
    // Common words dictionaries with frequency scores
    private let englishWords: [String: Int] = [
        // Most common English words
        "the": 1000, "be": 950, "to": 940, "of": 930, "and": 920,
        "a": 910, "in": 900, "that": 890, "have": 880, "i": 870,
        "it": 860, "for": 850, "not": 840, "on": 830, "with": 820,
        "he": 810, "as": 800, "you": 790, "do": 780, "at": 770,
        "this": 760, "but": 750, "his": 740, "by": 730, "from": 720,
        "they": 710, "we": 700, "say": 690, "her": 680, "she": 670,
        "or": 660, "an": 650, "will": 640, "my": 630, "one": 620,
        "all": 610, "would": 600, "there": 590, "their": 580, "what": 570,
        "so": 560, "up": 550, "out": 540, "if": 530, "about": 520,
        "who": 510, "get": 500, "which": 490, "go": 480, "me": 470,
        "when": 460, "make": 450, "can": 440, "like": 430, "time": 420,
        "no": 410, "just": 400, "him": 390, "know": 380, "take": 370,
        "people": 360, "into": 350, "year": 340, "your": 330, "good": 320,
        "some": 310, "could": 300, "them": 290, "see": 280, "other": 270,
        "than": 260, "then": 250, "now": 240, "look": 230, "only": 220,
        "come": 210, "its": 200, "over": 190, "think": 180, "also": 170,
        "back": 160, "after": 150, "use": 140, "two": 130, "how": 120,
        "our": 110, "work": 100, "first": 95, "well": 90, "way": 85,
        "even": 80, "new": 75, "want": 70, "because": 65, "any": 60,
        "these": 55, "give": 50, "day": 45, "most": 40, "us": 35,
        // Additional common words
        "hello": 200, "thanks": 190, "please": 185, "sorry": 180, "yes": 175,
        "okay": 170, "great": 165, "love": 160, "need": 155, "help": 150,
        "today": 145, "tomorrow": 140, "yesterday": 135, "morning": 130, "night": 125,
        "home": 120, "call": 110, "message": 105, "send": 100,
        "email": 95, "phone": 90, "meeting": 85, "thank": 80, "welcome": 75,
        "goodbye": 70, "later": 60, "soon": 55, "much": 50
    ]
    
    private let portugueseWords: [String: Int] = [
        // Most common Portuguese (Brazil) words
        "o": 1000, "de": 990, "que": 980, "e": 970, "a": 960,
        "do": 950, "da": 940, "em": 930, "para": 910,
        "é": 905, "com": 900, "não": 890, "uma": 880, "os": 870,
        "no": 860, "se": 850, "na": 840, "por": 830, "mais": 820,
        "as": 810, "dos": 800, "como": 790, "mas": 780, "foi": 770,
        "ao": 760, "ele": 750, "das": 740, "tem": 730, "à": 720,
        "seu": 710, "sua": 700, "ou": 690, "ser": 680, "quando": 670,
        "muito": 660, "há": 650, "nos": 640, "já": 630, "está": 620,
        "eu": 610, "também": 600, "só": 590, "pelo": 580, "pela": 570,
        "até": 560, "isso": 550, "ela": 540, "entre": 530, "era": 520,
        "depois": 510, "sem": 500, "mesmo": 490, "aos": 480, "ter": 470,
        "seus": 460, "quem": 450, "nas": 440, "me": 430, "esse": 420,
        "eles": 410, "estão": 400, "você": 390, "tinha": 380, "foram": 370,
        "essa": 360, "num": 350, "nem": 340, "suas": 330, "meu": 320,
        "às": 310, "minha": 300, "têm": 290, "numa": 280, "pelos": 270,
        "elas": 260, "havia": 250, "seja": 240, "qual": 230, "será": 220,
        "nós": 210, "tenho": 200, "lhe": 190, "deles": 180, "essas": 170,
        "esses": 160, "pelas": 150, "este": 140, "fosse": 130, "dele": 120,
        // Common everyday words
        "olá": 300, "oi": 295, "obrigado": 290, "obrigada": 285,
        "desculpa": 275, "sim": 270, "bom": 265, "boa": 260, "dia": 255,
        "noite": 250, "tarde": 245, "tudo": 240, "bem": 235, "aqui": 230,
        "ali": 225, "onde": 220, "agora": 215, "hoje": 210, "amanhã": 205,
        "ontem": 200, "casa": 195, "trabalho": 190, "família": 185, "amor": 180,
        "vida": 175, "tempo": 170, "ano": 165, "vez": 160, "coisa": 155,
        "pessoa": 150, "mundo": 145, "país": 140, "cidade": 135, "nome": 130,
        "filho": 125, "filha": 120, "pai": 115, "mãe": 110, "irmão": 105,
        "irmã": 100, "amigo": 95, "amiga": 90, "comida": 85, "água": 80,
        "carro": 75, "rua": 70, "escola": 65, "igreja": 60, "hospital": 55,
        // Verbs
        "fazer": 200, "poder": 195, "dizer": 190, "ir": 185, "ver": 180,
        "dar": 175, "saber": 170, "querer": 165, "chegar": 160, "passar": 155,
        "ficar": 150, "falar": 145, "deixar": 140, "parecer": 135, "levar": 130,
        "encontrar": 125, "chamar": 120, "vir": 115, "pensar": 110, "seguir": 105,
        "sentir": 100, "começar": 95, "esperar": 90, "buscar": 85, "existir": 80,
        "entrar": 75, "trabalhar": 70, "escrever": 65, "perder": 60, "aparecer": 55,
        "criar": 50, "conhecer": 40, "tornar": 35, "viver": 30,
        // Common phrases words
        "tchau": 150, "beijo": 145, "abraço": 140, "saudade": 135, "legal": 130,
        "bacana": 125, "beleza": 120, "valeu": 115, "falou": 110, "então": 105,
        "pois": 100, "porque": 95, "porquê": 90, "ainda": 85, "sempre": 80,
        "nunca": 75, "talvez": 70, "claro": 65, "certeza": 60, "verdade": 55,
        // Numbers as words
        "zero": 50, "um": 49, "dois": 48, "três": 47, "quatro": 46,
        "cinco": 45, "seis": 44, "sete": 43, "oito": 42, "nove": 41,
        "dez": 40, "cem": 39, "mil": 38
    ]
    
    // Next word predictions based on common phrases
    private let englishNextWords: [String: [String]] = [
        "i": ["am", "have", "will", "think", "want", "need", "love", "can"],
        "you": ["are", "have", "can", "will", "want", "need", "should"],
        "how": ["are", "is", "do", "was", "about", "much", "many"],
        "what": ["is", "are", "do", "about", "time", "happened"],
        "thank": ["you", "god", "goodness"],
        "good": ["morning", "night", "afternoon", "evening", "luck", "job"],
        "see": ["you", "that", "what", "how", "if"],
        "have": ["a", "to", "you", "been", "not"],
        "the": ["best", "first", "new", "same", "other"],
        "is": ["a", "the", "not", "it", "this", "that"],
        "it": ["is", "was", "will", "can", "would"],
        "can": ["you", "i", "we", "be", "not"],
        "will": ["be", "you", "have", "not", "do"]
    ]
    
    private let portugueseNextWords: [String: [String]] = [
        "eu": ["estou", "sou", "tenho", "vou", "quero", "preciso", "amo", "posso"],
        "você": ["está", "é", "tem", "vai", "quer", "pode", "sabe"],
        "como": ["está", "vai", "você", "é", "foi", "assim"],
        "o que": ["é", "você", "aconteceu", "fazer", "houve"],
        "obrigado": ["por", "pela", "pelo", "mesmo"],
        "obrigada": ["por", "pela", "pelo", "mesmo"],
        "bom": ["dia", "trabalho", "fim", "começo", "tempo"],
        "boa": ["noite", "tarde", "sorte", "viagem", "ideia"],
        "tudo": ["bem", "certo", "bom", "isso", "aquilo"],
        "muito": ["obrigado", "obrigada", "bem", "bom", "legal"],
        "até": ["logo", "amanhã", "mais", "depois", "lá"],
        "por": ["favor", "que", "isso", "aqui", "causa"],
        "que": ["bom", "legal", "isso", "você", "tal"],
        "está": ["tudo", "bem", "aqui", "lá", "certo"],
        "vou": ["fazer", "ver", "falar", "tentar", "embora"],
        "quero": ["saber", "ver", "falar", "ir", "fazer"],
        "posso": ["fazer", "ajudar", "ir", "falar", "ver"],
        "tenho": ["que", "certeza", "tempo", "dúvida", "medo"]
    ]
    
    // MARK: - Initialization
    
    init() {
        loadLearnedWords()
        detectPreferredLanguage()
    }
    
    // MARK: - Language Detection
    
    private func detectPreferredLanguage() {
        let preferredLanguages = Locale.preferredLanguages
        for lang in preferredLanguages {
            if lang.hasPrefix("pt") {
                currentLanguage = .portugueseBrazil
                return
            } else if lang.hasPrefix("en") {
                currentLanguage = .english
                return
            }
        }
        // Default to Portuguese Brazil as requested
        currentLanguage = .portugueseBrazil
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
    }
    
    func getCurrentLanguage() -> Language {
        return currentLanguage
    }
    
    // MARK: - Word Predictions
    
    private var currentDictionary: [String: Int] {
        switch currentLanguage {
        case .english:
            return englishWords
        case .portugueseBrazil:
            return portugueseWords
        }
    }
    
    private var currentNextWords: [String: [String]] {
        switch currentLanguage {
        case .english:
            return englishNextWords
        case .portugueseBrazil:
            return portugueseNextWords
        }
    }
    
    func getPredictions(for prefix: String) -> [String] {
        guard !prefix.isEmpty else { return [] }
        
        let lowercasePrefix = prefix.lowercased()
        var matches: [(String, Int)] = []
        
        // Search in learned words first (higher priority)
        for (word, frequency) in learnedWords {
            if word.lowercased().hasPrefix(lowercasePrefix) {
                matches.append((word, frequency + 1000)) // Boost learned words
            }
        }
        
        // Search in dictionary
        for (word, frequency) in currentDictionary {
            if word.lowercased().hasPrefix(lowercasePrefix) && !matches.contains(where: { $0.0.lowercased() == word.lowercased() }) {
                matches.append((word, frequency))
            }
        }
        
        // Sort by frequency (highest first)
        matches.sort { $0.1 > $1.1 }
        
        // Return top 5 matches
        let results = matches.prefix(5).map { match -> String in
            // Match the case of the input
            if prefix.first?.isUppercase == true {
                return match.0.capitalized
            }
            return match.0
        }
        
        return Array(results)
    }
    
    func getNextWordPredictions(after word: String) -> [String] {
        let lowercaseWord = word.lowercased()
        
        if let predictions = currentNextWords[lowercaseWord] {
            return Array(predictions.prefix(3))
        }
        
        // Return most common words if no specific predictions
        let commonWords = currentDictionary
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
        
        return commonWords
    }
    
    // MARK: - Learning
    
    func learnWord(_ word: String) {
        let cleanWord = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard cleanWord.count >= 2 else { return }
        
        // Skip if it's already a very common word
        if let existingFrequency = currentDictionary[cleanWord], existingFrequency > 500 {
            return
        }
        
        // Increment the learned word count
        learnedWords[cleanWord, default: 0] += 1
        
        // Save periodically (every 5 words)
        if learnedWords.count % 5 == 0 {
            saveLearnedWords()
        }
    }
    
    // MARK: - Persistence
    
    private func loadLearnedWords() {
        if let data = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: Int] {
            learnedWords = data
        }
    }
    
    private func saveLearnedWords() {
        UserDefaults.standard.set(learnedWords, forKey: userDefaultsKey)
    }
    
    func clearLearnedWords() {
        learnedWords.removeAll()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
