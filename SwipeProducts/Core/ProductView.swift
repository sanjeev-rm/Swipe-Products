//
//  ProductView.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 17/04/24.
//

import SwiftUI

struct ProductView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var product: Product
    var image: Image?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default:
                        Color.accentColor.opacity(0.3)
                }
            }
            .frame(height: UIScreen.main.bounds.width - 100)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(product.productName)
                    .font(.title.bold())
                Text("₹" + product.price.formatted(.number.rounded(increment: 0.01)))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(product.productType.uppercased())
                    .font(.callout.bold())
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(8)
                Text(product.tax.formatted(.number) + "% Tax")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            UINavigationBar.appearance().barTintColor = .white
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductView(product: Product(image: "", price: 1694.91525424, productName: "Test Product", productType: "Test", tax: 18))
    }
}
