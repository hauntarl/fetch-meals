//
//  MealItem.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//

import Foundation

/// Stores the result of querying meals from 
/// [themealdb.com](https://themealdb.com/api.php).
public struct MealItem: Decodable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let thumbnailURL: URL?
    
    enum CodingKeys: CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
    }
    
    /// A custom decoder that efficiently maps json response to respective Swift objects.
    /// This is done to clean the response and avoid creation of intermediate data models.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container
            .decodeIfPresent(String.self, forKey: .idMeal)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        self.name = try container
            .decodeIfPresent(String.self, forKey: .strMeal)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Store the thumbnail preview for the meal item
        let thumbnail = try container
            .decodeIfPresent(String.self, forKey: .strMealThumb)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.thumbnailURL = URL(string: "\(thumbnail)/preview")
    }
}

/// A wrapper model required to correctly represent the structure of json response from
/// the [themealdb.com](https://themealdb.com/api.php) api to fetch the list of all the
/// meals.
public struct MealItemWrapper: Decodable, Equatable {
    public let meals: [MealItem]
    
    enum CodingKeys: CodingKey {
        case meals
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.meals = try container.decodeIfPresent([MealItem].self, forKey: .meals) ?? []
    }
}
