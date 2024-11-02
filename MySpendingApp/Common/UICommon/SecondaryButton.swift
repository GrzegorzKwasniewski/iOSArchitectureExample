//
//  SecondaryButton.swift
//  MySpendingApp
//
//  Created by Grzesiek on 29/10/2024.
//

import SwiftUI

struct SecondaryButton: View {
    
    @State var title: String = "Secondary Button"
    var onPressed: (()->())?
    
    var body: some View {
        Button {
            onPressed?()
        } label: {
            ZStack {
                Image("secondary_button")
                    .resizable()
                    .scaledToFill()
                    .padding(.horizontal, 20)
                    .frame(width: .infinity, height: 40)
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 14))
                    .padding(.horizontal)
            }
        }.foregroundColor(.white)
    }
}

#Preview {
    SecondaryButton()
}
