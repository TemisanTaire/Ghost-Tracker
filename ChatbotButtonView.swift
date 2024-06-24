//
//  ChatbotView.swift
//  Ghost Chain
//
//  Created by Temisan Taire on 5/30/24.
//

import SwiftUI

struct ChatbotButtonView: View {
    
    @State private var showChatBot: Bool = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: ChatBotView()) {
                Image(systemName: "person.bubble")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 10, trailing: 10))
                    .background(
                        Rectangle().foregroundColor(Color.theme.accent).opacity(0.4).cornerRadius(30)
                    )
            }
        }
    }
}

struct ChatbotButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotButtonView()
            .previewLayout(.sizeThatFits)
    }
}
