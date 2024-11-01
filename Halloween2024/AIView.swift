import SwiftUI

struct AIView: View {
    @State private var viewState = ViewState.loading
    private let aiService = AIService()
    private let request: String
    init(request: String) {
        self.request = request
    }

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView()
                .task {
                    do {
                        let view = try await aiService.createView(from: request)
                        viewState = .loaded(view)
                    } catch {
                        viewState = .error(error)
                    }
                }
        case .loaded(let view):
            AnyView(erasing: view)
        case .error(let error):
            Text(String(describing: error))
        }
    }

    enum ViewState {
        case loading
        case loaded(any View)
        case error(any Error)
    }
}

extension String: @retroactive View {
    public var body: some View {
        AIView(request: self)
    }
}

#Preview { "Hello, world!" }
