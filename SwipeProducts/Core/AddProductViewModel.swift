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

class AddProductViewModel: ObservableObject {
    
    @Published var product = Product()
    @Published var priceString: String = ""
    @Published var taxString: String = ""
    @Published var selectedImage: PhotosPickerItem?
    @Published var image: Image?
    @Published var showProgress: Bool = false
    @Published var showSuccessMessage: Bool = false
    
    func isAddProductButtonDisabled() -> Bool {
        if product.price == 0 || product.productName == "" {
            return true
        }
        return false
    }
    
    func addProduct() {
        withAnimation(.easeIn) {
            showSuccessMessage = true
        }
    }
}
