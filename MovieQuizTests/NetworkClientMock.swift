//
//  NetworkClientMock.swift
//  MovieQuizTests
//
//  Created by Luba Shabunkina on 22/08/2024.
//

import Foundation
@testable import MovieQuiz

// Mock implementation of NetworkClientProtocol
final class NetworkClientMock: NetworkClientProtocol {
    var result: Result<Data, Error>?
    
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
