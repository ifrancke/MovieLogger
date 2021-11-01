//
//  Item.swift
//  MovieLogger
//
//  Created by Mac Admin on 10/31/21.
//  Copyright © 2021 Mac Admin. All rights reserved.
//

import UIKit
class Item: NSObject {
    var title: String
    var starRating: Double
    var review: String?
    let dateCreated: Date
    
    init(title: String, review: String?, starRating: Double) {
        self.title = title
        self.starRating = starRating
        self.review = review
        self.dateCreated = Date()
        super.init()
    }
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
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
            self.init(title: "", review: nil, starRating: 0)
        }
    }
}
