//
//  AIService.swift
//  Halloween2024
//
//  Created by Geoff Pado on 10/31/24.
//

import Foundation
import SwiftUI

struct AIService {
    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["CLAUDE_API_KEY"] else {
            fatalError("Missing API key")
        }

        messageService = MessageService(apiKey: apiKey)
    }

    func createView(from request: String) async throws -> any View {
        let serviceRequest = MessageServiceRequest(
            model: .claude3Dot5Sonnet,
            messages: [
                .init(role: .user, content: request)
            ],
            systemPrompt: """
            You are an expert Swift programmer. You will be given requirements of a task to complete, and your job is to create a SwiftUI view that meets those requirements. Return only the code for the SwiftUI `View`; do not include other parts of the file such as imports. Return only Swift code. Do not wrap it in Markdown. This code will be going in a library, so make sure that the view and any other pieces we will need to reference (such as the init) are made public. The main view that is output should always be named OutputView. The code must run on macOS; it must not use any views or view modifiers that are only available on iOS.
            """
        )
        let response = try await messageService.post(serviceRequest)
        let code = response.content.map(\.text).joined(separator: "\n")
        let preparedCode = preparer.prepare(code)
        let libraryURL = try await compiler.compile(preparedCode)
        let view = try loader.view(url: libraryURL)
        return view
    }

    private let messageService: MessageService
    private let compiler = SwiftCompiler()
    private let preparer = CodePreparer()
    private let loader = ViewLibraryLoader()
}
