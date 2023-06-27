//создал хуесос

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.882004, longitude: -122.03118), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                getCurrentLocation { coordinates in
                    if let coordinates = coordinates {
                        // Используйте координаты местоположения здесь
                        print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    } else {
                        // Обработка ошибки или случая, когда местоположение недоступно
                        print("Не удалось получить местоположение")
                    }
                }
                
//                if let location = locationManager.lastKnownLocation {
//                    region = MKCoordinateRegion(center: location, span: region.span)
//                }
            }) {
                Text("Центрировать на моем местоположении")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let locationManager = CLLocationManager()
        
        locationManager.requestAlwaysAuthorization()
        
        // Проверка доступности служб геолокации
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            
            // Обработка успешного разрешения
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                
                // Получение текущего местоположения
                if let location = locationManager.location {
                    let currentLocation = location.coordinate
                    completion(currentLocation)
                } else {
                    completion(nil)
                }
            } else {
                // Разрешение на использование геолокации не предоставлено
                completion(nil)
            }
        } else {
            // Службы геолокации недоступны
            completion(nil)
        }
    }

}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
