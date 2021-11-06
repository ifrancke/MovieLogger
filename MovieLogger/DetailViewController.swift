//
//  DetailViewController.swift
//  MovieLogger
//
//  Created by Mac Admin on 11/1/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var movie: Movie! { didSet {
        navigationItem.title = movie.title
        }
    }
    var movieStore: MovieStore!
    var imageStore: ImageStore!

    
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
        self.reviewField.layer.borderColor = UIColor.lightGray.cgColor;
        self.reviewField.layer.borderWidth = 1.0;
        self.reviewField.layer.cornerRadius = 8;
        super.viewWillAppear(animated)
        titleField.text = movie.title
        reviewField.text = movie.review
        ratingField.text =
            numberFormatter.string(from: NSNumber(value: movie.starRating))
        dateLabel.text = dateFormatter.string(from: movie.dateCreated)
        
        // Get the item key
        let key = movie.movieKey
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
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
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        // Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // Put that image on the screen in the image view
        imageView.image = image
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: movie.movieKey)
        // Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
}
