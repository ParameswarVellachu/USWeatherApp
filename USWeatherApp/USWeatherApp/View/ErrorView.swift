//
//  ErrorView.swift
//  USWeatherApp
//
//  Created by Rev on 09/04/23.
//

import SwiftUI

struct ErrorView: View {
    
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .font(.body)
                .foregroundColor(Color.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .frame(width:300, height: 150)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Unable to load weather")
    }
}
