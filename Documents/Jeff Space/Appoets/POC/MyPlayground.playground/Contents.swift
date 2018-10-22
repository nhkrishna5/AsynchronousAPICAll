//: Playground - noun: a place where people can play

import Foundation



//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
//dateFormatter.date(from : "2018-01-19 15:54:18")

//let myString = "+91958520750"
//let regex = try! NSRegularExpression(pattern: "(\\w{2})", options: NSRegularExpression.Options.caseInsensitive)
//let range = NSMakeRange(0, myString.count)
//let modString = regex.stringByReplacingMatches(in: myString, options: [], range: range, withTemplate: "")
//print(modString)

//let str = ""
//
//Array(Data(fromHexEncodedString: str)!)


//type(of: 0x43db750c890a8da12)

//var i = 0x43db750c890a8da12 as UInt32

///let i = UInt64(exactly: 0x43db750c890a8da12)

import UIKit

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


12.degreesToRadians

12*180/180

CGFloat.pi


let i : Double = 0xe086f7871c26400

String(format: "Angle: %5d", 666)

let blue = "aaaaa"

let red = blue.reversed()


let formatter = NumberFormatter()


let number = NSNumber(value: i)

formatter.string(from: number)


//UInt32(littleEndian: 0x43db750c890a8da12)
//78234088274240.526866
