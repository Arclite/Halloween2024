//
//  SwiftCompiler.swift
//  Halloween2024
//
//  Created by Geoff Pado on 10/31/24.
//

import Foundation

struct SwiftCompiler {
    func compile(_ code: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let outputURL = libraryURL()
                let process = Process()
                process.executableURL = try compilerURL
                process.arguments = [
                    "-emit-library",
                    "-o", outputURL.path(),
                    "-",
                ]

                let inputPipe = Pipe()
                process.standardInput = inputPipe

                let errorPipe = Pipe()
                process.standardError = errorPipe

                let data = Data(code.utf8)
                try inputPipe.fileHandleForWriting.write(contentsOf: data)
                try inputPipe.fileHandleForWriting.close()

                process.terminationHandler = { terminatedProcess in
                    do {
                        let status = terminatedProcess.terminationStatus
                        guard status == 0 else {
                            if let errorData = try errorPipe.fileHandleForReading.readToEnd() {
                                let errorMessage = String(data: errorData, encoding: .utf8) ?? "unparseable"
                                return continuation.resume(throwing: SwiftCompilerError.compilationFailed(errorMessage))
                            } else {
                                return continuation.resume(throwing: SwiftCompilerError.compilationFailed("unknown"))
                            }
                        }

                        if FileManager.default.fileExists(atPath: outputURL.path()) {
                            continuation.resume(returning: outputURL)
                        } else {
                            continuation.resume(throwing: SwiftCompilerError.missingOutput)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }

                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private var compilerURL: URL {
        get throws {
            return URL(filePath: "/usr/bin/swiftc")
        }
    }

    private func libraryURL() -> URL {
        URL.temporaryDirectory.appending(component: UUID().uuidString).appendingPathExtension("dylib")
    }
}

enum SwiftCompilerError: Error {
    case missingOutput
    case compilationFailed(String)
}
