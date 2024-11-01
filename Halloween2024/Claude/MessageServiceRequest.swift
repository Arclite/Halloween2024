//  Created by Geoff Pado on 3/19/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public struct MessageServiceRequest: Encodable {
    let model: Model
    let messages: [Message]
    let systemPrompt: String
    let maxTokens: Int
    let temperature: Decimal

    public init(model: Model, messages: [Message], systemPrompt: String, maxTokens: Int = 1000, temperature: Decimal = 0.0) {
        self.model = model
        self.messages = messages
        self.systemPrompt = systemPrompt
        self.maxTokens = maxTokens
        self.temperature = temperature
    }

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case systemPrompt = "system"
        case maxTokens = "max_tokens"
        case temperature
    }

    public enum Model: Encodable {
        case claude3Dot5Sonnet
        case claude3Opus
        case claude3Sonnet
        case claude3Haiku

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .claude3Dot5Sonnet:
                try container.encode("claude-3-5-sonnet-20241022")
            case .claude3Opus:
                try container.encode("claude-3-opus-20240229")
            case .claude3Sonnet:
                try container.encode("claude-3-sonnet-20240229")
            case .claude3Haiku:
                try container.encode("claude-3-haiku-20240307")
            }
        }
    }

    public struct Message: Encodable {
        let role: Role
        let content: String

        public init(role: Role, content: String) {
            self.role = role
            self.content = content
        }

        public enum Role: Encodable {
            case user
            case assistant

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .user:
                    try container.encode("user")
                case .assistant:
                    try container.encode("assistant")
                }
            }
        }
    }
}
