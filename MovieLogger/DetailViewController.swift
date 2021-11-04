//
//  DetailViewController.swift
//  MovieLogger
//
//  Created by Mac Admin on 11/1/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var reviewField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    var movie: Movie! { didSet {
        navigationItem.title = movie.title
        }
    }
    var movieStore: MovieStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleField.text = movie.title
        reviewField.text = movie.review
        ratingField.text =
            numberFormatter.string(from: NSNumber(value: movie.starRating))
        dateLabel.text = dateFormatter.string(from: movie.dateCreated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)
        // "Save" changes to movie
        movie.title = titleField.text ?? ""
        movie.review = reviewField.text ?? ""
        if let ratingText = ratingField.text,
            let rating = numberFormatter.number(from: ratingText) {
            movie.starRating = rating.doubleValue
        } else {
            movie.starRating = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //This is my attempt to implement the trash button, which doesn't work right now
    @IBAction func deleteMovie(_ sender: UIBarButtonItem) {
        let title = "Delete \(movie.title)?"
        let message = "Are you sure you want to delete this item?"
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                         handler: { (action) -> Void in
                                            // Remove the item from the store self.movieStore.removeMovie(movie)
                                            // Also remove that row from the table view with an animation
                                            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                            
        })
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title:"deleteMovie", style: .default, handler:  { action in self.performSegue(withIdentifier: "deleteMovie", sender: self) }))
        // Remove the item from the store
        //movieStore.removeMovie(movie)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "deleteMovie"?:
            let itemsViewController = segue.destination as! ItemsViewController
                itemsViewController.movieStore = movieStore
        default:
                preconditionFailure("Unexpected segue identifier.")
        }
    }
}
