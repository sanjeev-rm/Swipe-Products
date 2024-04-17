//
//  ProductAPIService.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation
import SwiftUI

class ProductAPIService {
    
    /// The base url for all network urls
    static let PRODUCT_DOMAIN_URL = "https://app.getswipe.in/api/public/"
    
    /// The type of network call related to products
    enum NetworkCall {
        case getProducts
        case addProduct
        
        /// The url of network call
        var url: String {
            switch self {
            case .getProducts: PRODUCT_DOMAIN_URL + "get"
            case .addProduct: PRODUCT_DOMAIN_URL + "add"
            }
        }
    }
    
    /// The network error related to Product API
    enum NetworkError: String, Error {
        case invalidUrl = "Invalid Url"
        case failedRequest = "Failed request, status code != 200"
    }
    
    struct AddProductResponseBody: Codable {
        var message: String
        var productDetails: Product
        var productId: Int
        var isSuccess: Bool
        
        enum CodingKeys: String, CodingKey {
            case message
            case productDetails = "product_details"
            case productId = "product_id"
            case isSuccess = "success"
        }
    }
    
    /// Function to get products
    /// - returns: products
    func getProducts() async throws -> [Product] {
        guard let url = URL(string: NetworkCall.getProducts.url) else { throw NetworkError.invalidUrl }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.failedRequest }
        let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
        return decodedProducts
    }
    
    func addProduct(product: Product, image: UIImage?) async throws {
        
        var multipart = MultipartRequest()
        for field in [
            "product_name": "\(product.productName)",
            "product_type": "\(product.productType)",
            "price": product.price.formatted(),
            "tax": product.tax.formatted()
        ] {
            multipart.add(key: field.key, value: field.value)
        }
        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first,
           let image = image {
            multipart.add(
                key: "files[]",
                fileName: "\(uuid).jpg",
                fileMimeType: "image/jpeg",
                fileData: image.jpegData(compressionQuality: 0.99)!
            )
        }

        /// Create a regular HTTP URL request & use multipart components
        let url = URL(string: NetworkCall.addProduct.url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        /// Fire the request using URL sesson or anything else...
        let (data, response) = try await URLSession.shared.data(for: request)

        print("DEBUG: \((response as! HTTPURLResponse).statusCode)")
        print("DEBUG: \(String(data: data, encoding: .utf8)!)")
    }
}
