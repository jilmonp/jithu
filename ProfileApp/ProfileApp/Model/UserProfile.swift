//
//  UserProfile.swift
//  ProfileApp
//
//  Created by jithin varghese on 28/05/20.
//  Copyright © 2020 celo. All rights reserved.
//

import Foundation


// MARK: - Profile
struct UserProfile: Codable {
    let results: [Results]
  
    init(results: [Results]) {
        self.results = results
    }
}



// MARK: - Result
struct Results: Codable {
    let gender: String
    let name: Name
    let email: String
    let dob: Dob
    let phone: String
    let picture: Picture

    init(gender: String, name: Name, email: String, dob: Dob, phone: String, picture: Picture) {
        self.gender = gender
        self.name = name
        
        self.email = email
        
        self.dob = dob
        
        self.phone = phone
        
        self.picture = picture
        
    }
}

// MARK: - Dob
struct Dob: Codable {
    let date: String

    init(date: String) {
        self.date = date
    }
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String

    init(title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String

    init(large: String, medium: String, thumbnail: String) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
}

