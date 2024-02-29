//
//  Cat.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

struct Cat: Decodable {
    let _id: String
    let tags: [String]
    private (set) var owner: String?
    let createdAt: Date
    let updatedAt: Date
}
