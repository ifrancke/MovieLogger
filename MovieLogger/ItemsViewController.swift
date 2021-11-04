//
//  MoviesViewController.swift
//  MovieLogger
//
//  Created by Mac Admin on 10/31/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class ItemsViewController: UITableViewController {
    var movieStore: MovieStore!
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return movieStore.allMovies.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance// Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                 for: indexPath)
        
        
        // Set the text on the cell with the description of the movie
        // that is at the nth index of movies, where n = row this cell
        // will appear in on the tableview
        let movie = movieStore.allMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = String(movie.starRating)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // Create a new movie and add it to the store
        let newMovie = movieStore.createMovie()
        // Figure out where that movie is in the array
        if let index = movieStore.allMovies.index(of: newMovie) {
            let indexPath = IndexPath(row: index, section: 0)
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let movie = movieStore.allMovies[indexPath.row]
            
            let title = "Delete \(movie.title)?"
            let message = "Are you sure you want to delete this movie?"
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                             handler: { (action) -> Void in
                // Remove the movie from the store
                self.movieStore.removeMovie(movie)
                // Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        movieStore.moveMovie(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showMovie" segue
        switch segue.identifier {
        case "showMovie"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the movie associated with this row and pass it along
                let movie = movieStore.allMovies[row]
                let detailViewController
                    = segue.destination as! DetailViewController
                detailViewController.movie = movie
                detailViewController.movieStore = movieStore
            } default:
                preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }

}
