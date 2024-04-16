//
//  SwipeProductsApp.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 15/04/24.
//

import SwiftUI

@main
struct SwipeProductsApp: App {
    
    @StateObject var productsViewModel = ProductsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ProductsView()
                .environmentObject(productsViewModel)
        }
    }
}
