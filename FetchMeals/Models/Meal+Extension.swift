//
//  Samples.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//
//  The samples defined here are used for previews as well as unit testing.
//  They all are static properties, which are lazy by default.

import Foundation

public extension Meal {
    static var sample: Self = {
        try! JSONDecoder().decode(MealWrapper.self, from: sampleJSON).meals.first!
    }()
    
    static var sampleWithDuplicates: Self = {
        try! JSONDecoder().decode(MealWrapper.self, from: sampleWithDuplicatesJSON).meals.first!
    }()
    
    static var sampleWithVariableIngredients: Self = {
        try! JSONDecoder().decode(MealWrapper.self, from: sampleWithVariableIngredientsJSON).meals.first!
    }()
    
    static let sampleJSON = """
    {
        "meals": [
            {
              "strMeal": "Chocolate Gateau",
              "strArea": "French",
              "strInstructions": "Preheat the oven to 180°C/350°F/Gas Mark 4.",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/tqtywx1468317395.jpg",
              "strTags": "Cake,Chocolate,Desert,Pudding",
              "strYoutube": "https://www.youtube.com/watch?v=dsJtgmAhFF4",
              "strIngredient1": "Plain chocolate",
              "strIngredient2": "Butter",
              "strIngredient3": "Milk",
              "strIngredient4": "Eggs",
              "strIngredient5": "Granulated Sugar",
              "strIngredient6": "Flour",
              "strIngredient7": "",
              "strIngredient8": "",
              "strIngredient9": "",
              "strIngredient10": "",
              "strIngredient11": "",
              "strIngredient12": "",
              "strIngredient13": "",
              "strIngredient14": "",
              "strIngredient15": "",
              "strIngredient16": null,
              "strIngredient17": null,
              "strIngredient18": null,
              "strIngredient19": null,
              "strIngredient20": null,
              "strMeasure1": "250g",
              "strMeasure2": "175g",
              "strMeasure3": "2 tablespoons",
              "strMeasure4": "5",
              "strMeasure5": "175g",
              "strMeasure6": "125g",
              "strMeasure7": "",
              "strMeasure8": "",
              "strMeasure9": "",
              "strMeasure10": "",
              "strMeasure11": "",
              "strMeasure12": " ",
              "strMeasure13": " ",
              "strMeasure14": " ",
              "strMeasure15": " ",
              "strMeasure16": null,
              "strMeasure17": null,
              "strMeasure18": null,
              "strMeasure19": null,
              "strMeasure20": null,
              "strSource": "http://www.goodtoknow.co.uk/recipes/536028/chocolate-gateau"
            }
        ]
    }
    """.data(using: .utf8)!
    
    static let sampleWithDuplicatesJSON = """
    {
        "meals": [
            {
              "strMeal": "Battenberg Cake",
              "strArea": "British",
              "strInstructions": "Heat oven to 180C/160C fan/gas 4",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg",
              "strTags": "Cake,Sweet",
              "strYoutube": "https://www.youtube.com/watch?v=aB41Q7kDZQ0",
              "strIngredient1": "Butter",
              "strIngredient2": "Caster Sugar",
              "strIngredient3": "Self-raising Flour",
              "strIngredient4": "Almonds",
              "strIngredient5": "Baking Powder",
              "strIngredient6": "Eggs",
              "strIngredient7": "Vanilla Extract",
              "strIngredient8": "Almond Extract",
              "strIngredient9": "Butter",
              "strIngredient10": "Caster Sugar",
              "strIngredient11": "Self-raising Flour",
              "strIngredient12": "Almonds",
              "strIngredient13": "Baking Powder",
              "strIngredient14": "Eggs",
              "strIngredient15": "Vanilla Extract",
              "strIngredient16": "Almond Extract",
              "strIngredient17": "Pink Food Colouring",
              "strIngredient18": "Apricot",
              "strIngredient19": "Marzipan",
              "strIngredient20": "Icing Sugar",
              "strMeasure1": "175g",
              "strMeasure2": "175g",
              "strMeasure3": "140g",
              "strMeasure4": "50g",
              "strMeasure5": "½ tsp",
              "strMeasure6": "3 Medium",
              "strMeasure7": "½ tsp",
              "strMeasure8": "¼ teaspoon",
              "strMeasure9": "175g",
              "strMeasure10": "175g",
              "strMeasure11": "140g",
              "strMeasure12": "50g",
              "strMeasure13": "½ tsp",
              "strMeasure14": "3 Medium",
              "strMeasure15": "½ tsp",
              "strMeasure16": "¼ teaspoon",
              "strMeasure17": "½ tsp",
              "strMeasure18": "200g",
              "strMeasure19": "1kg",
              "strMeasure20": "Dusting",
              "strSource": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake"
            }
        ]
    }
    """.data(using: .utf8)!
    
    static let sampleWithVariableIngredientsJSON = """
    {
        "meals": [
            {
              "strMeal": "Battenberg Cake",
              "strArea": "British",
              "strInstructions": "Heat oven to 180C/160C fan/gas 4",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg",
              "strTags": "Cake,Sweet",
              "strYoutube": "https://www.youtube.com/watch?v=aB41Q7kDZQ0",
              "strIngredient1": "Butter",
              "strIngredient2": "Caster Sugar",
              "strIngredient3": "Self-raising Flour",
              "strIngredient4": "Almonds",
              "strIngredient5": " ",
              "strIngredient6": null,
              "strIngredient7": "Vanilla Extract",
              "strIngredient8": "Almond Extract",
              "strIngredient17": "Pink Food Colouring",
              "strIngredient18": "Apricot",
              "strIngredient19": "Marzipan",
              "strIngredient20": "Icing Sugar",
              "strMeasure1": "175g",
              "strMeasure2": "175g",
              "strMeasure3": "140g",
              "strMeasure4": "50g",
              "strMeasure5": "½ tsp",
              "strMeasure6": "3 Medium",
              "strMeasure7": "½ tsp",
              "strMeasure8": "¼ teaspoon",
              "strMeasure17": "½ tsp",
              "strMeasure18": " ",
              "strMeasure19": null,
              "strSource": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake"
            }
        ]
    }
    """.data(using: .utf8)!
}
