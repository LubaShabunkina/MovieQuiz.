//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 16/08/2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        // Конвертация модели вопроса в модель шага квиза
        print("convert(model:) called with model: \(model)")
        return QuizStepViewModel(
            //let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        //return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
     func yesButtonClicked(_ sender: UIButton) {
        print("yesButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked(_ sender: UIButton) {
        print("noButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
