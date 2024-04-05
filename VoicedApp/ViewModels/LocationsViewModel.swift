//
//  LocationsViewModel.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/8/24.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    // All loaded locations
    // we are going to be selecting the one specific locaiton
    @Published var locations: [Location]
    
    
    
    // Current location on the map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    // now we don't have to manually update the line below
    //current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
//    show list of locaitons
    @Published var showLocationsList: Bool = false
    
    // show location detail via sheet
    @Published var sheetLocation: Location? = nil 
    
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        // end of initialization. 
        
        // in this specific cituation we have the hardcoaded data, but for when we use database we got to make sure that that we do no do the ``first!``
        self.updateMapRegion(location: locations.first!)
    }
    
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: location.coordinates, span: mapSpan)
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut){
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            
            showLocationsList = false
            
        }
    }
    func nextButtonPressed() {
        // get the current index
        guard  let currentIndex = locations.firstIndex(where : {$0 == mapLocation}) else {
            print("Could not find current index! in locations array! Should never happen")
            return
        }
        // check if the currentIndex is valid
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            
            // next index is not valid
            // restart from 0
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        
        // next index that IS VALID
        
        let nextLcoation = locations[nextIndex]
        showNextLocation(location: nextLcoation)
    }
}
