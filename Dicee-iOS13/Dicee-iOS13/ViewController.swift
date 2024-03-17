import UIKit

// Threading involves running different parts of the program on separate threads concurrently.
// In iOS programming the main thread is typically reserved for UI updates., because thats where they are supposed to happen.

// Background threads are used for time consuming tasks that dont require immediate updates to the UI, like downloading files, performing complex calculations, or processing a large amount of data.

// Asynchronous execution means a task is started now but it is finished later, WITHOUT blocking the execution of the subsequent code, doesnt meant the code executes on a different thread, jsut that it is not blocking the programs flow.

// Rules for Threading: UI Updates on Main Thread: Always perform UI updates on the main thread. This is a rule in most UI frameworks, including UIKit in iOS. Failing to do so can lead to unpredictable behavior or crashes.
// Rules for Threading: Long running tasks on background threads, operations that  take a significant amount of time and do not require immediate updates to the UI should be executed on background threads. This prevents the UI from freezing or becoming unresponsive.
// Rules for Threading: Use Grand Central Dispatch (GCD) or Operation Queues: In iOS, you can use GCD or Operation Queues to manage the execution of tasks on different threads. GCD provides a C-based API for executing tasks concurrently, while Operation Queues are higher-level, object-oriented, and provide more control over task dependencies and execution order.

/**
 // WHEN TO USE THREADS vc. ASYNC EXECUTION:
 Use Multiple Threads when you need to perform time-consuming tasks that would otherwise block the main thread and make the UI unresponsive. Examples include downloading data from the internet, reading files from disk, and processing large data sets.

 Use Asynchronous Execution for tasks that can start now and complete later without needing to block the current thread. Many API calls in iOS are designed to be asynchronous (such as fetching data over the network with URLSession) and provide completion handlers for when the task finishes.

 In modern iOS development, the distinction between "using multiple threads" and "asynchronous execution" can sometimes blur, especially with the advent of Swift's concurrency model (introduced in Swift 5.5), which includes async/await syntax. This model allows for asynchronous code that is easier to write and understand, while the underlying system handles the complexities of threading and execution.
 */



// This is the main class for your view controller, inheriting from UIViewController.
class ViewController: UIViewController {
    // This IBOutlet connects an UIImageView from your storyboard to this piece of code.
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    // A variable to hold a reference to a Timer object, which can be used to perform actions at timed intervals.
    var timer: Timer?

    var diceArray: [UIImage?] = [
        UIImage(named: "DiceOne"),
        UIImage(named: "DiceTwo"),
        UIImage(named: "DiceThree"),
        UIImage(named: "DiceFour"),
        UIImage(named: "DiceFive"),
        UIImage(named: "DiceSix")
    ]
    
    // This function is called when the view controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // this action will trigger this code when its pressed
    @IBAction func rollButtonPressed(_ sender: Any) {
        startDiceAnimation()
    }
    
    func swapImagesRandomly(element1: UIImageView, element2: UIImageView, array: [UIImage?]) {
        // Ensure the array has at least one element to avoid index out of bounds error
        guard !array.isEmpty else { return }
        
        // Generate two random indexes for the array
        let randomIndex1 = Int.random(in: 0..<array.count)
        let randomIndex2 = Int.random(in: 0..<array.count)
        
        // Update the images of the passed UIImageViews with randomly selected images from the array
        // Use nil-coalescing to provide a default image if the random element is nil
        element1.image = array[randomIndex1] ?? UIImage()
        element2.image = array[randomIndex2] ?? UIImage()
    }
    
    func startDiceAnimation() {
        // Start the timer to call swapImagesRandomly every 0.250 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 0.250, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.swapImagesRandomly(element1: weakSelf.diceImageView1, element2: weakSelf.diceImageView2, array: weakSelf.diceArray)
                }
            }
        }
        
        // Schedule the timer to stop after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.timer?.invalidate() // This stops the timer
            self?.timer = nil // Optionally, you can set the timer to nil
        }
    }
    
    
    // this code below is for example purposes
    // Define the function with a parameter. For this example, we'll use 'element' as an UIImageView.
    func startDiceAnimation(element: UIImageView) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.250, repeats: true) { [weak self] _ in
            // '_' is a placeholder for a parameter that you don't need to use within the closure.
            // 'in' is the keyword that separates the closure's parameters and return type from the closure's body. It's basically saying "here's the end of the closure's header
            // [weak self] tells Swift to capture a weak reference to self within the closure. This is important for preventing strong reference cycles, which can cause memory leaks. By marking self as weak, you're saying that the closure does not own the object it's referencing, which helps in situations where the referenced object (self in this case) might be destroyed while the closure still exists. If self is destroyed, within the closure, it becomes nil.
            DispatchQueue.main.async {
                // 'self' refers to the ViewController instance,
                // and 'element' is accessed directly within the closure.
                if let weakSelf = self {
                    UIView.animate(withDuration: 0.25, animations: {
                        // Fade out the image by setting alpha to 0.5
                        element.alpha = 0.5
                    }) { (finished) in
                        // Only proceed if the animation actually finished
                        if finished {
                            // After the fade out, change the image and fade it back in.
                            // The image to set depends on the current image of the element.
                            element.image = (element.image == UIImage(named: "DiceSix")) ? UIImage(named: "DiceOne") : UIImage(named: "DiceSix")
                            
                            // Start another animation to fade the new image back in
                            UIView.animate(withDuration: 0.25) {
                                // Fade the new image back in by setting alpha to 1.0
                                element.alpha = 1.0
                            }
                        }
                    }
                }
            }
        }
    }

    // This deinitializer is called when the view controller is about to be removed from memory.
    deinit {
        // The timer is stopped and invalidated to prevent it from firing again and to facilitate the release of the ViewController from memory.
        timer?.invalidate()
    }
}
