//
//  Pet.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import Foundation

// MARK: - Pet
struct Pet: Codable {
    let id: Int?
    let category: Category?
    let name: String?
    let photoUrls: [String]?
    let tags: [Category]?
    let status: String?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
}
