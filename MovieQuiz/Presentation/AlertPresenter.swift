//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 02/06/2024.
//

import Foundation
import UIKit

// Класс для отображения алертов
final class AlertPresenter {
    private weak var viewController: UIViewController?// Ссылка на контроллер, на котором будет отображаться алерт
    
    //Инициализация с указанием контроллера
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //Метод для отображения алерта
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
