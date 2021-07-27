import Geodesic

public let WGS84 = (a: 6378137.0, f: 1 / 298.257223563)

public struct InverseResult {
  public var s12: Double = 0.0
  public var az1: Double = 0.0
  public var az2: Double = 0.0
}

public struct DirectResult {
  public var lat2: Double = 0.0
  public var lon2: Double = 0.0
  public var az2: Double = 0.0
}

public func inverse(p1: (lat: Double, lon: Double), p2: (lat: Double, lon: Double), ellipsoid: (a: Double, f: Double) = WGS84) -> InverseResult {
  var iResult = InverseResult()
  
  // shortcut for zero distance
  if p1 == p2 {
    return iResult
  }
  
  var g: geod_geodesic = geod_geodesic()
  geod_init(&g, ellipsoid.a, ellipsoid.f)
  geod_inverse(&g, p1.lat, p1.lon, p2.lat, p2.lon, &iResult.s12, &iResult.az1, &iResult.az2)
  return iResult
}

public func direct(p1: (lat: Double, lon: Double), az1: Double, s12: Double, ellipsoid: (a: Double, f: Double) = WGS84) -> DirectResult {
  var dResult = DirectResult()
  dResult.lat2 = p1.lat
  dResult.lon2 = p1.lon
  dResult.az2 = az1
  
  // shortcut for zero distance
  if s12.isEqual(to: 0.0) {
    return dResult
  }
  
  var g: geod_geodesic = geod_geodesic()
  geod_init(&g, ellipsoid.a, ellipsoid.f)
  geod_direct(&g, p1.lat, p1.lon, az1, s12, &dResult.lat2, &dResult.lon2, &dResult.az2)
  return dResult
}
