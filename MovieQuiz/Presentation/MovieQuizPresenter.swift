//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 16/08/2024.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func resetImageViewBorder()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    //func showAlert(model: AlertModel)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var statisticService: StatisticServiceProtocol!
    var questionFactory: QuestionFactoryProtocol? // Фабрика вопросов
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        let networkClient = NetworkClient()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: networkClient), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
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
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let resultMessage = makeResultsMessage()
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: resultMessage,
                buttonText: "Сыграть ещё раз"
            )
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool){
        showAnswerResult(isCorrect: true)
    }
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }

    
    func showAnswerResult(isCorrect: Bool) {
        
        print("showAnswerResult called with isCorrect: \(isCorrect)")
        if isCorrect {
            correctAnswers += 1
        }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        /*let answerText = isCorrect ? "ДА" : "НЕТ" */
        
        //Задержка перед показом следующего вопроса или результатов
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
         guard let strongSelf = self else { return }
         strongSelf.showNextQuestionOrResults()
         
         self?.changeStateButton(true)*/
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController?.resetImageViewBorder()
            //self.correctAnswers = self.correctAnswers
            //self.presenter.questionFactory = self.questionFactory
            self.showNextQuestionOrResults()
        }
        
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
                let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
                    
                }
                alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewController?.resetImageViewBorder()
            self?.showNextQuestionOrResults()
        }

    }
}
