//
//  MealSortOrder.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/15/24.
//
//  A scalable solution to handle sorting meal items in the application

import Foundation

/// List of available sorting keys
public enum MealSortKey: String, Identifiable, CaseIterable {
    public var id: Self { self }
    
    case id = "Id"
    case name = "Name"
}

/// List of different sort order
public enum MealSortOrder: String, Identifiable, CaseIterable {
    public var id: Self { self }
    
    case ascending = "Ascending"
    case descending = "Descending"
}
