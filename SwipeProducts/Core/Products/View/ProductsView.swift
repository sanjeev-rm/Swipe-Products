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
            baseView
                .navigationTitle("Products")
                .toolbar {
                
                    ToolbarItem(placement: .topBarTrailing) {
                        filterMenu
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            productsViewModel.showAddProductView = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                .searchable(text: $productsViewModel.searchQuery, placement: .navigationBarDrawer, prompt: "Search by name")
                .onChange(of: productsViewModel.searchQuery) {
                    productsViewModel.searchProduct(query: productsViewModel.searchQuery)
                }
                .fullScreenCover(isPresented: $productsViewModel.showAddProductView,
                                 onDismiss: { Task { await productsViewModel.fetchProducts()} },
                                 content: {
                    AddProductView()
                })
        }
        .task {
            await productsViewModel.fetchProducts()
        }
    }
}

extension ProductsView {
    
    private var baseView: some View {
        ZStack(alignment: .top) {
            if productsViewModel.showProgress {
                ProgressView()
                    .foregroundColor(.accentColor)
                    .dynamicTypeSize(.accessibility1)
                    .frame(maxHeight: .infinity, alignment: .top)
            } else {
                List(productsViewModel.products, id: \.self) { product in
                    NavigationLink {
                        ProductView(product: product, image: nil)
                    } label: {
                        ProductCardView(product: product)
                            .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
    
    /// Menu used for filteration process
    private var filterMenu: some View {
        Menu {
            
            /// Menu to select the paramter using which the products will be filtered
            Menu {
                Picker("", selection: $productsViewModel.filterBy) {
                    Text("All").tag(ProductsViewModel.FilterBy.all)
                    ForEach(productsViewModel.productTypes, id: \.self) { type in
                        Text(type)
                            .tag(ProductsViewModel.FilterBy.productType(type: type))
                    }
                }
                .onChange(of: productsViewModel.filterBy) {productsViewModel.filterProducts()}
            } label: {
                Text("FILTER BY")
            }
            
            Divider()
            
            /// Menu used by the user to pick the correct paramter
            Menu {
                Picker("", selection: $productsViewModel.sortBy) {
                    ForEach(ProductsViewModel.SortBy.allCases, id: \.self) { sortBy in
                        Text(sortBy.rawValue)
                            .tag(sortBy)
                    }
                }
                .onChange(of: productsViewModel.sortBy) {productsViewModel.sortProducts()}
            } label: {
                Text("SORT BY")
            }
            
            Divider()
            
            /// Button to reset filter
            Button(role: .destructive) {
                productsViewModel.resetFilter()
            } label: {
                Text("Reset Filter")
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
        }
    }
}

#Preview {
    ProductsView()
        .environmentObject(ProductsViewModel())
}
