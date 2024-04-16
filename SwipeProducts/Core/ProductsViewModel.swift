//
//  ProductsViewModel.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation

class ProductsViewModel: ObservableObject {
    
    /// All the products retrieved from the server
    @Published var allProducts: [Product] = []
    /// Products that are being presented
    @Published var products: [Product] = []
    @Published var searchQuery: String = ""
    @Published var showAddProductView: Bool = false
    @Published var showProgress: Bool = false
    
    /// The list of product types currently in the database
    @Published var productTypes: [String] = []
    
    /// Function to update the products list
    func updateProducts() async {
        do {
            self.showProgress = true
            self.allProducts = try await ProductAPIService().getProducts()
            self.products = self.allProducts
            self.showProgress = false
            self.updateProductTypes()
        } catch(let error) {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    /// Function to search products wrt the query of product name
    func searchProduct(query: String) {
        if query.isEmpty { products = allProducts; return }
        products = allProducts.filter { product in
            product.productName.localizedCaseInsensitiveContains(query)
        }
    }
    
    /// Function to update the list of product types
    /// These keeps on getting updated as other developers add new types
    func updateProductTypes() {
        var types: Set<String> = []
        for product in products {
            types.insert(product.productType)
        }
        productTypes = Array(types)
    }
}
