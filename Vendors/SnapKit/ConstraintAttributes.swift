//
//  SnapKit
//
//  Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


extension OptionSet {
    internal static func + (left: Self, right: Self) -> Self {
        return left.union(right)
    }

    internal static func +=(left: inout Self, right: Self) {
        left.formUnion(right)
    }

    internal static func -=(left: inout Self, right: Self) {
        left.subtract(right)
    }
}

internal struct ConstraintAttributes : OptionSet {

    internal init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    internal init(_ rawValue: UInt) {
        self.init(rawValue: rawValue)
    }
    internal init(nilLiteral: ()) {
        self.rawValue = 0
    }

    internal private(set) var rawValue: UInt
    internal static var allZeros: ConstraintAttributes { return .init(0) }
    internal static func convertFromNilLiteral() -> ConstraintAttributes { return .init(0) }
    internal var boolValue: Bool { return self.rawValue != 0 }

    internal func toRaw() -> UInt { return self.rawValue }
    internal static func fromRaw(_ raw: UInt) -> ConstraintAttributes? { return .init(raw) }
    internal static func fromMask(_ raw: UInt) -> ConstraintAttributes { return .init(raw) }

    // normal

    internal static var none: ConstraintAttributes { return .init(0) }
    internal static var left: ConstraintAttributes { return .init(1) }
    internal static var top: ConstraintAttributes {  return .init(2) }
    internal static var right: ConstraintAttributes { return .init(4) }
    internal static var bottom: ConstraintAttributes { return .init(8) }
    internal static var leading: ConstraintAttributes { return .init(16) }
    internal static var trailing: ConstraintAttributes { return .init(32) }
    internal static var width: ConstraintAttributes { return .init(64) }
    internal static var height: ConstraintAttributes { return .init(128) }
    internal static var centerX: ConstraintAttributes { return .init(256) }
    internal static var centerY: ConstraintAttributes { return .init(512) }
    internal static var lastBaseline: ConstraintAttributes { return .init(1024) }

    @available(iOS 8.0, OSX 10.11, *)
    internal static var firstBaseline: ConstraintAttributes { return .init(2048) }

    @available(iOS 8.0, *)
    internal static var leftMargin: ConstraintAttributes { return .init(4096) }

    @available(iOS 8.0, *)
    internal static var rightMargin: ConstraintAttributes { return .init(8192) }

    @available(iOS 8.0, *)
    internal static var topMargin: ConstraintAttributes { return .init(16384) }

    @available(iOS 8.0, *)
    internal static var bottomMargin: ConstraintAttributes { return .init(32768) }

    @available(iOS 8.0, *)
    internal static var leadingMargin: ConstraintAttributes { return .init(65536) }

    @available(iOS 8.0, *)
    internal static var trailingMargin: ConstraintAttributes { return .init(131072) }

    @available(iOS 8.0, *)
    internal static var centerXWithinMargins: ConstraintAttributes { return .init(262144) }

    @available(iOS 8.0, *)
    internal static var centerYWithinMargins: ConstraintAttributes { return .init(524288) }

    // aggregates

    internal static var edges: ConstraintAttributes { return .init(15) }
    internal static var size: ConstraintAttributes { return .init(192) }
    internal static var center: ConstraintAttributes { return .init(768) }

    @available(iOS 8.0, *)
    internal static var margins: ConstraintAttributes { return .init(61440) }

    @available(iOS 8.0, *)
    internal static var centerWithinMargins: ConstraintAttributes { return .init(786432) }

    internal var layoutAttributes:[NSLayoutAttribute] {
        var attrs = [NSLayoutAttribute]()
        if contains(.left) {
            attrs.append(.left)
        }
        if contains(.top) {
            attrs.append(.top)
        }
        if contains(.right) {
            attrs.append(.right)
        }
        if contains(.bottom) {
            attrs.append(.bottom)
        }
        if contains(.leading) {
            attrs.append(.leading)
        }
        if contains(.trailing) {
            attrs.append(.trailing)
        }
        if contains(.width) {
            attrs.append(.width)
        }
        if contains(.height) {
            attrs.append(.height)
        }
        if contains(.centerX) {
            attrs.append(.centerX)
        }
        if contains(.centerY) {
            attrs.append(.centerY)
        }
        if contains(.lastBaseline) {
            attrs.append(.lastBaseline)
        }

        #if os(iOS) || os(tvOS)
            if contains(.firstBaseline) {
                attrs.append(.firstBaseline)
            }
            if contains(.leftMargin) {
                attrs.append(.leftMargin)
            }
            if contains(.rightMargin) {
                attrs.append(.rightMargin)
            }
            if contains(.topMargin) {
                attrs.append(.topMargin)
            }
            if contains(.bottomMargin) {
                attrs.append(.bottomMargin)
            }
            if contains(.leadingMargin) {
                attrs.append(.leadingMargin)
            }
            if contains(.trailingMargin) {
                attrs.append(.trailingMargin)
            }
            if contains(.centerXWithinMargins) {
                attrs.append(.centerXWithinMargins)
            }
            if contains(.centerYWithinMargins) {
                attrs.append(.centerYWithinMargins)
            }
        #endif

        return attrs
    }
}

