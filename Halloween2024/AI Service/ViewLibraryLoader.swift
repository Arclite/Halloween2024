//
//  ViewLibraryLoader.swift
//  Halloween2024
//
//  Created by Geoff Pado on 10/31/24.
//

import Darwin
import SwiftUI

struct ViewLibraryLoader {
    private typealias InitFunction = @convention(c) () -> UnsafeMutableRawPointer

    func view(url: URL) throws -> AnyView {
        guard let openResult = dlopen(url.path(percentEncoded: false), RTLD_NOW|RTLD_LOCAL) else {
            if let error = dlerror() {
                throw ViewLibraryLoadError.dlerror(String(format: "%s", error))
            } else {
                throw ViewLibraryLoadError.unknown
            }
        }

        defer { dlclose(openResult) }
        guard let symbol = dlsym(openResult, "createView") else {
            throw ViewLibraryLoadError.missingSymbol
        }

        let createView = unsafeBitCast(symbol, to: InitFunction.self)
        let providerPointer = createView()
        let object = Unmanaged<AnyObject>.fromOpaque(providerPointer).takeRetainedValue()
        guard let view = object as? AnyView else { throw ViewLibraryLoadError.notAView }
        return view
    }
}

enum ViewLibraryLoadError: Error {
    case dlerror(String)
    case unknown
    case missingSymbol
    case notAView
}
