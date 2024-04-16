//
//  ProductAPIService.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation

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
}
