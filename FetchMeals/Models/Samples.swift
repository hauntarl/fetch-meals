//
//  Samples.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//
//  The samples defined here are used for previews as well as unit testing.
//  They all are static properties, which are lazy by default.

import Foundation

extension MealItem {
    static var sample: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleJSON)
    }()
    
    static var sampleEmpty: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleEmptyJSON)
    }()
    
    static var sampleNull: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleNullJSON)
    }()
    
    static let sampleJSON = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let sampleEmptyJSON = """
    {
      "strMeal": " ",
      "strMealThumb": " ",
      "idMeal": " "
    }
    """.data(using: .utf8)!
    
    static let sampleNullJSON = """
    {
      "strMeal": null,
      "strMealThumb": null,
      "idMeal": null
    }
    """.data(using: .utf8)!
}

extension MealItemWrapper {
    static var sample: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleJSON)
    }()
    
    static var sampleEmpty: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleEmptyJSON)
    }()
    
    static var sampleNull: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleNullJSON)
    }()
    
    static let sampleJSON = """
    {
      "meals": [
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": " ",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": null,
          "idMeal": "53049"
        },
        {
          "strMeal": " ",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": null,
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": " "
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": null
        },
      ]
    }
    """.data(using: .utf8)!
    
    static let sampleEmptyJSON = """
    {
      "meals": []
    }
    """.data(using: .utf8)!
    
    static let sampleNullJSON = """
    {
      "meals": null
    }
    """.data(using: .utf8)!
}
