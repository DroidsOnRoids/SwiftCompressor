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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "lorem", ofType: "txt")!)
        let loremData = try? Data(contentsOf: path)
        print("Raw length: \(loremData?.count)")
        
        let compressedLoremDataLZFSE = try? loremData?.compress()
        print("LZFSE length: \(compressedLoremDataLZFSE??.count)")
        
        let compressedLoremDataZLIB = try? loremData?.compress(algorithm: .zlib)
        print("ZLIB length: \(compressedLoremDataZLIB??.count)")
        
        let compressedLoremDataLZ4 = try? loremData?.compress(algorithm: .lz4)
        print("LZ4 length: \(compressedLoremDataLZ4??.count)")
        
        let compressedLoremDataLZMA = try? loremData?.compress(algorithm: .lzma)
        print("LZMA length: \(compressedLoremDataLZMA??.count)")
        
        let decompressedLoremData = try? compressedLoremDataLZFSE??.decompress()
        print("Decompressed length: \(decompressedLoremData??.count)")
    }
}
