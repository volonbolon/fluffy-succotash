# fluffy-succotash
Redux + Combine (and a little bit of SwiftUI)

Due to the simple requirement, I decided to use Redux. MVP would be more than enough as well, but I wanted to push the envelope just a little bit. 

As I've said, I've structured the app around Redux, We have the different components (Store + State + Action + Reducer), and Combine is used to stitch them together. A friend of mine used to say that Apple is like the arm forces, they cannot force you to do something, but they sure have the means to make you want to do exactly what they want.

The nice thing about Redux is that, given the lack of side effects, components are easier to test. 

## Mocking Core Location
One special consideration is how I'm mocking Core Location inner working. First, and more importantly, I've decided to mock Core Location behavior to give the running app a vivid, even when running on the phone. We have three different regions (*retrieved* from a repo by the corresponding middleware) and the LocationMiddleware reacts to a user entering and leaving them. To simulate the wandering, `MockLocationManager` randomly picks one region, and broadcast that to its delegate. `MockLocationManager ` adopts `AnyLocationManager`, an umbrella protocol that I used to encapsulate the Core Location Manager interface I want to mock. Because the delegate of core location manager is reflective, we also need to abstract the delegate protocol, so we can inject the protocol and not a concrete class. 

```
protocol AnyLocationManagerDelegate: AnyObject {
    func locationManagerDidChangeAuthorization(_ manager: AnyLocationManager)
    func locationManager(_ manager: AnyLocationManager,
                         didEnterRegion region: CLRegion)
    func locationManager(_ manager: AnyLocationManager,
                         didExitRegion region: CLRegion)
}


/// Umbrella protocol. Used to abstract the manager interface
/// we need to mock.
protocol AnyLocationManager {
    var location: CLLocation? { get }

    /// Instead of the actual delegate, we define this one, which
    /// is reflective on the protocol, and not the concrete class
    var locationManagerDelegate: AnyLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func startMonitoring(for region: CLRegion)
}
```

We just need to extend `CLLocationManager` to bridge the new delegate (the rest is already implemented)

```
extension CLLocationManager: AnyLocationManager {
    var locationManagerDelegate: AnyLocationManagerDelegate? {
        get {
            return delegate as! AnyLocationManagerDelegate?
        }
        
        set {
            delegate = newValue as! CLLocationManagerDelegate?
        }
    }
}
```

With that, either on the test target, or, as in the app, when we need to mock some sort of behavior, we can easily swap the manager. In our case, the location service needs to be able to get location fixes and we can inject either the real core location manager or a mock (which, will be abstracted to a reactive PONSO using `AnyReactiveLocationManager`). 
