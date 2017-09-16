## **This Project needs Xcode 9 and iOS 11 to compile**
# What does the NYTimes think of ____?
## An exploration of the NYTimes API and CoreML Sentiment Analysis

### What the app does:
Allows you to search for a topic, via "Times Tags" and see what the NYTimes writers think of it. It does this through loading of the last 10 articles associated with the tag and preforming sentiment analysis on the headlines and abstracts.

#### CoreML Model Used:
- [cocoa-ai's Sentiment Polarity CoreML Demo](https://github.com/cocoa-ai/SentimentCoreMLDemo)

##### Future Considerations:
- Right now the app only runs analysis on the headlines and abstracts, it would be good to be able to get the full articles to analyze.
- An explanation of what "(Per)"/"(Des)" annotations are at the end of tags, maybe replacing them with the full words "(Person)"

#### Architectural Decisions:
- The app is built using a variant of MVVM
    - Even though the topic finder and sentiment analysis results screen are part of the same view controller both sections have their own view models as the functionality is very much seperate
    - **This variant has the View Model broken up into 3 parts**:
        - The View Model's bindable properties: the observables that are passed into the view that the view can observe and update it's layout based on
        - The View Model's action: actions that can be called on the view model, usually hooked up to button taps/ user interaction
        - The View Model's implementation: where all the business logic happens, actions are implemented, services are called, and bindables are set/updated
    - Each View Model has a delegate for when it needs to communicate with the outside world, such as when a "Times Tag" is selected and new articles need to be fetched and analyzed.
        - The delegate conforms to the `ErrorPresenter` protocol which allows you to pass any errors to the view model's delegate and the delegate's implementation can decide how to show it
        - View Controllers are usually the implementor of the View Model's delegate, as the most common action taken from these delegates is presenting new Controllers
- When a service is created a file private global instance of them is created.
    - A dependency injector protocol is then created which adds a computed property to the implementer which gains access to the global instance, through a default implementation
        - This way, when testing a class that conforms to the injector protocol you can override the default implementation and return a stub instead of the private global instance
        - You get the ease of use of singletons without the testability nightmares
        - If you want a class to gain access to a service you can just tell it to implement the injector protocol and it will automatically gain access to a shared instance of it
            - No more passing services deep through the app

- Views are defined in code and constraints are written using SnapKit
    - In my opinion, writing views in code is clearer than using Story Boards, all of your properties are clearly visible in one location, no need to hunt through menus to find and set them
    - Merge conflicts are much easier to deal with when using code. Autolayout XML is not easy to read
- UI Constants such as fonts and padding values are static properties on a `UIConstants` class
- Common functionality such as listening to keyboard open and close events are defined as protocols with default implementations
    - This way if a view/controller needs to listen to keyboard events you can conform to `KeyboardListener`, call `setUpKeyboardListeners()`, and implement `keyboardOpened(withFrame:)` and  `keyboardClosed()` . Not needing to worry about the notification implementation details over and over
    - As a protocol instead of a class you don't need to worry about multiple inheritance. Anything can implement these functionalities
    
#### Frameworks Used:
- Moya - for network requests
- ReactiveKit/Bond - for view/viewmodel binding and functional reactive programming
- PromiseKit
- SwiftyJSON
- SnapKit - for setting up constraints
- Down - for displaying Markdown files (this about page is the readme for the git repo)
- ionicons

#### Development Frameworks Used
- SwiftLint
- FBSnapshotTestCase

