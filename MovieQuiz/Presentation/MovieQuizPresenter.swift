//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 16/08/2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    var questionFactory: QuestionFactoryProtocol? // Фабрика вопросов
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    
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
         didAnswer(isYes: true)
         
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        
    }
    
    func noButtonClicked(_ sender: UIButton) {
        print("noButtonClicked called")
        didAnswer(isYes: false)
        
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
            func showNextQuestionOrResults() {
                if self.isLastQuestion() {
                    let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                    
                    let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    viewController?.show(quiz: viewModel)
                } else {
                    self.switchToNextQuestion()
                    questionFactory?.requestNextQuestion()
                }
            }
        }

