//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Luba Shabunkina on 26/06/2024.
//

import Foundation



protocol MoviesLoading {
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

protocol NetworkRouting {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class MoviesLoader: MoviesLoading {
    
    private let networkClient: NetworkRouting
    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }
    
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                completion( .success(mostPopularMovies))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
        
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    completion(.success(mostPopularMovies))
                                    } catch {
                                        completion(.failure(error))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
            }
        }
    }
}
             
             
             
             
