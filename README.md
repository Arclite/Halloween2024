# Halloween "Mad Science" Project 2024
Every year for Halloween, I [live-stream](https://twitch.tv/cocoatype) a project where I build something that… probably shouldn't exist. A project to be more preoccupied with whether or not I **could**, where I don’t stop to think if I **should**. This is the project for Halloween 2024.

This project implements a SwiftUI view that enables you to just place a Swift string describing a view, and that view is built by an LLM (Anthropic's [Claude](https://claude.ai)) at runtime. For example:

```swift
import SwiftUI

@main
struct Halloween2024App: App {
    var body: some Scene {
        WindowGroup {
            """
            A game of tic-tac-toe you play by clicking each box. Xs should be red and Os should be green. If all the squares are filled, make a snarky comment about how tic-tac-toe is boring.
            """
        }
    }
}
```

This can be your whole app!
<img width="975" alt="image" src="https://github.com/user-attachments/assets/952f0f1c-e8bb-4ae6-89cf-84e8d01ec88d">

## How to Use

1. Download the project.
2. Edit the Halloween2024 scheme.
3. Select "Run" in the sidebar.
4. Select the "Arguments" tab.
5. Add an environment variable named `CLAUDE_API_KEY` with your API key.
<img width="799" alt="image" src="https://github.com/user-attachments/assets/74f60509-0f9e-4908-b73a-7ce8f4a14745">

6. Change the request in `ContentView` to whatever you'd like.
7. Build and run!

If you want to change what the app does, simply edit the string in `ContentView`.

## Frequently Asked Questions
**Why would I use this?**    
Do not use this.

**Is it safe to run this on my computer?**
Probably not. I had to strip away a lot of the sandboxing and hardened runtime to get this to work. Use at your own risk.

**Does this work on iOS?**
Not at this time. I think you'd have to have a compiler that ran on a server somewhere to get it to work. If at all.

**Can I use a different language model?**    
Other Claude models are available by swapping the `model` parameter in `AIService`. Non-Anthropic models are left as an exercise for the reader.

**Is this a crime against humanity?**    
That's for the courts to decide.
