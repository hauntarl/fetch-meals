//
//  MealCategory+Samples.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/15/24.
//
//  The samples defined here are used for previews as well as unit testing.
//  They all are static properties, which are lazy by default.

import Foundation

public extension MealCategory {
    static var sample: [Self] = {
        try! JSONDecoder().decode(MealCategoryWrapper.self, from: sampleJSON).categories
    }()
    
    static var sampleEmptyAndNull: [Self] = {
        try! JSONDecoder().decode(MealCategoryWrapper.self, from: sampleEmptyAndNullJSON).categories
    }()
    
    static let sampleJSON = """
    {
      "categories": [
        {
          "idCategory": "2",
          "strCategory": "Chicken"
        },
        {
          "idCategory": "3",
          "strCategory": "Dessert"
        },
        {
          "idCategory": "5",
          "strCategory": "Miscellaneous"
        }
      ]
    }
    """.data(using: .utf8)!
    
    static let sampleEmptyAndNullJSON = """
    {
      "categories": [
        {
          "idCategory": " ",
          "strCategory": " "
        },
        {
          "idCategory": null,
          "strCategory": null
        },
        {
          "idCategory": null,
          "strCategory": "Dessert"
        },
        {
          "idCategory": "0",
          "strCategory": null
        },
        {
          "idCategory": " ",
          "strCategory": "Dessert"
        },
        {
          "idCategory": "0",
          "strCategory": " "
        }
      ]
    }
    """.data(using: .utf8)!

}
