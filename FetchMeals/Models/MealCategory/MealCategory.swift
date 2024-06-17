//
//  MealCategory.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/13/24.
//

import Foundation

/// Stores the result of querying categories from
/// [themealdb.com](https://themealdb.com/api.php).
public struct MealCategory: Decodable, Identifiable, Equatable {
    public static let dessert = MealCategory(id: "3", name: "Dessert")
    
    public let id: String
    public let name: String
    
    enum CodingKeys: CodingKey {
        case idCategory
        case strCategory
    }
    
    /// A custom decoder that efficiently maps json response to respective Swift objects.
    /// This is done to clean the response and avoid creation of intermediate data models.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container
            .decodeIfPresent(String.self, forKey: .idCategory)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        self.name = try container
            .decodeIfPresent(String.self, forKey: .strCategory)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

/// A wrapper model required to correctly represent the structure of json response from
/// the [themealdb.com](https://themealdb.com/api.php) api to fetch the list of all the
/// meal categories.
public struct MealCategoryWrapper: Decodable, Equatable {
    public let categories: [MealCategory]
    
    enum CodingKeys: CodingKey {
        case categories
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.categories = try container.decodeIfPresent([MealCategory].self, forKey: .categories) ?? []
    }
}
