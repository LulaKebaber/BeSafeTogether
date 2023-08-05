import SwiftUI
import MapKit
import SimpleToast

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @State var userTrackingMode: MapUserTrackingMode = .follow
    @State private var currentCoordinates: CLLocationCoordinate2D?
    @State private var threatLocations: [MapAnnotationItem] = []
    @StateObject var mapViewModel = MapViewModel()
    
    @State private var showToast = false
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdropColor: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $locationManager.currentRegion, interactionModes: .all, showsUserLocation: false, userTrackingMode: $userTrackingMode, annotationItems: threatLocations) { location in

                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.white)
                                    .frame(width: 35, height: 35)
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(.red) // Customize threat annotation color
                                    .frame(width: 30, height: 30)
                            }
                            Text(location.title)
                                .foregroundColor(.blue) // Customize threat annotation color
                        }
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
                Spacer()
                RoundedRectangle(cornerRadius: CGFloat(30))
                    .foregroundColor(Color.white)
                    .frame(width: 400, height: 90)
                    .padding(.top, 690)
            }
            .onAppear(perform: {
                locationManager.askForLocationPermission()
                // Call the checkForThreat function and update threatLocations
                
                startSendingLocation()
            })
        }
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            if showToast {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Your friend is in danger!")
                }
                .padding(20)
                .background(Color.red.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(15)
            }
        }
        .padding(.top, 60)
    }
    
    func startSendingLocation() {
        // Run the initial check immediately
        APIManager.shared.checkForThreat { threatLocations in
            self.threatLocations = threatLocations
        }
        
        // Schedule repeating task
        mapViewModel.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            APIManager.shared.checkForThreat { threatLocations in
                self.threatLocations = threatLocations
                if !threatLocations.isEmpty {
                    showToast = true
                }
            }
            
            currentCoordinates = locationManager.currentRegion.center
            if let coordinates = currentCoordinates {
                print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                APIManager.shared.updateLocation(latitude: Float(coordinates.latitude), longitude: Float(coordinates.longitude))
            }
        }
    }
    
    func stopCheckingThreats() {
        mapViewModel.timer?.invalidate()
        mapViewModel.timer = nil
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

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

