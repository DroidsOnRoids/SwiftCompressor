//
//  NSData+Compressor.swift
//  SwiftCompressor
//
//  Created by Piotr Sochalewski on 22.02.2016.
//  Copyright © Droids on Roids. All rights reserved.
//

import Foundation
import Compression

/**
 Compression algorithm
 - `.LZ4`: Fast compression
 - `.ZLIB`: Balances between speed and compression
 - `.LZMA`: High compression
 - `.LZFSE`: Apple-specific high performance compression
 */
@available(iOS 9.0, OSX 10.11, *)
public enum CompressionAlgorithm {
    /**
     LZ4 is an extremely high-performance compressor.
     */
    case LZ4
    
    /**
     ZLIB encoder at level 5 only. This compression level provides a good balance between compression speed and compression ratio. The ZLIB decoder supports decoding data compressed with any compression level.
     */
    case ZLIB
    
    /**
     LZMA encoder at level 6 only. This is the default compression level for open source LZMA, and provides excellent compression. The LZMA decoder supports decoding data compressed with any compression level.
     */
    case LZMA
    
    /**
     Apple’s proprietary compression algorithm. LZFSE is a new algorithm, matching the compression ratio of ZLIB level 5, but with much higher energy efficiency and speed (between 2x and 3x) for both encode and decode operations.
     
     LZFSE is only present in iOS and OS X, so it can’t be used when the compressed payload has to be shared to other platforms (Linux, Windows). In all other cases, LZFSE is recommended as a replacement for ZLIB.
     */
    case LZFSE
}

public enum CompressionError: ErrorType {
    /**
     The error received when trying to compress/decompress empty data (when length equals zero).
     */
    case EmptyData
    
    /**
     The error received when `compression_stream_init` failed. It also fails when trying to decompress `NSData` compressed with different compression algorithm or uncompressed raw data.
     */
    case InitError
    
    /**
     The error received when `compression_stream_process` failed.
     */
    case ProcessError
}

extension NSData {
    /**
     Returns a `NSData` object created by compressing the receiver using the LZFSE algorithm.
     - returns: A `NSData` object created by encoding the receiver's contents using the LZFSE algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func compress() throws -> NSData? {
        return try compress(algorithm: .LZFSE, bufferSize: 4096)
    }
    
    /**
     Returns a `NSData` object created by compressing the receiver using the given compression algorithm.
     - parameter algorithm: one of four compression algorithms to use during compression
     - returns: A `NSData` object created by encoding the receiver's contents using the provided compression algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func compress(algorithm compression: CompressionAlgorithm) throws -> NSData? {
        return try compress(algorithm: compression, bufferSize: 4096)
    }
    
    /**
     Returns a NSData object created by compressing the receiver using the given compression algorithm.
     - parameter algorithm: one of four compression algorithms to use during compression
     - parameter bufferSize: the size of buffer in bytes to use during compression
     - returns: A `NSData` object created by encoding the receiver's contents using the provided compression algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func compress(algorithm compression: CompressionAlgorithm, bufferSize: size_t) throws -> NSData? {
        return try compress(compression, operation: .Compression, bufferSize: bufferSize)
    }
    
    /**
     Returns a `NSData` object by uncompressing the receiver using the LZFSE algorithm.
     - returns: A `NSData` object created by decoding the receiver's contents using the LZFSE algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func decompress() throws -> NSData? {
        return try decompress(algorithm: .LZFSE, bufferSize: 4096)
    }
    
    /**
     Returns a `NSData` object by uncompressing the receiver using the given compression algorithm.
     - parameter algorithm: one of four compression algorithms to use during decompression
     - returns: A `NSData` object created by decoding the receiver's contents using the provided compression algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func decompress(algorithm compression: CompressionAlgorithm) throws -> NSData? {
        return try decompress(algorithm: compression, bufferSize: 4096)
    }
    
    /**
     Returns a `NSData` object by uncompressing the receiver using the given compression algorithm.
     - parameter algorithm: one of four compression algorithms to use during decompression
     - parameter bufferSize: the size of buffer in bytes to use during decompression
     - returns: A `NSData` object created by decoding the receiver's contents using the provided compression algorithm.
     */
    @available(iOS 9.0, OSX 10.11, *)
    public func decompress(algorithm compression: CompressionAlgorithm, bufferSize: size_t) throws -> NSData? {
        return try compress(compression, operation: .Decompression, bufferSize: bufferSize)
    }
    
    private enum Operation {
        case Compression
        case Decompression
    }
    
    @available(iOS 9.0, OSX 10.11, *)
    private func compress(compression: CompressionAlgorithm, operation: Operation, bufferSize: size_t) throws -> NSData? {
        // Throw an error when data to (de)compress is empty.
        guard length > 0 else {
            throw CompressionError.EmptyData
        }
        
        // Variables
        var status: compression_status
        var op: compression_stream_operation
        var flags: Int32
        var algorithm: compression_algorithm
        
        // Output data
        let outputData = NSMutableData()
        
        switch compression {
        case .LZ4:
            algorithm = COMPRESSION_LZ4
        case .ZLIB:
            algorithm = COMPRESSION_ZLIB
        case .LZMA:
            algorithm = COMPRESSION_LZMA
        case .LZFSE:
            algorithm = COMPRESSION_LZFSE
        }

        // Setup stream operation and flags depending on compress/decompress operation type
        switch operation {
        case .Compression:
            op = COMPRESSION_STREAM_ENCODE
            flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
        case .Decompression:
            op = COMPRESSION_STREAM_DECODE
            flags = 0
        }
        
        // Allocate memory for one object of type compression_stream
        let streamPointer = UnsafeMutablePointer<compression_stream>.alloc(1)
        defer {
            streamPointer.dealloc(1)
        }
        
        // Stream and its buffer
        var stream = streamPointer.memory
        let dstBufferPointer = UnsafeMutablePointer<UInt8>.alloc(bufferSize)
        defer {
            dstBufferPointer.dealloc(bufferSize)
        }

        // Create the compression_stream and throw an error if failed
        status = compression_stream_init(&stream, op, algorithm)
        guard status != COMPRESSION_STATUS_ERROR else {
            throw CompressionError.InitError
        }
        defer {
            compression_stream_destroy(&stream)
        }
        
        // Stream setup after compression_stream_init
        stream.src_ptr = UnsafePointer<UInt8>(bytes)
        stream.src_size = length
        stream.dst_ptr = dstBufferPointer
        stream.dst_size = bufferSize
        
        repeat {
            status = compression_stream_process(&stream, flags)
            
            switch status {
            case COMPRESSION_STATUS_OK:
                if stream.dst_size == 0 {
                    outputData.appendBytes(dstBufferPointer, length: bufferSize)
                    
                    stream.dst_ptr = dstBufferPointer
                    stream.dst_size = bufferSize
                }
                
            case COMPRESSION_STATUS_END:
                if stream.dst_ptr > dstBufferPointer {
                    outputData.appendBytes(dstBufferPointer, length: stream.dst_ptr - dstBufferPointer)
                }
                
            case COMPRESSION_STATUS_ERROR:
                throw CompressionError.ProcessError
                
            default:
                break
            }
            
        } while status == COMPRESSION_STATUS_OK
        
        return outputData.copy() as? NSData
    }
}