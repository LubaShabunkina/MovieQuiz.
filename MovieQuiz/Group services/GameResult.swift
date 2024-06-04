//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 03/06/2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
