import UIKit
import Flutter
import CoreLocation
import FirebaseFirestore
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let CHANNEL : String = "firestore_error_channel"
    var locationManager : CLLocationManager = CLLocationManager()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      initPlatformChannelAndCallMethod()
      self.locationManager.delegate = self
      self.checkIfAppIsLaunchedDueToLocation(didFinishLaunchingWithOptions:  launchOptions )
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func checkIfAppIsLaunchedDueToLocation(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        print("Called method checkIfAppIsLaunchedDueToLocation")
        if let optionsLaunchs  = launchOptions  , let launchedDueToLocation = optionsLaunchs[ .location ] as? Bool ,  launchedDueToLocation  {
            print("Calling again start updating lcoation")
            self.locationManager.startUpdatingLocation()
        }
    }
    
   private func requestWhenInUseAuthorizationLocation(){
       print("Requesting when in use")
       self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.locationManager.allowsBackgroundLocationUpdates = true
       self.locationManager.requestWhenInUseAuthorization()
       print("Requested when in use")
    }
    
    func initPlatformChannelAndCallMethod(){
           let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
           let appChannel = FlutterMethodChannel(name: CHANNEL,
                                                 binaryMessenger: controller.binaryMessenger)
       
           appChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
               switch( call.method){
               case "requestAuthorization":
                   print("Callind the request authorization")
                   self.requestWhenInUseAuthorizationLocation()
                   print("Called request ahtorization")
               default :
                   result(FlutterMethodNotImplemented)
               }
              })
       }
    
}




extension AppDelegate : CLLocationManagerDelegate {
    
    func sendDataToFirebase(data: [String: String] ) throws {
               let db = Firestore.firestore()
           do {
                  let unwrappedUserID : String = "custom_user_id"
                   let userDocumentRef = db.collection("locations").document(unwrappedUserID)
                   userDocumentRef.getDocument { (document, error) in
                       if let document = document, document.exists {
                           if document.data()?["location"] is [[String: String]] {
                               print( "sending location \(unwrappedUserID)" )
                               userDocumentRef.updateData([
                                   "location": FieldValue.arrayUnion([data])
                               ])
                           } else {
                               userDocumentRef.setData([
                                   "location": [data]
                               ], merge: true)
                           }
                       } else {
                           userDocumentRef.setData([
                               "location": [data]
                           ])
                       }
                   }
              
           } catch {
               print("Error sending data to Firebase: \(error)")
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let db = Firestore.firestore()
        self.locationManager.startMonitoringSignificantLocationChanges()
        print("DB firestore got")
        if let location = locations.first{
                       print("longitud: \(location.coordinate.longitude)")
                       print("latitud: \(location.coordinate.latitude)")
                       let data : [String:String] = [
                           "latitud" : String(location.coordinate.latitude),
                           "longitud" : String(location.coordinate.longitude)
                       ]
                       
                       do{
                           try sendDataToFirebase(data:  data )
                       } catch{
                        
                       }
                       
                   }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus: CLAuthorizationStatus

             if #available(iOS 14, *) {
                 authorizationStatus = manager.authorizationStatus
             } else {
                 authorizationStatus = CLLocationManager.authorizationStatus()
             }
             switch authorizationStatus {
             case .authorizedWhenInUse:
                 self.locationManager.requestAlwaysAuthorization()
                 self.locationManager.startUpdatingLocation()
             default:
                 print("LocationManager didChangeAuthorization")
             }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
}
