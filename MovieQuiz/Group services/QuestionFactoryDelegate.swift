//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 30/05/2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() //сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) //сообщение об ошибке загрузки
}
