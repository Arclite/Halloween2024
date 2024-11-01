//  Created by Geoff Pado on 3/19/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public struct MessageService {
    private let apiKey: String
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func post(_ serviceRequest: MessageServiceRequest) async throws -> MessageServiceResponse {
        guard let url = URL(string: "https://api.anthropic.com/v1/messages")
        else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(serviceRequest)

        let (data, _) = try await URLSession.shared.data(for: request)

        let response = try JSONDecoder().decode(MessageServiceResponse.self, from: data)
        return response
    }
}
