import XCTest
import SwiftCompressor

class Tests: XCTestCase {
    
    var path = NSBundle.mainBundle().pathForResource("lorem", ofType: "txt")
    var loremData: NSData!
    
    override func setUp() {
        super.setUp()
        loremData = NSData(contentsOfFile: path!)
    }
    
    // MARK: - Compression and decompression
    
    func testCompressionAndDecompression() {
        let compressedLoremData = try? loremData.compress()
        let uncompressedLoremData = try? compressedLoremData??.decompress()
        
        XCTAssertGreaterThan(uncompressedLoremData!!.length, compressedLoremData!!.length, "The compressed data should be smaller than the uncompressed data.")
        XCTAssertEqual(loremData, uncompressedLoremData!, "The data before compression and after decompression should be the same.")
    }
    
    // MARK: - Buffer size performance comparision
    
    func testPerformance4096() {
        measureBlock {
            for _ in 0...10000 {
                let compressedLoremData = try? self.loremData.compress(algorithm: .ZLIB, bufferSize: 4096)
                let _ = try? compressedLoremData??.decompress(algorithm: .ZLIB, bufferSize: 4096)
            }
        }
    }
    
    func testPerformance8192() {
        measureBlock {
            for _ in 0...10000 {
                let compressedLoremData = try? self.loremData.compress(algorithm: .ZLIB, bufferSize: 8192)
                let _ = try? compressedLoremData??.decompress(algorithm: .ZLIB, bufferSize: 8192)
            }
        }
    }
    
    func testPerformance16384() {
        measureBlock {
            for _ in 0...10000 {
                let compressedLoremData = try? self.loremData.compress(algorithm: .ZLIB, bufferSize: 16384)
                let _ = try? compressedLoremData??.decompress(algorithm: .ZLIB, bufferSize: 16384)
            }
        }
    }
    
}