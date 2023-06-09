//
//  WeatherView.swift
//  USWeatherApp
//
//  Created by Rev on 09/04/23.
//

import SwiftUI

struct WeatherView: View {
    
    @AppStorage("previousCity") private var previousCity = ""
    
    @ObservedObject var vm: WeatherViewModel
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                TextField("Enter the City name", text:
                            $previousCity, onCommit:  {
                                self.vm.fetchWeather(by: previousCity)
                            })
                    .font(.custom("Arial", size: 20))
                    .padding()
                    .fixedSize()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                Spacer()
                let type = self.vm.loadingState
                
                switch (type) {
                case .loading:
                    LoadingView()
                case .success:
                    Text(vm.cityName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .padding()
                    Text(vm.temperature)
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                        .bold()
                    Text(vm.weatherIcon)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .padding()
                    Text(vm.weatherDescription)
                        .foregroundColor(Color.white)
                    Spacer()
                case .failed:
                    ErrorView(message: self.vm.message)
                case .none:
                    ErrorView(message: self.vm.message)
                }
            }.onAppear(perform: {
                if previousCity.isEmpty {
                    self.vm.refresh()
                } else {
                    self.vm.fetchWeather(by: previousCity)
                }
                print(previousCity)
            })
            .padding()
            .frame(width:300, height: 400)
            .background(Color.primary.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        }.background(
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .padding()
        )
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(vm: WeatherViewModel(weatherService: WeatherService()))
    }
}
