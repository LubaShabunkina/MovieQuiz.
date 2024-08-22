//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 26/06/2024.
//

import Foundation

protocol NetworkClientProtocol: NetworkRouting {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting, NetworkClientProtocol {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
