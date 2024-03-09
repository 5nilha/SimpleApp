//
//  Cat.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

struct Cat: Decodable {
    let id: String
    let tags: [String]
    private (set) var owner: String? = Cat.generateUniqueUsername()
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        tags = try container.decode([String].self, forKey: .tags)
        owner = Cat.generateUniqueUsername()
    }
    
    init(id: String, tags: [String]) {
        self.id = id
        self.tags = tags
        owner = Cat.generateUniqueUsername()
    }
    
    //Faking the user name since the real API doesn't have the data
    fileprivate static func generateUniqueUsername() -> String? {
        // Example lists of adjectives and nouns for username generation
        let stringWords = ["Ava",
                          "Mohammed",
                          "Sophia",
                          "Yuki",
                          "Lucas",
                          "Isabella",
                          "Raj",
                          "Emily",
                          "Juan",
                          "Olivia",
                          "Chen",
                          "Mia",
                          "Alexander",
                          "Zara",
                          "Liam",
                          "Grace",
                          "Noah",
                          "Santiago",
                          "Emma",
                          "Ivan",
                          "Fast",
                          "Quick",
                          "Rapid",
                          "Slow",
                          "Red",
                          "Blue",
                          "Green",
                          "Bright",
                          "Dark",
                          "Light",
                          "Cheetah",
                          "Rabbit",
                          "Turtle",
                          "Fox",
                          "Hawk",
                          "Fish",
                          "Lion",
                          "Tiger",
                          "Bear",
                          "Wolf",
                          "thoughtful",
                          "energetic",
                          "compassionate",
                          "adventurous",
                          "charismatic",
                          "diligent",
                          "empathetic",
                          "innovative",
                          "meticulous",
                          "optimistic",
                          "passionate",
                          "resilient",
                          "sincere",
                          "versatile",
                          "witty",
                          "courageous",
                          "gracious",
                          "insightful",
                          "loyal"]
        
        guard Bool.random() else { return nil }
   
        // Generate a random adjective and noun from the list
        let firstWord = stringWords.randomElement()!
        var  username = "\(firstWord)"
        
        
        if Bool.random() && Bool.random()  { // 25% chance to append a number
              // Generate a random number to ensure uniqueness
              username += "."
          }
        
        // Combine to form a unique username
        let secondWord = stringWords.randomElement()!
        username += secondWord
        
        if Bool.random() && Bool.random() { // 25% chance to append a number
              // Generate a random number to ensure uniqueness
              let randomNumber = Int.random(in: 100...999)
              
              // Append the random number to the username
              username += "\(randomNumber)"
          }
        return username
    }
}
