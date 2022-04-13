//
//  NetWorkManager.swift
//  MVVM_Practice
//
//  Created by Sandeep Tomar on 30/01/22.
//

import Foundation
import Combine
import UIKit

enum EnPoint: String {
    case movie = ""
    case movieDetails = "h"
}

enum NetworkError {
    case invalidUrl, responseError, Unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("Invalid Url", comment: "")
        case .responseError:
            return NSLocalizedString("Unauthorized Access", comment: "")
        case .Unknown:
            return NSLocalizedString("Other Error", comment: "")
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {
        
    }
    private var baseUrl = "https://gorest.co.in/public/v2/users"
    private var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(endPoint: EnPoint, id: Int? = nil, typle: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
           
            guard let self = self, let url = URL(string: self.baseUrl) else {
                return promise(.failure(NetworkError.invalidUrl))
            }
            
            print("URL is", url.absoluteString)
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                guard let httpresponse = response as? HTTPURLResponse, 200...299 ~= httpresponse.statusCode else {
                    throw NetworkError.responseError
                }
                let jsonResponse =  try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
            
                    let newurl = Bundle.main.url(forResource: "movies", withExtension: "json")
                    
                    let newdata = try Data(contentsOf: newurl!)
            
                    do {
                        let decoder = JSONDecoder()
                        let messages = try decoder.decode([MovieModel].self, from: newdata)
                        print(messages as Any)
                    } catch DecodingError.dataCorrupted(let context) {
                        print(context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                return newdata
            }.decode(type: [T].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.Unknown))
                        }
                    }
                    
                }, receiveValue: { promise(.success($0))})
                .store(in: &self.cancellables)
        }
    }
}
