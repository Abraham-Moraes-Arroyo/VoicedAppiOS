//
//  LocationsListView.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/8/24.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    
    var body: some View {
        List{
            ForEach(vm.locations) { location in
                Button {
                    vm.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)

                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct LocationsListView_Previews : PreviewProvider {
    static var previews: some View {
    LocationsListView()
            .environmentObject(LocationsViewModel())
    }
}

extension LocationsListView {
    // we need to make a vfunctions that takes the location
    
    private func listRowView(location: Location) -> some View{
        HStack{
            if let imageName = location.imageNames.first{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            
            VStack (alignment: .leading){
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            // this helps to have all the text no matter how many character long it is, they will all be displayed the same.
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
    
}
