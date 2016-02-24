//
//  ViewController.swift
//  SwiftCompressor
//
//  Created by Piotr Sochalewski on 24.02.2016.
//  Copyright (c) 2016 Droids on Roids. All rights reserved.
//

import UIKit
import SwiftCompressor

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let path = NSBundle.mainBundle().pathForResource("lorem", ofType: "txt")
        let loremData = NSData(contentsOfFile: path!)
        print("Raw length: \(loremData?.length)")
        
        let compressedLoremDataLZFSE = try? loremData?.compress()
        print("LZFSE length: \(compressedLoremDataLZFSE??.length)")
        
        let compressedLoremDataZLIB = try? loremData?.compress(algorithm: .ZLIB)
        print("ZLIB length: \(compressedLoremDataZLIB??.length)")
        
        let compressedLoremDataLZ4 = try? loremData?.compress(algorithm: .LZ4)
        print("LZ4 length: \(compressedLoremDataLZ4??.length)")
        
        let compressedLoremDataLZMA = try? loremData?.compress(algorithm: .LZMA)
        print("LZMA length: \(compressedLoremDataLZMA??.length)")
        
        let decompressedLoremData = try? compressedLoremDataLZFSE??.decompress()
        print("Decompressed length: \(decompressedLoremData??.length)")
    }
    
}