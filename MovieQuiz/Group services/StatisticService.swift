//
//  StatistcService.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 03/06/2024.
//

import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int {
        get {
            //Чтение значения из UserDefaults по ключу "gamesCount"
            return UserDefaults.standard.integer(forKey: "gamesCount")
        }
        //Запись значения newValue в UserDefaults по ключу "gamesCount"
        set { UserDefaults.standard.set(newValue, forKey: "gamesCount")
            
        }
    }
    
    
    var bestGame: GameResult {
        get {
            
            // Чтение значения correct из UserDefaults по ключу "bestGameCorrect"
            let correct = storage.integer(forKey: "bestGameCorrect")
            
            //Чтение значения total из UserDefaults по ключу "bestGameTotal"
            let total = storage.integer(forKey: "bestGameTotal")
            
            //Чтение значения date из UserDefaults по ключу "bestGameDate"
            let date = storage.object(forKey: "bestGameDate") as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            // Запись значения correct в UserDefaults по ключу "bestGameCorrect"
            storage.set(newValue.correct, forKey: "bestGameCorrect")
            
            // Запись значения total в UserDefaults по ключу "bestGameTotal"
            storage.set(newValue.total, forKey: "bestGameTotal")
            
            //Запись значения date в UserDefaults по ключу "bestGameDate"
            storage.set(newValue.date, forKey: "bestGameDate")
        }
    }
    
    var totalAccuracy: Double {
        
        get {
            
            let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
            let totalQuestions = storage.integer(forKey: "totalQuestions")
            
            guard totalQuestions != 0 else { return 0.0 }
            
            return(Double(totalCorrectAnswers) / Double(totalQuestions)) * 100
        }
    }
    func store(correct count: Int, total amount: Int) {
        
        let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
        let totalQuestions = storage.integer(forKey: "totalQuestions")
        
        storage.set(totalCorrectAnswers + count, forKey: "totalCorrectAnswers")
        storage.set(totalQuestions + amount, forKey: "totalQuestions")
    }
}

