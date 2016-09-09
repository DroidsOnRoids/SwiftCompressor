import XCTest
import SwiftCompressor

class Tests: XCTestCase {
    
    let repeatCount = 10000
    
    let path = URL(fileURLWithPath: Bundle.main.path(forResource: "lorem", ofType: "txt")!)
    var loremData: Data!
    
    override func setUp() {
        super.setUp()
        loremData = try? Data(contentsOf: path)
    }
    
    // MARK: - Compression and decompression
    
    func testCompressionAndDecompression() {
        let compressedLoremData = try? loremData.compress()
        let uncompressedLoremData = try? compressedLoremData??.decompress()
        
        XCTAssertGreaterThan(uncompressedLoremData!!.count, compressedLoremData!!.count, "The compressed data should be smaller than the uncompressed data.")
        XCTAssertEqual(loremData, uncompressedLoremData!, "The data before compression and after decompression should be the same.")
    }
    
    // MARK: - Buffer size performance comparision
    
    func testPerformance4096() {
        measure {
            for _ in 0...self.repeatCount {
                let compressedLoremData = try? self.loremData.compress(algorithm: .zlib, bufferSize: 4096)
                let _ = try? compressedLoremData??.decompress(algorithm: .zlib, bufferSize: 4096)
            }
        }
    }
    
    func testPerformance8192() {
        measure {
            for _ in 0...self.repeatCount {
                let compressedLoremData = try? self.loremData.compress(algorithm: .zlib, bufferSize: 8192)
                let _ = try? compressedLoremData??.decompress(algorithm: .zlib, bufferSize: 8192)
            }
        }
    }
    
    func testPerformance16384() {
        measure {
            for _ in 0...self.repeatCount {
                let compressedLoremData = try? self.loremData.compress(algorithm: .zlib, bufferSize: 16384)
                let _ = try? compressedLoremData??.decompress(algorithm: .zlib, bufferSize: 16384)
            }
        }
    }
    
    // MARK: - Compression duration
    
    func testLZFSE() {
        measure {
            for _ in 0...self.repeatCount {
                _ = try? self.loremData.compress(algorithm: .lzfse)
            }
        }
    }
    
    func testLZ4() {
        measure {
            for _ in 0...self.repeatCount {
                _ = try? self.loremData.compress(algorithm: .lz4)
            }
        }
    }
    
    func testZLIB() {
        measure {
            for _ in 0...self.repeatCount {
                _ = try? self.loremData.compress(algorithm: .zlib)
            }
        }
    }
    
    func testLZMA() {
        measure {
            for _ in 0...self.repeatCount {
                _ = try? self.loremData.compress(algorithm: .lzma)
            }
        }
    }
}
