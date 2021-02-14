//
//  ViewController.swift
//  ImageViewer - Lab3
//
//  Created by Mehrdad on 2020-11-12.
//  Copyright © 2020 Seneca College. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    
    // MARK: Properties
    
    // Image addresses in an array as a computed property
    var imgStringArray: [String] {
        get {
            var result = [String]()
            for item in BigImages.allCases {
                result.append(item.rawValue)
            }
            return result
        }
    }
    // index variable to access items in the array
    var index = 0
    
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the activity indicatory when finished loading
        activityIndicator.hidesWhenStopped = true
        
        // Enable userInteraction on imageView
        imageView.isUserInteractionEnabled = true
//        view.addSubview(imageView)
        
        // Configure the swipeLeft and add it to the imageView
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        swipeLeft.direction = .left
//        self.view.addGestureRecognizer(swipeLeft)
        imageView.addGestureRecognizer(swipeLeft)
        
        // Configure the swipeRight and add it to the imageView
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        swipeRight.direction = .right
//        self.view.addGestureRecognizer(swipeRight)
        imageView.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Load the app with the first image as its default
        loadImage(urlString: imgStringArray[index]) { (image) in
            self.imageView.image = image
        }
    }
    
    
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
        // Calculate the index for the image in the array to fetch
        increment()
        
        // Call the method to fetch image & pass the closure to its completionHandler
        loadImage(urlString: imgStringArray[index]) { (image) in
            self.imageView.image = image
        }
    }
    
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        // Calculate the index for the image in the array to fetch
        decrement()
        
        // Call the method to fetch image & pass the closure to its completionHandler
        loadImage(urlString: imgStringArray[index]) { (image) in
            self.imageView.image = image
        }
    }
    

    
    // MARK: Helper Methods
    
    // Completion handler and method to download the image in the background
    func loadImage(urlString: String, completion handler: @escaping (_ image: UIImage?) -> Void) {
        
        // activityIndicator starts animating
        activityIndicator.startAnimating()
        
        // Create the URL for the image
        let imgURL = URL(string: urlString)
        
        // Create a background global queue with userInitiated QOS
        let downloadQueue = DispatchQueue.global(qos: .userInitiated)
        
        // Jump to the background queue and add the closure to download the image
        downloadQueue.async { () -> Void in
            // safely unwrap the optional url with value binding
            if let imgURL = imgURL {
                // Obtain the data from url
                let imageData = try? Data(contentsOf: imgURL)
                // turn the data into a UIImage
                let downloadedImage = UIImage(data: imageData!)
                
                // Use main thread to update the UI
                DispatchQueue.main.async {
                    handler(downloadedImage)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    // Swipe Handler
    @objc func handleGesture(_ gesture: UISwipeGestureRecognizer) {
        
        // Calculate the index for the right swipe and fetch the image
        if gesture.direction == .right {
            decrement()
//            print("Swiped right")
            loadImage(urlString: imgStringArray[index]) { (image) in
                self.imageView.image = image
            }
            
        // Calculate the index for the left swipe and fetch the image
        } else if gesture.direction == .left {
            increment()
//            print("Swiped left")
            loadImage(urlString: imgStringArray[index]) { (image) in
                self.imageView.image = image
            }
        }
    }
    
    // Method to increase index by one or reset
    func increment() {
        if index < imgStringArray.count - 1 {
            index += 1
        } else if index == imgStringArray.count - 1 {
            index = 0
        }
    }
    
    // Method to decrease index by one or reset
    func decrement() {
        if index > 0 {
            index -= 1
        } else if index == 0 {
            index = imgStringArray.count - 1
        }
    }

}

