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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        // Создание фабрики вопросов и установки делегата
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        // Создание презентера алертов
        self.alertPresenter = AlertPresenter(viewController: self)
        
        /* questionFactory = QuestionFactory(delegate: self)*/
        
        // Запрос следующего вопроса
        self.questionFactory?.requestNextQuestion()
        print("requestNextQuestion called")
        
        // Настройка внешнего вида элементов интерфейса
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        currentQuestionIndex = 0
        correctAnswers = 0
    
        textLabel.font = UIFont(name: "YSDisplay-Medium", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Bold", size: 20)
        
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
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
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    } 
    private func showNextQuestionOrResults() {
        // Проверка, завершены ли все вопросы
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: {[weak self] in
                    self?.resetGame()
                }
                )
            alertPresenter?.showAlert(model: alertModel)
        } else {
            //Запрос следующего вопроса
            imageView.layer.borderColor = UIColor.clear.cgColor
            
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        print("showAnswerResult called with isCorrect: \(isCorrect)")
        if isCorrect {
            correctAnswers += 1
        }
        /*let answerText = isCorrect ? "ДА" : "НЕТ"*/
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        
        //Задержка перед показом следующего вопроса или результатов
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            //guard let strongSelf = self else { return }
            self?.showNextQuestionOrResults() //strongSelf.showNextQuestionOrResults()
        }
    }
   /* private func show(quiz result: QuizResultsViewModel) { //Он отвечает за отображение алерта с результатами квиза после прохождения всех вопросов.

        print("show(quiz result:) called with result: \(result)")
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.resetGame()
        
            /*self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)*/
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    } */
    
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
        private func configureImageView() {
            print("configureImageView called")
               imageView.layer.cornerRadius = 20
               imageView.layer.masksToBounds = true
               imageView.layer.borderWidth = 8
               imageView.layer.borderColor = UIColor.clear.cgColor
    }
            
        /*let currentQuestion = questions[currentQuestionIndex]
        let preparedImage = convert(model: currentQuestion)
        show(quiz: preparedImage)*/
    
    /*let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(answerText)",
                preferredStyle: .alert)
            */
        
    //MARK: - Отображение
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
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

