//
//  Movie.swift
//  MovieLogger
//
//  Created by Mac Admin on 10/31/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class Movie: NSObject, Codable {
    var title: String
    var starRating: Double
    var review: String
    let dateCreated: Date
    
    init(title: String, review: String, starRating: Double) {
        self.title = title
        self.starRating = starRating
        self.review = review
        self.dateCreated = Date()
        super.init()
    }
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["The Haunting of", "The Return of the", "Avatar 5:", "Harry Potter and the", "The Texax Chainsaw", "Curse of the", "Pirates of the Caribbean:"]
            let nouns = ["Screaming Lake", "Queen", "Paddington 3", "Wolf", "App", "Beekeeper", "Electric Slide"]
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0...10)
            let randomStars = Double(randomValue)/2.0
            let randomReview = "So random"
            self.init(title: randomName,
                      review: randomReview,
                      starRating: randomStars)
        } else {
            self.init(title: "", review: "", starRating: 0)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(starRating, forKey: "starRating")
        aCoder.encode(review, forKey: "review")
    }
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        starRating = aDecoder.decodeObject(forKey: "starRating") as! Double
        review = aDecoder.decodeObject(forKey: "review") as! String
        super.init()
    }
}
