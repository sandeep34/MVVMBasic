//
//  MoviewViewModel.swift
//  MVVM_Practice
//
//  Created by Sandeep Tomar on 31/01/22.
//

import Foundation
import Combine
import UIKit

class MovieViewModel {
    
    private var cancellable = Set<AnyCancellable>()
    @Published var movieData = [MovieModel]()
    var movieObs: Sandeep<[MovieModel]> = Sandeep([])
    func getDataFromServer() {
        
        
        NetworkManager.shared.getData(endPoint: EnPoint.movie, id: 0, typle: MovieModel.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error", err.localizedDescription)
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] movieDataValue in
                self?.movieData = movieDataValue
                self?.movieObs.value = movieDataValue
            }.store(in: &cancellable)
        }
}
