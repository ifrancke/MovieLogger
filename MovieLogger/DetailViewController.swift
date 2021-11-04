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
        movie.review = reviewField.text
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
    
    
}
