//
//  CodePreparer.swift
//  Halloween2024
//
//  Created by Geoff Pado on 10/31/24.
//

struct CodePreparer {
    func prepare(_ code: String) -> String {
        """
        import SwiftUI

        @_cdecl("createView")
        public func createView() -> UnsafeMutableRawPointer {
            let anyView = AnyView(OutputView())
            return Unmanaged.passRetained(anyView as AnyObject).toOpaque()
        }

        \(code)
        """
    }
}
