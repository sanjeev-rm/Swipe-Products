//
//  Product.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation

struct Product: Codable, Hashable, Identifiable {
    
    var id: UUID = UUID()
    
    var image: String
    var price: Double
    var productName: String
    var productType: String
    var tax: Double
    
    init(image: String, price: Double, productName: String, productType: String, tax: Double) {
        self.image = image
        self.price = price
        self.productName = productName
        self.productType = productType
        self.tax = tax
    }
    
    init() {
        self.image = ""
        self.price = 0.0
        self.productName = ""
        self.productType = ""
        self.tax = 0.0
    }
    
    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
