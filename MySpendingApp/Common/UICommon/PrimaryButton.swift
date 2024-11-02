//
//  PrimaryButton.swift
//  MySpendingApp
//
//  Created by Grzesiek on 29/10/2024.
//

import SwiftUI

struct PrimaryButton: View {
    
    @State var title: String = "Title"
    var onPressed: (()->())?
    
    var body: some View {
        Button {
            onPressed?()
        } label: {
            ZStack {
                Image("primary_button")
                    .resizable()
                    .scaledToFill()
                    .padding(.horizontal, 20)
                    .frame(width: .screenWidth, height: 40)
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 14))
                    .padding(.horizontal, 20)
            }
        }
        .foregroundColor(.white)
        .shadow(color: .secondaryC.opacity(0.3), radius: 5, y: 3)
    }
}

#Preview {
    PrimaryButton(title: "Primary button", onPressed: nil)
}
