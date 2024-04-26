//
//  AddProductView.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productsVM: ProductsViewModel
    @StateObject var addProductVM = AddProductViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if addProductVM.showSuccessMessage {
                    /// When product added successfuly
                    successMessageView
                } else {
                    /// Form to fill to create a new product
                    List {
                        
                        productTypeSection
                        
                        productNameSection
                        
                        sellingPriceSection
                        
                        taxSection
                        
                        imageSection
                        
                        addProductButton
                    }
                }
            }
            .navigationTitle(addProductVM.showSuccessMessage ? "" : "Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !addProductVM.showSuccessMessage {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

extension AddProductView {
    
    /// Section for selecting product type
    private var productTypeSection: some View {
        Section("Product Type") {
            Picker("Select type", selection: $addProductVM.product.productType) {
                Text("").tag("").hidden()
                ForEach(productsVM.productTypes, id: \.self) { type in
                    Text(type.uppercased())
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
            .foregroundColor(.secondary)
        }
    }
    
    /// Section for selecting product name
    private var productNameSection: some View {
        Section("Product name") {
            TextField("Enter name", text: $addProductVM.product.productName)
        }
    }
    
    /// Section for selecting product price
    private var sellingPriceSection: some View {
        Section("Selling Price") {
            HStack {
                Text("₹")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                TextField("Enter price", text: $addProductVM.priceString)
                    .keyboardType(.decimalPad)
                    .monospaced()
            }
        }
        .onChange(of: addProductVM.priceString) {
            addProductVM.product.price = Double(addProductVM.priceString) ?? 0
        }
    }
    
    /// Section for selecting product tax
    private var taxSection: some View {
        Section("Tax") {
            HStack {
                Slider(value: $addProductVM.product.tax, in: 0...100, step: 1)
                Spacer()
                TextField("0", text: $addProductVM.taxString)
                    .keyboardType(.decimalPad)
                    .frame(width: 52)
                    .monospaced()
                    .font(.title3)
            }
        }
        .onChange(of: addProductVM.product.tax) {
            // Updating the string format of the taxl, when the decimal value is updated using korean
            addProductVM.taxString = addProductVM.product.tax.formatted(.number)
        }
        .onChange(of: addProductVM.taxString) {
            // Updating the decimal format of the tax1, when the decimal value is updated using korean
            if let doubleValue = Double(addProductVM.taxString),
               doubleValue <= 100, doubleValue >= 0 {
                addProductVM.product.tax = doubleValue
            } else {
                addProductVM.product.tax = 0
            }
        }
    }
    
    /// Section to select image
    private var imageSection: some View {
        Section("Image") {
            
            /// Implemented PhotosPicker from PhotosUI
            PhotosPicker(selection: $addProductVM.selectedImageItem,
                         matching: .any(of: [.images])) {
                if let image = addProductVM.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .cornerRadius(8)
                } else {
                    Text("Add Image")
                }
            }
            
            /// If image is present then presenting an button to remove the iimage
            if addProductVM.image != nil {
                Button(role: .destructive) {
                    withAnimation(.easeOut) {
                        addProductVM.selectedImageItem = nil
                    }
                } label: {
                    Text("Remove Image")
                }
            }
        }
        .onChange(of: addProductVM.selectedImageItem) {
            /// When an item is selected / updated. Corresponding image is added to the product.
            Task {
                if addProductVM.selectedImageItem == nil {
                    /// Removed image
                    addProductVM.image = nil
                } else if let imageData = try? await addProductVM.selectedImageItem?.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: imageData) {
                    /// Presenting the image, after getting from PhotosPicker
                    addProductVM.image = Image(uiImage: uiImage)
                } else {
                    print("DEBUG: unable to load selected image")
                }
            }
        }
    }
    
    /// Section to contain add product button
    private var addProductButton: some View {
        Section {
            Button {
                print("DEBUG: button tapped")
                addProductVM.addProduct()
            } label: {
                if addProductVM.showProgress {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("Add Product")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .foregroundColor(.white)
        }
        .listRowBackground(addProductVM.isAddProductButtonDisabled() ? Color.secondary : Color.accentColor)
        .disabled(addProductVM.isAddProductButtonDisabled())
    }
    
    /// Success message that is presented once the product is added
    private var successMessageView: some View {
        VStack(spacing: 32) {
            Image(systemName: "checkmark")
                .dynamicTypeSize(.accessibility5)
                .font(.largeTitle)
                .foregroundColor(.green)
            
            Text("Added \(addProductVM.product.productName)!")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.primary.opacity(0.6))
            
            ProgressView()
                .padding(.top, 64)
                .dynamicTypeSize(.accessibility1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeOut) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddProductView()
        .environmentObject(ProductsViewModel())
}
