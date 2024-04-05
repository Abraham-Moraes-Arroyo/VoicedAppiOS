//
//  LocationMapAnnotionView.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/16/24.
//

import SwiftUI

struct LocationMapAnnotionView: View {
    
    let accentColor = Color("AccentColor")
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName:  "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(accentColor)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y:-4)
                .padding(.bottom, 40)// because we want the actual location to shwo up.
        }
        
    }
}

struct LocationMapAnnotationView_Previes: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            LocationMapAnnotionView()
        }
        }
}
