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
final class MoviesLoader: MoviesLoading {
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
            
            
            /*networkClient.fetch(url: mostPopularMoviesUrl) { result in
             switch result {
             case .success(let data):
             do {
             let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
             handler(.success(mostPopularMovies))
             } catch {
             handler(.failure(error))
             }
             case .failure(let error))
             }
             }
             
             
             
             
             
             struct MoviesLoader: MoviesLoading {
             
             // MARK: - NetworkClient
             private let networkClient = NetworkClient()
             
             // MARK: - URL
             private var mostPopularMoviesUrl: URL {
             // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
             
             
             func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
             
             }
             }
             }
             }*/
        }
        
    }

