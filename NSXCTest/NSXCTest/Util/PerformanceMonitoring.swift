import Foundation
import SystemConfiguration

 /// :nodoc:
public typealias MemoryUsage = (used: UInt64, total: UInt64, message: String)
 /// :nodoc:
public typealias CPUUsage = (used: Double, message: String)
 /// :nodoc:
public typealias DownloadSpeed = (speed: Double, message: String)

/// Performance Monitoring
public class PerformanceMonitoring: NSObject {

    /// Get Memory Usage
    public class func memoryUsage() -> MemoryUsage {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }

        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }

        let total = ProcessInfo.processInfo.physicalMemory

        let bytesInMegabyte = 1024.0 * 1024.0
        let usedMemory = Double(used) / bytesInMegabyte
        let totalMemory = Double(total) / bytesInMegabyte
        let message = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
        NSLogger.info(message: message)
        return (used, total, message)
    }

    /// Get CPU Usage
    public class func cpuUsage() -> CPUUsage {
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }

                guard infoResult == KERN_SUCCESS else {
                    break
                }

                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }

        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        let message = String(format: "%.2f total Usage Of CPU", totalUsageOfCPU)
        NSLogger.info(message: message)
        return (totalUsageOfCPU, message)
    }

    /// Get Download Speed
    public class func downloadSpeed() -> DownloadSpeed {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return (0.0, "Network Unreachable - Zero Address")
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return (0.0, "Network Unreachable - Check Flags")
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let netowrk = Network()
        netowrk.isRunning = true
        netowrk.testDownloadSpeedWithTimout(timeout: 5.0) { _, error -> Void in
            if (error == nil) && isReachable && !needsConnection {
            }
            netowrk.isRunning = false
        }
        while netowrk.isRunning { }
        NSLogger.info(message: netowrk.downloadingSpeed.message)
        return netowrk.downloadingSpeed
    }
}

private class Network: NSObject, URLSessionDelegate, URLSessionDataDelegate {

    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var isRunning = true
    var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: Error?) -> Void)!
    var downloadingSpeed: DownloadSpeed = (0.0, "Network Unreachable - Zero Address")

    func testDownloadSpeedWithTimout(timeout: TimeInterval, completionHandler:@escaping (_ megabytesPerSecond: Double?, _ error: Error?) -> Void) {
        let urlString = "https://www.nhc.noaa.gov/tafb_latest/USA_latest.pdf"

        guard let url = URL(string: urlString) else {
            return
        }

        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionHandler = completionHandler

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsed = stopTime - startTime
        guard elapsed != 0 && error == nil else {
            speedTestCompletionHandler(nil, error)
            self.downloadingSpeed = (0.0, String(describing: error))
            return
        }

        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        let message = String(format: "%.2f MBPs", speed)
        self.downloadingSpeed = (speed, message)
        speedTestCompletionHandler(speed, nil)
    }

}
