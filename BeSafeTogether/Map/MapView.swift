import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @State var userTrackingMode: MapUserTrackingMode = .follow

    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $locationManager.currentRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                    .ignoresSafeArea()
            }
            .onAppear(perform: {
                locationManager.askForLocationPermission()
            })
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentRegion = MKCoordinateRegion()
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func askForLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
