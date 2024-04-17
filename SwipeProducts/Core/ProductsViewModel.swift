//
//  ProductsViewModel.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation
import SwiftUI

@MainActor
class ProductsViewModel: ObservableObject {
    
    /// All the products retrieved from the server
    @Published var allProducts: [Product] = []
    /// Products that are being presented
    @Published var products: [Product] = []
    /// Query to search products using their name
    @Published var searchQuery: String = ""
    /// Variable that decides whether to present the Add product view or not
    @Published var showAddProductView: Bool = false
    /// Progress boolean variable to represent the progress during fetching products
    @Published var showProgress: Bool = false
    /// The list of product types currently in the database
    @Published var productTypes: [String] = []
    /// The constraint by which the products are filtered
    @Published var filterBy: FilterBy = .all
    /// The constraints by which the products are sorted
    @Published var sortBy: SortBy = .latest
    
    /// The parameter by which the products are filtered
    enum FilterBy: Hashable {
        case all
        case productType(type: String)
    }
    
    /// The parameters by which we can sort the products
    enum SortBy: String, CaseIterable, Hashable {
        case latest = "Latest"
        case name = "Name"
        case priceLowToHigh = "Price low to high"
        case priceHighToLow = "Price high to low"
    }
    
    /// Function to update the products list
    func fetchProducts() async {
        do {
            self.showProgress = true
            self.allProducts = try await ProductAPIService().getProducts()
            self.products = self.allProducts
            self.showProgress = false
            self.updateProductTypes()
        } catch(let error) {
            print("DEBUG: \(error.localizedDescription)")
        }
        filterBy = .all
        sortBy = .latest
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
    
    /// This function filters the products by the filterBy parameter in the ViewModel
    func filterProducts() {
        withAnimation(.easeInOut) {
            switch filterBy {
            case .all: products = allProducts
            case .productType(let type):
                products = allProducts.filter { product in
                    product.productType.uppercased() == type.uppercased()
                }
            }
        }
    }
    
    /// This function sorts the products by the sortBy parameter in the ViewModel
    func sortProducts() {
        withAnimation(.easeInOut) {
            products.sort { lhs, rhs in
                switch sortBy {
                case .latest:
                    return allProducts.firstIndex(of: lhs)! < allProducts.firstIndex(of: rhs)!
                case .name:
                    return lhs.productName < rhs.productName
                case .priceLowToHigh:
                    return lhs.price < rhs.price
                case .priceHighToLow:
                    return lhs.price > rhs.price
                }
            }
        }
    }
    
    func resetFilter() {
        withAnimation(.easeInOut) {
            products = allProducts
        }
    }
}
