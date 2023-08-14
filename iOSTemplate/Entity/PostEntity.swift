//
//  PostEntity.swift
//  iOSTemplate
//
//  Created by ThangTQ on 14/08/2023.
//

import Foundation

// MARK: - PostEntity
struct PostEntity: Codable {
    let category: Category?
    let listPost: [ListPost]?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ListPost
struct ListPost: Codable {
    let id: Int?
    let title, content, postAt: String?
    let category: Category?
    let shortContent, urlID: String?
    let isPrivate: Bool?
    let urlImageBanner: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content, postAt, category, shortContent
        case urlID = "urlId"
        case isPrivate, urlImageBanner
    }
}
