//
//  Meal.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//

import Foundation

/// Stores the result of querying meal details from 
/// [themealdb.com](https://themealdb.com/api.php).
public struct Meal: Decodable, Equatable {
    public let name: String
    public let thumbnailURL: URL?
    public let tags: String
    public let instructions: [String]
    public let ingredients: [Ingredient]
    public let youtubeURL: URL?
    public let sourceURL: URL?
    
    private enum CodingKeys: CodingKey {
        case strMeal
        case strMealThumb
        case strArea
        case strTags
        case strInstructions
        case strYoutube
        case strSource
    }
    
    // Make parsing ingredients and its corresponding quantities scalable
    private struct DynamicKeys: CodingKey {
        static let ingredientPrefix = "strIngredient"
        static let measurePrefix = "strMeasure"
        
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    /// A custom decoder that efficiently maps json response to respective Swift objects.
    /// This is done to clean the response and avoid creation of intermediate data models.
    ///
    /// > The constructor is doing a lot post processing on the decoded data, that
    /// > might impact the performance of the application.
    /// >
    /// > But given the scenario, the app will decode only one meal at a time in the
    /// > meal details view, and this approach makes more sense compared to delegating
    /// > the data transformation via computed properties, as SwiftUI invokes a view's
    /// > body property multiple times, which might result in same results getting
    /// > computed over and over.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container
            .decodeIfPresent(String.self, forKey: .strMeal)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let instructions = try container
            .decodeIfPresent(String.self, forKey: .strInstructions)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.instructions = instructions
            .split(separator: "\r\n")
            .map { String($0) }
        
        let area = try container
            .decodeIfPresent(String.self, forKey: .strArea)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let tags = try container
            .decodeIfPresent(String.self, forKey: .strTags)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.tags = Self.formatted(
            area: area,
            tags: tags
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        )

        let thumbnail = try container
            .decodeIfPresent(String.self, forKey: .strMealThumb)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.thumbnailURL = URL(string: "\(thumbnail)/preview")
        
        let youtube = try container
            .decodeIfPresent(String.self, forKey: .strYoutube)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.youtubeURL = URL(string: youtube)
        
        let source = try container
            .decodeIfPresent(String.self, forKey: .strSource)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.sourceURL = URL(string: source)

        // Make parsing ingredients and its corresponding quantities scalable
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        var ingredients = [String: String]()
        var measures = [String: String]()
        
        for key in dynamicContainer.allKeys {
            if key.stringValue.hasPrefix(DynamicKeys.ingredientPrefix) {
                let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key)?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                ingredients[String(key.stringValue.trimmingPrefix(DynamicKeys.ingredientPrefix))] = ingredient
            } else if key.stringValue.hasPrefix(DynamicKeys.measurePrefix) {
                let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: key)?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                measures[String(key.stringValue.trimmingPrefix(DynamicKeys.measurePrefix))] = measure
            }
        }
     
        var unique = Set<Ingredient>()
        for (key, value) in ingredients where !value.isEmpty {
            let newIngredient = Ingredient(
                name: value,
                quantity: measures[key, default: ""]
            )
            unique.insert(newIngredient)
        }
        self.ingredients = unique.sorted()
    }
    
    private static func formatted(area: String, tags: [String]) -> String {
        var result = [String]()
        if !area.isEmpty {
            result.append(area)
        }
        result.append(contentsOf: tags)
        return result.joined(separator: " • ")
    }
}

/// Combined representation of an ingredient with its corresponding measurement from
/// [themealdb.com](https://themealdb.com/api.php).
public struct Ingredient: Decodable, Equatable, Hashable, Comparable {
    public let name: String
    public let quantity: String
    public var thumbnailURL: URL? {
        .init(
            string: "\(name.replacingOccurrences(of: " ", with: "-"))-Small.png",
            relativeTo: NetworkURL.ingredient
        )
    }
    
    public init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
    }
    
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}

/// A wrapper model required to correctly represent the structure of json response from the
/// [themealdb.com](https://themealdb.com/api.php) to fetch the list of all the desserts.
public struct MealWrapper: Decodable, Equatable {
    public let meals: [Meal]
    
    enum CodingKeys: CodingKey {
        case meals
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.meals = try container.decodeIfPresent([Meal].self, forKey: .meals) ?? []
    }
}
