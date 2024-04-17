//
//  ProductCardView.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 16/04/24.
//

import SwiftUI

struct ProductCardView: View {
    
    /// Teh product that this card is reresenting in the list
    var product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            image
            
            description
            
            Spacer()
        }
        .frame(height: 125)
        .cornerRadius(16)
    }
}

extension ProductCardView {
    
    /// The view of the image
    private var image: some View {
        AsyncImage(url: URL(string: product.image)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
            default:
                    Color.accentColor.opacity(0.3)
            }
        }
        .frame(width: 125)
        .cornerRadius(16)
    }
    
    /// The description view
    private var description: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.productName)
                .font(.title3)
                .fontWeight(.regular)
            Text("₹ " + product.price.formatted(.number.rounded(increment: 0.01)))
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .fontDesign(.default)
            
            Spacer()
            
            HStack {
                Text(product.productType.uppercased())
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(4)
                    .background(.thinMaterial)
                    .cornerRadius(4)
                Text("Tax " + product.tax.formatted(.number) + "%")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(4)
                    .background(.thinMaterial)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ProductCardView(product: Product(image: "", price: 1694.91525424, productName: "Test Product", productType: "Test", tax: 18))
}
