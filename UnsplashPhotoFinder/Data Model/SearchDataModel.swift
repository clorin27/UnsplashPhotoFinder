//
//  SearchDataModel.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/9/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct Photo: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoUrls
    let user: User
    let tags: [Tags]
    
    enum CodingKeys: String, CodingKey {
        case id, description, urls, user, tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case altDescription = "atl_description"
    }
}

struct PhotoUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let name: String
    let location: String?
    let bio: String?
}

struct Tags: Codable {
    let title: String?
}

// MARK: Decodable

extension SearchResults {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        total = try container.decode(Int.self, forKey: .total)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        results = try container.decode([Photo].self, forKey: .results)
    }
}

extension Photo {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        description = try? container.decode(String.self, forKey: .description)
        altDescription = try? container.decode(String.self, forKey: .altDescription)
        urls = try container.decode(PhotoUrls.self, forKey: .urls)
        user = try container.decode(User.self, forKey: .user)
        tags = try container.decode([Tags].self, forKey: .tags)
    }
}
