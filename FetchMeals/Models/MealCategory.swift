//
//  MealCategory.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/13/24.
//

import Foundation

/// List of different meal categories
public enum MealCategory: String, Identifiable, CaseIterable {
    public var id: Self { self }
    
    case dessert = "Dessert"
    case seafood = "Seafood"
}
