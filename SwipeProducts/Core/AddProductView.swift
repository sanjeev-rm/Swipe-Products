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
                    successMessageView
                } else {
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
            .navigationTitle("Add Product")
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
    
    private var productTypeSection: some View {
        Section("Product Type") {
            Picker("Select type", selection: $addProductVM.product.productType) {
                Text("").tag("")
                ForEach(productsVM.productTypes, id: \.self) { type in
                    Text(type.uppercased())
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
            .foregroundColor(.secondary)
        }
    }
    
    private var productNameSection: some View {
        Section("Product name") {
            TextField("Enter name", text: $addProductVM.product.productName)
        }
    }
    
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
            addProductVM.taxString = addProductVM.product.tax.formatted(.number)
        }
        .onChange(of: addProductVM.taxString) {
            if let doubleValue = Double(addProductVM.taxString),
               doubleValue <= 100, doubleValue >= 0 {
                addProductVM.product.tax = doubleValue
            } else {
                addProductVM.product.tax = 0
            }
        }
    }
    
    private var imageSection: some View {
        Section("Image") {
            
            PhotosPicker(selection: $addProductVM.selectedImage,
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
            
            if addProductVM.image != nil {
                Button(role: .destructive) {
                    withAnimation(.easeOut) {
                        addProductVM.selectedImage = nil
                    }
                } label: {
                    Text("Remove Image")
                }
            }
        }
        .onChange(of: addProductVM.selectedImage) {
            Task {
                if addProductVM.selectedImage == nil {
                    addProductVM.image = nil
                } else if let image = try? await addProductVM.selectedImage?.loadTransferable(type: Image.self) {
                    addProductVM.image = image
                } else {
                    print("DEBUG: unable to load selected image")
                }
            }
        }
    }
    
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
    
    private var successMessageView: some View {
        VStack(spacing: 32) {
            Image(systemName: "checkmark")
                .dynamicTypeSize(.accessibility5)
                .font(.largeTitle)
                .foregroundColor(.green)
            
            Text("Product added!")
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundStyle(.primary.opacity(0.6))
            
            ProgressView()
                .padding(.top, 64)
                .dynamicTypeSize(.accessibility1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
