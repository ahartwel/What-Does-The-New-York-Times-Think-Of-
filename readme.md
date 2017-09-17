## **This Project needs Xcode 9 and iOS 11 to compile**
# What does the NYTimes think of ____?
## An exploration of the NYTimes API and CoreML Sentiment Analysis

### What the app does:
Allows you to search for a topic and see what the NYTimes writers think of it.
#### How it does it:
1. Searches for topics via the `Times Tag API`
2. Pulls the last 10 articles associated with the the selected tag via the `Article Search API`.
3. Runs sentiment analysis on the articles using CoreML.
4. Displays the results.

![Gif of app in use](https://github.com/ahartwel/What-Does-The-New-York-Times-Think-Of-/blob/master/appgif.gif?raw=true)

#### CoreML Model Used:
- [cocoa-ai's Sentiment Polarity CoreML Demo](https://github.com/cocoa-ai/SentimentCoreMLDemo)

### Future Considerations:
- Right now the app only runs analysis on the headlines and abstracts, it would be good to be able to get the full articles to analyze.
- An explanation of what "(Per)"/"(Des)" annotations are at the end of tags, maybe replacing them with the full words "(Person)" or removing them from the UI.
- Better error handling. Some topics don't return any articles and right now if an error happens during sentiment analysis because of no articles, it is ignored.
- Automate stub generation with Sourcery

### Architectural Decisions:
#### MVVM and View Models
- Even though the Topic Finder and Sentiment Analysis Results screen are part of the same view both sections have their own view models as their functionality is very much seperate.
- A View Model is broken up into 3 parts:
    - A bindable properties protocol:
        - The bindables protocol is a collection of Observables that represent view state.
        - It is passed into the view and the view observes changes to the properties and updates accordingly.
    - An actions protocol:
        - The actions protocol is a collection of methods that can be called on the view model.
        - Usually each action correlates to user input.
        - This is passed into the view and stored. It is basically a view's delegate.
    - And the actual implementation:
        - A class that conforms to both the bindable protocol and the actions protocol.
        - Will implement the business logic of the view.
        - Call services and makes updates to data as needed.
- Each view model has a delegate for when it needs to talk to the outside world.
    - The implementor of this delegate is usually the View Controller as the view model usually only needs to talk to the outside world to push a new view controller or dismiss itself.
    - The delegate will also normally conform to the `ErrorPresenter` protocol.
        - This protocol, when implemented by a view controller, gets automatic behaivor for presenting a `UIAlertController` constructed by an `Error` instance.

#### Services
- When a service is created a stub is also created.
- A `{{ServiceName}}Requester` protocol is defined.
    - This protocol serves as a dependency injector. View Models will conform the the  `{{ServiceName}}Requester` protocol and depending on which build configuration is compiled the conformer will automatically gain access to a global shared implementation of the service or a global shared stub.
    - The `Requester` protocol gives you the ease of use of singletons (you don't have to worry about passing the service around in your app), without testability nightmares.
    - When you run your app's tests, every view model will automatically point to the stubbed version of your services and you can control what they return (ex. `ServiceStubs.timesTagApiStub.getTagsReturn = stubbedTagsResponse`).

#### Views
- Views are defined in code with constraints written using SnapKit
    - Storyboards cause headaches with merge conflicts and it becomes harder to find what properties are set on views.
    - All subviews are defined using lazy closures so all view set up and styling is in one place and easy to find.
- UIConstants such as fonts and padding values are static properties on a `UIConstants` class.

#### Commonly Used Functionality
- Common functionality such as listening to keyboard open and close events are defined as protocols with default implementations
    - This way if a view/controller needs to listen to keyboard events you can conform to `KeyboardListener`, call `setUpKeyboardListeners()`, and implement `keyboardOpened(withFrame:)` and  `keyboardClosed()`. Not needing to worry about the notification implementation details over and over.
        - ReactiveKit and dispose bags automatically take care of unregisterting the notifications associated with NotificationCenter.
    - As a protocol instead of a class you don't need to worry about multiple inheritance. Anything can implement these functionalities just by conforming.

#### Testing
- View testing is done via unit tests using FBSnapshotTestCase. Snapshots of the view's state are checked after every action you can take.
    - Doing view testing this way serves as a useful development tool, no need to build your app and navigate to a screen/state to check out UI Changes
    - Also lets you know after every feature addition/change if you've accidently changed anything about the layout of the app
- Services are tested using stubbed JSON responses that return immediately.
    - This also helps you during development as you don't need to run your app to test API parsing, just run a unit test that calls the service with a stubbed API response.
- View Models contain most of the business logic and are tested with unit tests in which the services, delegates, and other dependencies are stubbed and you decide what objects are returned from them.
    
#### Frameworks Used:
- Moya - for network requests
- ReactiveKit/Bond - for view/viewmodel binding and functional reactive programming
- PromiseKit - provides better syntax for async methods than closures
- SwiftyJSON - easier JSON parsing
- SnapKit - for setting up constraints
- Down - for displaying Markdown files (this about page is the readme for the git repo)
- ionicons

#### Development Frameworks Used
- SwiftLint
- FBSnapshotTestCase

