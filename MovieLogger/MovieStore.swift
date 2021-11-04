//
//  ItemStore.swift
//  MovieLogger
//
//  Created by Mac Admin on 10/31/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class MovieStore {
    var allMovies = [Movie]()
    
    init() {
        for _ in 0..<5 {
            createMovie()
        }
    }
    
    @discardableResult func createMovie() -> Movie {
        let newMovie = Movie(random:true)
        allMovies.append(newMovie)
        return newMovie
    }
    func removeMovie(_ movie: Movie) {
        if let index = allMovies.index(of: movie) {
            allMovies.remove(at: index)
        }
    }
    func moveMovie(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // Get reference to object being moved so you can reinsert it
        let movedMovie = allMovies[fromIndex]
        // Remove movie from array
        allMovies.remove(at: fromIndex)
        // Insert movie in array at new location
        allMovies.insert(movedMovie, at: toIndex)
    }
}
