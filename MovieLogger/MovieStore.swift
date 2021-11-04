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
    let movieArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("movies.archive")
    }()
    
    func saveChanges() -> Bool {
        print("Saving items to \(movieArchiveURL.path)")
        do {
            let data = try PropertyListEncoder().encode(allMovies)
            try data.write(to: movieArchiveURL)
            return true
        } catch {
            print("Error saving items: \(error) ")
        }
        return false
    }

    
    init() {
        for _ in 0..<5 {
            createMovie()
        }
        typealias allMoviesType = [Movie]?
        do {
            let data = try Data(contentsOf: movieArchiveURL)
            let decoder = PropertyListDecoder()
            if let allMovies = try decoder.decode(allMoviesType.self, from: data){
                self.allMovies = allMovies
            }
            
        } catch {
            print("movieStore init error: \(error)")
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
