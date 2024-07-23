import UIKit
// Основной контроллер приложения

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - Свойства
    
    private let questionsAmount: Int = 10 // Общее количество вопросов
    
    private var questionFactory: QuestionFactoryProtocol? // Фабрика вопросов
    
    private var currentQuestion: QuizQuestion? //Текущий вопрос
    
    private var currentQuestionIndex: Int = 0 // Индекс текущего вопроса
    
    private var correctAnswers: Int = 0 // Количество правильных ответов
    
    private var alertPresenter: AlertPresenter? // Презентер для отображения алертов
    
    private var statisticService: StatisticServiceProtocol!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        // Инициализация statisticService
        let statisticService = StatisticService()
        self.statisticService = statisticService
        
        // Создание фабрики вопросов и установки делегата
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        // Создание презентера алертов
        self.alertPresenter = AlertPresenter(viewController: self)
        
        // Запрос следующего вопроса
        self.questionFactory?.requestNextQuestion()
        print("requestNextQuestion called")
        
        sendFirstRequest()
        
        showLoadingIndicator()
        questionFactory.loadData()
        
        // Настройка внешнего вида элементов интерфейса
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        currentQuestionIndex = 0
        correctAnswers = 0
        
        textLabel.font = UIFont(name: "YSDisplay-Medium", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Bold", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    //MARK: Networking
    
    func sendFirstRequest() {
        // создаём адрес
        guard let url = URL(string: "https://tv-api.com/en/API/MostPopularTVs/k_zcuw1ytf") else { return }
        // создаём запрос
        let request = URLRequest(url: url)

        // Создаём задачу на отправление запроса в сеть
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        // Отправляем запрос
        task.resume()
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true //скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
        
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)// возьмём в качестве сообщения описание ошибки
    }
    //MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        print("noButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print("yesButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: -Private functions
    
    private func show(quiz step: QuizStepViewModel) {
        print("show(quiz:) called with step: \(step)")
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
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
    
    private func changeStateButton(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    
    private func showNextQuestionOrResults() {
        print("showNextQuestionOrResults called")
        
        guard let statisticService = statisticService else {
            print("Error: statisticService is nil")
            return
        }
        
        // Проверка, завершены ли все вопросы
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let dateText = formatDate(bestGame.date)
            let text = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateText))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.resetGame()
                }
            )
            alertPresenter?.showAlert(model: alertModel)
        } else {
            //Запрос следующего вопроса
            imageView.layer.borderColor = UIColor.clear.cgColor
            
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            print("requestNextQuestion called")
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        print("showAnswerResult called with isCorrect: \(isCorrect)")
        if isCorrect {
            correctAnswers += 1
        }
        /*let answerText = isCorrect ? "ДА" : "НЕТ" */
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        
        //Задержка перед показом следующего вопроса или результатов
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showNextQuestionOrResults()
            
            self?.changeStateButton(true)
        }
    }
    private func show(quiz result: QuizResultsViewModel) { //Он отвечает за отображение алерта с результатами квиза после прохождения всех вопросов.
        
        print("show(quiz result:) called with result: \(result)")
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            self?.resetGame()
        }
        alertPresenter?.showAlert(model: alertModel)
    }
    private func resetGame() {
        //Cброс состояния игры
        print("resetGame called")
        currentQuestionIndex = 0
        correctAnswers = 0
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        configureImageView()
        
        // Запрос следующего вопроса
        questionFactory?.requestNextQuestion()
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func configureImageView() {
        print("configureImageView called")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    private func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    /* let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
     guard let strongSelf = self else { return }
     strongSelf.resetGame()
     
     self.currentQuestionIndex = 0
     self.correctAnswers = 0
     let firstQuestion = self.questions[self.currentQuestionIndex]
     let viewModel = self.convert(model: firstQuestion)
     self.show(quiz: viewModel)
     }
     alert.addAction(action)
     
     self.present(alert, animated: true, completion: nil)
     }
     let currentQuestion = questions[currentQuestionIndex]
     let preparedImage = convert(model: currentQuestion)
     show(quiz: preparedImage)*/
    
    //MARK: Error
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(model: model)
    }
    
    //MARK: - Отображение
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
}


/*
 Mock-данные
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

