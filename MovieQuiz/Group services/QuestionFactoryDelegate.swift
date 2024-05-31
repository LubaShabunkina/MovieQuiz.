//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 30/05/2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    
}
