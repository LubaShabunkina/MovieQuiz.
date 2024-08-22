import UIKit
// Основной контроллер приложения



final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    
    //MARK: - Свойства
    
    private var alertPresenter: AlertPresenter? // Презентер для отображения алертов
    
    private var presenter: MovieQuizPresenter!
    private var networkClient: NetworkClientProtocol!
    
    //MARK: - IBOutlet
    
    @IBOutlet   var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        imageView.accessibilityIdentifier = "Poster"
        counterLabel.accessibilityIdentifier = "Index"
        yesButton.accessibilityIdentifier = "Yes"
        noButton.accessibilityIdentifier = "No"
        
        let networkClient = NetworkClient()
        presenter = MovieQuizPresenter(viewController: self, networkClient: networkClient)
        
       
        _ = MoviesLoader(networkClient: networkClient)
        
        self.alertPresenter = AlertPresenter(viewController: self)
        
        // Запрос следующего вопроса
        self.presenter.questionFactory?.requestNextQuestion()
        print("requestNextQuestion called")
        
        //sendFirstRequest()
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
        // Настройка внешнего вида элементов интерфейса
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        textLabel.font = UIFont(name: "YSDisplay-Medium", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Bold", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)",
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.resetGame()
            },
            alertAccessibilityIdentifier: "Game results",
            buttonAccessibilityIdentifier: "Play again"
        )
        
        alertPresenter?.showAlert(model: alertModel)
        
        
        //Запрос следующего вопроса
        imageView.layer.borderColor = UIColor.clear.cgColor
        presenter.currentQuestionIndex += 1
        
    }
    
    
    //MARK: Networking
    
   /* func sendFirstRequest() {
        // создаём адрес
        guard let url = URL(string: "https://tv-api.com/en/API/MostPopularTVs/k_zcuw1ytf") else { return }
        // создаём запрос
        let request = URLRequest(url: url)
        
        // Создаём задачу на отправление запроса в сеть
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        // Отправляем запрос
        task.resume()
    }*/
    // MARK: - QuestionFactoryDelegate
    
    /* func didReceiveNextQuestion(question: QuizQuestion?){
     presenter.didReceiveNextQuestion(question: question)
     }*/
    /*guard let question = question else { return }
     
     currentQuestion = question
     let viewModel = presenter.convert(model: question)
     
     DispatchQueue.main.async { [weak self] in
     self?.show(quiz: viewModel)
     }
     }*/
    
    /*func didLoadDataFromServer() {
     activityIndicator.isHidden = true //скрываем индикатор загрузки
     questionFactory?.requestNextQuestion()
     
     }
     
     func didFailToLoadData(with error: Error) {
     showNetworkError(message: error.localizedDescription)// возьмём в качестве сообщения описание ошибки
     }
     */
    //MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        print("noButtonClicked called")
        presenter.noButtonClicked(sender)
        
        /*guard let currentQuestion = currentQuestion else {
         return
         }
         let givenAnswer = false
         sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
         showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)*/
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print("yesButtonClicked called")
        presenter.yesButtonClicked(sender)
    }
    /*guard let currentQuestion = currentQuestion else {
     return
     }
     let givenAnswer = true
     
     sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
     showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
     }*/
    
    //MARK: -Private functions
    
    func show(quiz step: QuizStepViewModel) {
        print("show(quiz:) called with step: \(step)")
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    /*private func convert(model: QuizQuestion) -> QuizStepViewModel {
     // Конвертация модели вопроса в модель шага квиза
     print("convert(model:) called with model: \(model)")
     return QuizStepViewModel(
     //let questionStep = QuizStepViewModel(
     image: UIImage(data: model.image) ?? UIImage(),
     question: model.text,
     questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
     )
     //return questionStep
     }*/
    
    private func changeStateButton(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    
    /*private func showNextQuestionOrResults() {
     print("showNextQuestionOrResults called")
     
     guard let statisticService = presenter.statisticService else {
     print("Error: statisticService is nil")
     return
     }
     
     // Проверка, завершены ли все вопросы
     if presenter.currentQuestionIndex == presenter.questionsAmount - 1 {
     statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
     let bestGame = statisticService.bestGame
     let dateText = formatDate(bestGame.date)
     let text = """
     Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)
     Количество сыгранных квизов: \(statisticService.gamesCount)
     Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateText))
     Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
     """*/
    
    
    
    
    /*func showAnswerResult(isCorrect: Bool) {
     
     print("showAnswerResult called with isCorrect: \(isCorrect)")
     if isCorrect {
     presenter.correctAnswers += 1
     }
     /*let answerText = isCorrect ? "ДА" : "НЕТ" */
     imageView.layer.cornerRadius = 20
     imageView.layer.masksToBounds = true
     imageView.layer.borderWidth = 8
     imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
     
     //Задержка перед показом следующего вопроса или результатов
     /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.showNextQuestionOrResults()
      
      self?.changeStateButton(true)*/
     
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
     guard let self = self else { return }
     self.imageView.layer.borderColor = UIColor.clear.cgColor
     self.presenter.correctAnswers = self.presenter.correctAnswers
     //self.presenter.questionFactory = self.questionFactory
     self.presenter.showNextQuestionOrResults()
     }
     }*/
    
    func show(quiz result: QuizResultsViewModel) {
        print("show(quiz result:) called with result: \(result)")
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.resetGame()
            },
            alertAccessibilityIdentifier: "Game results",
            buttonAccessibilityIdentifier: "Play again"
        )
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
    
    private func resetGame() {
        presenter.restartGame()
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
    
    func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
    }
    func resetImageViewBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
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
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        // Создаём модель алерта
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.currentQuestionIndex = 0
                self.presenter.correctAnswers = 0
                self.presenter.questionFactory?.requestNextQuestion()
            },
            alertAccessibilityIdentifier: "Network Error",
            buttonAccessibilityIdentifier: "Retry"
        )
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
    
    /*  let completion: () -> Void = { [weak self] in
     guard let self = self else { return }
     
     self.presenter.currentQuestionIndex = 0
     self.presenter.correctAnswers = 0
     self.presenter.questionFactory?.requestNextQuestion()
     
     // Можно также переиспользовать `model`, если требуется
     self.alertPresenter?.showAlert(model: model)
     }
     
     func resetImageViewBorder() {
     imageView.layer.borderColor = UIColor.clear.cgColor
     }
     
     // Передаём замыкание в `AlertModel`
     let alertModel = AlertModel(
     title: model.title,
     message: model.message,
     buttonText: model.buttonText,
     completion: completion
     )
     
     alertPresenter?.showAlert(model: alertModel)
     }*/
    
}
