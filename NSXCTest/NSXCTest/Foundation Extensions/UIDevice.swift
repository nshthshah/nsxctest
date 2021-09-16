import Foundation
import UIKit
import Darwin

public extension UIDevice {

    /// Get Device Id
    var deviceId: String {
        if isSimulator {
            guard let simulatorUDID = ProcessInfo.processInfo.environment["SIMULATOR_UDID"] else {
                return self.identifierForVendor?.uuidString ?? ""
            }
            return simulatorUDID
        }
        return self.identifierForVendor?.uuidString ?? ""
    }

    /// Check the device type
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// Check the device type
    var isIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// Check the device is simulator
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// Returns machine identifier string in a form of "name,major,minor", i.e. "iPhone,8,2".
    var machineIdentifier: String {
        if isSimulator {
            guard let value = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] else {
                return ""
            }
            return value
        }

        var systemInfo = utsname()
        uname(&systemInfo)
        let value = withUnsafePointer(to: &systemInfo.machine) {
            String(cString: UnsafeRawPointer($0).assumingMemoryBound(to: CChar.self))
        }
        return value
    }

    private struct InterfaceNames {
        static let wifi = ["en0"]
        static let wired = ["en2", "en3", "en4"]
        static let cellular = ["pdp_ip0", "pdp_ip1", "pdp_ip2", "pdp_ip3"]
        static let supported = wifi + cellular
    }

    /// Get IP Address of execution device
    func ipAddress() -> String {
        var address = "No Wi-Fi Address"

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return address }
        guard let firstAddr = ifaddr else { return address }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if InterfaceNames.supported.contains(name) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname,
                                socklen_t(hostname.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }

    /// Get Device battery information
    #if targetEnvironment(simulator)
    func deviceBatteryInfo() -> [JsonType]? {
        guard case let handle = dlopen("/System/Library/PrivateFrameworks/BatteryCenter.framework/BatteryCenter", RTLD_LAZY), handle != nil,
            let cls = NSClassFromString("BCBatteryDeviceController") as AnyObject as? NSObjectProtocol else {
                return nil
        }

        func sharedInstance() -> String { return "sharedInstance" } // Silence compiler warnings
        guard cls.responds(to: Selector(sharedInstance())) == true else { return nil }

        let instance = cls.perform(Selector(sharedInstance())).takeUnretainedValue()

        guard let batteries = instance.value(forKey: "connectedDevices") as? [AnyObject] else { return nil }

        let batteryInfo = batteries.compactMap { battery -> JsonType? in
            var propertyCount: UInt32 = 0
            guard let properties = class_copyPropertyList(battery.classForCoder, &propertyCount) else { return nil }
            var batteryDictionary = JsonType()

            for index in 0..<propertyCount {
                let cPropertyName = property_getName(properties[Int(index)])

                let pName = String(cString: cPropertyName)
                batteryDictionary[pName] = battery.value(forKey: pName) as AnyObject
            }

            free(properties) //release Obj-C property structs
            return batteryDictionary
        }

        return batteryInfo
    }

    /// Check Airplane Mode Enabled
    func isAirplaneModeEnabled() -> Bool {
        guard case let handle = dlopen("/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport", RTLD_LAZY), handle != nil,
            let cls = NSClassFromString("RadiosPreferences") as? NSObject.Type else {
                return false
        }
        let radioPreferences = cls.init()

        if radioPreferences.responds(to: NSSelectorFromString("airplaneMode")) {
            return (radioPreferences.value(forKey: "airplaneMode") as AnyObject).boolValue
        }
        return false
    }

    /// Check WiFi Enabled
    func isWiFiEnabled() -> Bool {
        guard case let handle = dlopen("/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport", RTLD_LAZY), handle != nil,
            let cls = NSClassFromString("CPNetworkObserver") as? NSObject.Type else {
                return false
        }
        let radioPreferences = cls.init()

        if radioPreferences.responds(to: NSSelectorFromString("isWiFiEnabled")) {
            return (radioPreferences.value(forKey: "isWiFiEnabled") as AnyObject).boolValue
        }
        return false
    }
    #endif
}

public extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String {
      #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return "iPod Touch 5"
      case "iPod7,1":                                 return "iPod Touch 6"
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
      case "iPhone4,1":                               return "iPhone 4s"
      case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
      case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
      case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
      case "iPhone7,2":                               return "iPhone 6"
      case "iPhone7,1":                               return "iPhone 6 Plus"
      case "iPhone8,1":                               return "iPhone 6s"
      case "iPhone8,2":                               return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
      case "iPhone8,4":                               return "iPhone SE"
      case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":                return "iPhone X"
      case "iPhone11,2":                              return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
      case "iPhone11,8":                              return "iPhone XR"
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
      case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
      case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
      case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
      case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
      case "iPad6,11", "iPad6,12":                    return "iPad 5"
      case "iPad7,5", "iPad7,6":                      return "iPad 6"
      case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
      case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
      case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
      case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
      case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
      case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
      case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
      case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
      case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
      case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
      case "AppleTV5,3":                              return "Apple TV"
      case "AppleTV6,2":                              return "Apple TV 4K"
      case "AudioAccessory1,1":                       return "HomePod"
      case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                                        return identifier
      }
      #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3": return "Apple TV 4"
      case "AppleTV6,2": return "Apple TV 4K"
      case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
      default: return identifier
      }
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
}

