# Customizable Memory Game
by arghpee

This project is a demonstration of the use of the Customizable Memory Game Class.

## Usage

### Adding the Class to Your Project
Clone this project and copy the three files from the 'CustomizableMemoryGame' directory into your project directory.

### Initializing the Memory Game and Adding It to Your Own View
1. In your view controller header file, include the Customizable Memory Game class.

    ```
    #include "MemoryGameViewController.h"
    ```

2. Tell the compiler that you will be implementing the Memory Game class delegate methods by adding '<MemoryGameViewControllerDelegate>' next to the piece of @interface code in you view controller header file.

    ```
    @interface YourViewController : UIViewController <MemoryGameViewControllerDelegate>

    @end
    ```

3. Add a private property of type 'MemoryGameViewController' to your view controller class implementation file.

    ```
    @interface MainViewController ()

    @property (nonatomic, strong) MemoryGameViewController *gameViewController;

    @end
    ```

4. In your 'viewDidLoad' method, add the following code. You may initialize the game view controller with your desired number of unique cards

    ```
    self.gameViewController = [[MemoryGameViewController alloc] initWithNumberOfCards:8]; // 8 is the number of unique cards

    self.gameViewController.delegate = self; // set your view controller as the delegate of the memory game view controller

    [self.view addSubview:self.gameViewController.view];
    [self addChildViewController:self.gameViewController];
    ```

### Required Delegate Methods
In order for the customizable memory game to work properly, the delegate, your view controller class, must implement the following methods.

    // The 'cardImages' method should return an array of UIImage instances. The number of elements of the returned array should equal the number of unique cards added to 1. The last element in the array is the image shown when each card is faced down.
    - (NSArray*)cardImages;

    // The 'cardWidth' method should return the width of each card in pixels.
    - (CGFloat)cardWidth;

    // The 'cardHeight' method should return the height of each card in pixels.
    - (CGFloat)cardHeight;

    // The 'numberOfCardsInRow' method should return the number of cards displayed on each row.
    - (NSInteger)numberOfCardsInRow;

    // The 'timerMaxTime' method should return the time limit for the player to finish the game. It should be in seconds.
    - (NSInteger)timerMaxTime;

### Optional Delegate Methods
The following delegate methods allow for further customization. They allow the programmer to change parameters such as label font color and font size. If any of the methods below are not implemented, default parameters will be used.

    // Should return backround color
    - (UIColor *)backgroundColor;

    // Should return label font color
    - (UIColor *)labelFontColor;

    // Should return label font size
    - (NSInteger)labelFontSize;

    // Should return label font name
    - (NSString *)labelFontName;

### Exceptions
The Customizable Memory Game class throws an exception when the number of elements returned by the required 'cardImages' method is not equal to the number of unique cards set during initialization plus one.    
