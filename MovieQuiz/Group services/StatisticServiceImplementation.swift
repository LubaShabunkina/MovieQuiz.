//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 12/06/2024.
//

import Foundation
import UIKit

protocol StatisticServiceAlertDelegate: AnyObject {
    func showAlert(withMessage message: String)
}

final class StatisticServiceImplementation: StatisticServiceProtocol {
    var gamesCount: Int = 0
    
    var bestGame: GameResult
    
    var totalAccuracy: Double = 0.0
    init(gamesCount: Int, bestGame: GameResult, totalAccuracy: Double, delegate: StatisticServiceAlertDelegate? = nil) {
        self.gamesCount = gamesCount
        self.bestGame = bestGame
        self.totalAccuracy = totalAccuracy
        self.delegate = delegate
    }
    
    private let storage: UserDefaults = .standard
    weak var delegate: StatisticServiceAlertDelegate?
    
    func store(correct count: Int, total amount: Int) {
        let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
        let totalQuestions = storage.integer(forKey: "totalQuestions")
        let newTotalCorrectAnswers = totalCorrectAnswers + count
        let bestScore = storage.integer(forKey: "bestScore")
        
        storage.set(newTotalCorrectAnswers + count, forKey: "totalCorrectAnswers")
        storage.set(totalQuestions + amount, forKey: "totalQuestions")
        
        if newTotalCorrectAnswers > bestScore {
            storage.set(newTotalCorrectAnswers, forKey: "bestScore")
            
            let alertMessage = """
            Поздравляем! Вы установили новый рекорд: \(newTotalCorrectAnswers) из \(totalQuestions + amount) вопросов!
            """
            delegate?.showAlert(withMessage: alertMessage)
        }
    }
}
