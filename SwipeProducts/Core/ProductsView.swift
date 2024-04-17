//
//  ProductsView.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import SwiftUI

struct ProductsView: View {
    
    @EnvironmentObject var productsViewModel: ProductsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if productsViewModel.showProgress {
                    ProgressView()
                        .foregroundColor(.accentColor)
                        .dynamicTypeSize(.accessibility1)
                } else {
                    List(productsViewModel.products, id: \.self) { product in
                        NavigationLink {
                            
                        } label: {
                            ProductCardView(product: product)
                                .foregroundColor(.primary)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                Button {
                    productsViewModel.showAddProductView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .searchable(text: $productsViewModel.searchQuery, placement: .navigationBarDrawer, prompt: nil)
            .onChange(of: productsViewModel.searchQuery) {
                productsViewModel.searchProduct(query: productsViewModel.searchQuery)
            }
            .fullScreenCover(isPresented: $productsViewModel.showAddProductView,
                             onDismiss: { Task { await productsViewModel.updateProducts()} },
                             content: {
                AddProductView()
            })
        }
        .task {
            await productsViewModel.updateProducts()
        }
    }
}

#Preview {
    ProductsView()
        .environmentObject(ProductsViewModel())
}
