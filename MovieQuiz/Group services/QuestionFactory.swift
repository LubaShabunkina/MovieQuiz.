//
//  File.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 29/05/2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    private let questions: [QuizQuestion] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    /*QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false)
     ] */
    
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
            guard let self = self else { return }
                switch result {
                case .success (let mostPopularMovies):
                    print("Работает")
                    self.movies = mostPopularMovies.items
                                        self.delegate?.didLoadDataFromServer()
                                    case .failure(let error):
                                        self.delegate?.didFailToLoadData(with: error)
                    /*guard let movie = mostPopularMovies.items.randomElement() else {
                        print("Перестало работать")
                        return }
                    let imageData = try? Data(contentsOf: movie.imageURL)
                    let quizQuestion = QuizQuestion(image: imageData ?? Data(), text: movie.title, correctAnswer: true)
                    self.delegate?.didReceiveNextQuestion(question: quizQuestion)
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)// сообщаем об ошибке нашему MovieQuizViewController */
                    
                    
                }
            }
        }
        
    }
    
    func requestNextQuestion()  {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let movie = self.movies.randomElement() else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let randomRatingThreshold = Double.random(in: 5.0...9.0)
            let questionText = "Рейтинг этого фильма больше чем \(String(format: "%.1f", randomRatingThreshold))?"
            let correctAnswer = (Double(movie.rating) ?? 0) > randomRatingThreshold
            
            let question = QuizQuestion(
                image: imageData,
                text: questionText,
                correctAnswer: correctAnswer
            )
            
            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
         
    
