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
    
    /// The product that will be added
    @Published var product = Product()
    /// The price in String format
    @Published var priceString: String = ""
    /// The tax in String format
    @Published var taxString: String = ""
    /// The PhotosPicker Item picked by the PhotosPicker in SwiftUI
    @Published var selectedImageItem: PhotosPickerItem?
    /// The image that is selected by the user
    @Published var image: Image?
    /// Shows the progress during adding a product
    @Published var showProgress: Bool = false
    /// Boolean value that is set to true, shows the success message when the product is added successfuly
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
