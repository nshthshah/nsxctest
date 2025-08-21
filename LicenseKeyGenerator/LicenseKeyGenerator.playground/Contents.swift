import Foundation
import CommonCrypto
import CryptoKit

struct AES256 {
    
    private var key: Data
    private var iv: Data
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw Error.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }

    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }

    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }

    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }

    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        
        input.withUnsafeBytes { rawBufferPointer in
            let encryptedBytes = rawBufferPointer.baseAddress!
            
            iv.withUnsafeBytes { rawBufferPointer in
                let ivBytes = rawBufferPointer.baseAddress!
                
                key.withUnsafeBytes { rawBufferPointer in
                    let keyBytes = rawBufferPointer.baseAddress!
                    
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),            // algorithm
                                     CCOptions(kCCOptionPKCS7Padding),           // options
                                     keyBytes,                                   // key
                                     key.count,                                  // keylength
                                     ivBytes,                                    // iv
                                     encryptedBytes,                             // dataIn
                                     input.count,                                // dataInLength
                                     &outBytes,                                  // dataOut
                                     outBytes.count,                             // dataOutAvailable
                                     &outLength)                                 // dataOutMoved
                }
            }
        }
        
        guard status == kCCSuccess else {
            throw Error.cryptoFailed(status: status)
        }
                
        return Data(bytes: &outBytes, count: outLength)
    }

    static func createKey(password: Data, salt: Data) throws -> Data {
        let length = kCCKeySizeAES256
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        
        
        password.withUnsafeBytes { rawBufferPointer in
            let passwordRawBytes = rawBufferPointer.baseAddress!
            let passwordBytes = passwordRawBytes.assumingMemoryBound(to: Int8.self)
            
            salt.withUnsafeBytes { rawBufferPointer in
                let saltRawBytes = rawBufferPointer.baseAddress!
                let saltBytes = saltRawBytes.assumingMemoryBound(to: UInt8.self)
                
                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),                  // algorithm
                                              passwordBytes,                                // password
                                              password.count,                               // passwordLen
                                              saltBytes,                                    // salt
                                              salt.count,                                   // saltLen
                                              CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),   // prf
                                              10000,                                        // rounds
                                              &derivedBytes,                                // derivedKey
                                              length)                                       // derivedKeyLen
            }
        }
        

        guard status == 0 else {
            throw Error.keyGeneration(status: Int(status))
        }
        return Data(bytes: &derivedBytes, count: length)
    }

    static func randomIv() -> Data {
        return randomData(length: kCCBlockSizeAES128)
    }

    static func iV() -> Data {
        let arr: [UInt8] = [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1]
        return Data(arr)
    }

    static func randomSalt() -> Data {
        return randomData(length: 8)
    }

    static func randomData(length: Int) -> Data {
        var data = Data(count: length)
        
        var mutableBytes: UnsafeMutableRawPointer!
        
        data.withUnsafeMutableBytes { rawBufferPointer in
            mutableBytes = rawBufferPointer.baseAddress!
        }
        
        let status = SecRandomCopyBytes(kSecRandomDefault, length, mutableBytes)
        
        assert(status == Int32(0))
        return data
    }
}

extension Data {
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        for i in 0 ..< length {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

public class LicenseKey: NSObject {
    
    static let password = "TW_8v:%8D7:_.p;T"
    static let salt = Data(hexString: "eedb0c8de0a9d09f")! // AES256.randomSalt()
    static let iv = Data(hexString: "4bb9f6f8bfb7adaad584e032a4cd412f")! // AES256.randomIv()
    
    private class func aes() -> AES256? {
        do {
            let key = try AES256.createKey(password: password.data(using: .utf8)!,
                                       salt: salt)
            let aes = try AES256(key: key, iv: iv)
            return aes
        } catch {
            fatalError("LicenseKey.aes: \(error)")
        }
    }
    
    private class func generateLicenseKey() {
        do {
            let expiredDate = "2021-10-10 11:05:08.145"
            let digest = "com.company.app || \(expiredDate)".data(using: .utf8)!
            let encrypted = try aes()!.encrypt(digest)
            print(encrypted.hexEncodedString())
        } catch {
            fatalError("LicenseKey.generateLicenseKey: \(error)")
        }
    }
}
