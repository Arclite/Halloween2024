//  Created by Geoff Pado on 3/19/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public struct MessageServiceResponse: Decodable {
    public let content: [ContentBlock]
    public let usage: Usage

    public struct ContentBlock: Decodable {
        public let text: String
    }

    public struct Usage: Decodable {
        public let inputTokens: Decimal
        public let outputTokens: Decimal

        enum CodingKeys: String, CodingKey {
            case inputTokens = "input_tokens"
            case outputTokens = "output_tokens"
        }
    }
}
