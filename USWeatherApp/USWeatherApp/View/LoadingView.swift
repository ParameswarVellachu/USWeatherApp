//
//  LoadingView.swift
//  USWeatherApp
//
//  Created by Rev on 09/04/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading your amazing weather!")
                .font(.body)
                .foregroundColor(Color.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .frame(width:300, height: 150)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
