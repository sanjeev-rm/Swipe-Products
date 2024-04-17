//
//  AddProductViewModel.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import Foundation
import PhotosUI
import Photos
import SwiftUI

@MainActor
class AddProductViewModel: ObservableObject {
    
    @Published var product = Product()
    @Published var priceString: String = ""
    @Published var taxString: String = ""
    @Published var selectedImage: PhotosPickerItem?
    @Published var image: Image?
    @Published var showProgress: Bool = false
    @Published var showSuccessMessage: Bool = false
    
    /// Function to check whether to disable to add button or not.
    /// It will return true until all the parametrs required to create a new product are provided by the user.
    /// - returns: Bool, if true all values are not yet provided, if false all values are provided by the user
    func isAddProductButtonDisabled() -> Bool {
        if product.price == 0 || product.productName == "" || product.productType == "" {
            return true
        }
        return false
    }
    
    /// Function to add a product
    func addProduct() {
        Task {
            do {
                self.showProgress = true
                let uiImage = (image == nil) ? nil : ImageRenderer(content: image).uiImage
                try await ProductAPIService().addProduct(product: product, image: uiImage)
                self.showProgress = false
                self.showSuccessMessage = true
            } catch(let error) {
                print("DEBUG: " + error.localizedDescription)
            }
        }
    }
}
