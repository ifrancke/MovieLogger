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
    
    var item: Item! { didSet {
        navigationItem.title = item.title
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
        titleField.text = item.title
        reviewField.text = item.review
        ratingField.text =
            numberFormatter.string(from: NSNumber(value: item.starRating))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)
        // "Save" changes to item
        item.title = titleField.text ?? ""
        item.review = reviewField.text
        if let ratingText = ratingField.text,
            let rating = numberFormatter.number(from: ratingText) {
            item.starRating = rating.doubleValue
        } else {
            item.starRating = 0
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
