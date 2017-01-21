//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Anthony Youbi Sobodker on 1/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var blackWhiteButton: UIButton!
    
    @IBOutlet var compareButton: UIButton!
    var blackWhiteImage: UIImage? // Holds black and white image
    var redImage: UIImage?
    var greenImage: UIImage?
    var blueImage: UIImage?
    var filteredImage: UIImage? // Holds most current filtered image
    var prevFilteredImage: UIImage? //Holds the last filtered image

    var original: UIImage?
    var state: Bool = false // Stores compare button state
    var editButtonState: Bool = false // Stores edit button state
    var filterState: Bool = false // Stores compare button state
    var hasBeenFiltered: Bool = false // Checks if filter has ever been applied

    @IBOutlet var sliderMenu: UIView!

    @IBOutlet var sliderButton: UIButton! // Is for the editButton
    var RGBA: RGBAImage?
    
    
    @IBOutlet var sliderControl: UISlider! // Used for the slider values
    var effectNum: Int = 0 // Tracks the current filter loaded
    
    @IBOutlet var originalLabel: UILabel! // Overlay label for original image
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        original = imageView.image
        RGBA = RGBAImage(image: original!)
        checkState()
        checkStateEditButton()
        
        //adds hold gesture to uiimageview
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.toggleImage))
        imageView.addGestureRecognizer(hold)
        imageView.userInteractionEnabled = true
        
       hideOverView()
    }
   

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /// Toggles the image when screen is tapped
    func toggleImage(sender : UIGestureRecognizer)
    {
        
        //End of Gesture
        if sender.state == .Ended
        {
            if(filterState == true)
            {
                imageView.image = filteredImage!
                
                hideOverView()
                
                
                
            }
            
        }
            //Beginning of Gesture
        else if sender.state == .Began
        {
            imageView.image = original!
            
            viewOverView()
            
        }
        
    }
    
    
    func hideOverView()
    {
        if(compareButton.selected == false)
        {
            originalLabel.hidden = true

        }
        
        
    }
    
    func viewOverView()
    {

        originalLabel.hidden = false
        
    }
    
    
    
   
    
    /// Applies crossFade Animation between filtered images and original
    func crossFadeFilter()
    {
        if (hasBeenFiltered == true)
        {
            let crossFade:CABasicAnimation = CABasicAnimation(keyPath: "contents");
            crossFade.duration = 5.0;
            crossFade.fromValue = prevFilteredImage!.CGImage;
            crossFade.toValue = filteredImage!.CGImage;
            imageView.layer.addAnimation(crossFade, forKey:"animateContents");
            imageView.image = filteredImage
            
            
        }
        
    }
    
    
 
    /// Sets image back to original unfiltered image
    @IBAction func onCompare(sender: AnyObject)
    {
        
        if (compareButton.selected == false)
        {
           
            prevFilteredImage = filteredImage
            filteredImage = original
            hasBeenFiltered = true
            crossFadeFilter()
            compareButton.selected = true
            sliderButton.enabled = false
            self.sliderMenu.removeFromSuperview()
            sliderButton.selected = false
            viewOverView()

        }
        
        else
        {
            var temp: UIImage
            temp = prevFilteredImage!
            prevFilteredImage = filteredImage
            filteredImage = temp
            crossFadeFilter()
            compareButton.selected = false
            sliderButton.enabled = true
            hideOverView()
            
            
        }
        

    }
    
    
    
    /// Button Action for Black & White Filter
    @IBAction func onBlackWhite(sender: AnyObject)
    {
        blackWhiteFilter(1)
        sliderControl.setValue(0.5, animated: false)
    }
    
    /// Button Action for Red Filter
    @IBAction func onRed(sender: AnyObject)
    {
        redFilter(255, option: 1, intensityValue: 1)
        sliderControl.setValue(0.5, animated: false)
    }
    
    /// Button Action for Green Filter
    @IBAction func onGreen(sender: AnyObject)
    {
        greenFilter(255, option: 1, intensityValue: 1)
        sliderControl.setValue(0.5, animated: false)
    }
    
    /// Button Action for Blue Filter
    @IBAction func onBlue(sender: AnyObject)
    {
        blueFilter(255, option: 1, intensityValue: 1)
        sliderControl.setValue(0.5, animated: false)
    }
    

    
    /**
    Applies Black & White Filter to Image
     - Parameter intensityValue: The brightness intensity of the filter

     */
    func blackWhiteFilter(intensityValue: Float)
    {
        RGBA = RGBAImage(image: original!)
        blackWhiteImage = rgbselect(1, green: 1, blue: 1, offset: intensityValue, choice: 3, obj: RGBA!)
        imageView.image = blackWhiteImage
        state = true
        checkState()
        editButtonState = true
        checkStateEditButton()
        effectNum = 1
        prevFilteredImage = filteredImage
        filteredImage = blackWhiteImage
        filterState = true
        
        if (prevFilteredImage != blackWhiteImage)
        {
            crossFadeFilter()

        }

        hasBeenFiltered = true
        compareButton.selected = false
        hideOverView()
    }
    
    /**
     Applies Red Filter to Image
     - Parameter redValue: The default red color value for the filter
     - Parameter option: Filtering option selector
     - Parameter intensityValue: The brightness intensity of the filter
     
     */
    func redFilter(redValue: Int, option:Int, intensityValue:Float)
    {
        RGBA = RGBAImage(image: original!)
        redImage = colorFilter("red", value: redValue, obj: RGBA!)
        RGBA = RGBAImage(image: redImage!)
        redImage = rgbselect(1, green: 1, blue: 1, offset: intensityValue, choice: option, obj: RGBA!) //adjust brightness
        imageView.image = redImage
        state = true
        checkState()
        editButtonState = true
        checkStateEditButton()
        effectNum = 2
        prevFilteredImage = filteredImage
        filteredImage = redImage
        filterState = true
        
        if (prevFilteredImage != redImage)
        {
            crossFadeFilter()

            
        }
        
        hasBeenFiltered = true
        compareButton.selected = false
        hideOverView()

    }
    
    /**
     Applies Green Filter to Image
     - Parameter greenValue: The default green color value for the filter
     - Parameter option: Filtering option selector
     - Parameter intensityValue: The brightness intensity of the filter
     
     */
    func greenFilter(greenValue: Int, option: Int, intensityValue: Float)
    {
        RGBA = RGBAImage(image: original!)
        greenImage = colorFilter("green", value: greenValue, obj: RGBA!)
        RGBA = RGBAImage(image: greenImage!)
        greenImage = rgbselect(1, green: 1, blue: 1, offset: intensityValue, choice: option, obj: RGBA!) //adjust brightness
        imageView.image = greenImage
        state = true
        checkState()
        editButtonState = true
        checkStateEditButton()
        effectNum = 3
        prevFilteredImage = filteredImage
        filteredImage = greenImage
        filterState = true

        if (prevFilteredImage != greenImage)
        {
            crossFadeFilter()

        }
        
        hasBeenFiltered = true
        compareButton.selected = false
        hideOverView()

        
    }
    
    /**
     Applies Blue Filter to Image
     - Parameter blueValue: The default blue color value for the filter
     - Parameter option: Filtering option selector
     - Parameter intensityValue: The brightness intensity of the filter
     
     */
    func blueFilter(blueValue: Int, option: Int, intensityValue: Float)
    {
        RGBA = RGBAImage(image: original!)
        blueImage = colorFilter("blue", value: blueValue, obj: RGBA!)
        RGBA = RGBAImage(image: blueImage!)
        blueImage = rgbselect(1, green: 1, blue: 1, offset: intensityValue, choice: option, obj: RGBA!) //adjust brightness
        imageView.image = blueImage
        state = true
        checkState()
        editButtonState = true
        checkStateEditButton()
        effectNum = 4
        prevFilteredImage = filteredImage
        filteredImage = blueImage
        filterState = true

        if (prevFilteredImage != blueImage)
        {
            crossFadeFilter()
            
        }
        
        hasBeenFiltered = true
        compareButton.selected = false //turn off compare button if it was on from a previous filter
        hideOverView()


    }
    
 
    
    /// Function used to check state of compare button. To determine when it should be enabled/disabled
    func checkState()
    {
        if (state == false)
        {
            compareButton.enabled = false
        }
        else
        {
            compareButton.enabled = true

        }
    }
    
    /// Function used to check state of Edit button. To determine when it should be enabled/disabled
    func checkStateEditButton()
    {
        if (editButtonState == false)
        {
            sliderButton.enabled = false
        }
        else
        {
            sliderButton.enabled = true
            
        }
    }
    
      
    /// Button Action for New Photo Button
    @IBAction func onNewPhoto(sender: AnyObject)
    {
        //creates action menu popup
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        //button title; button style; action handler code
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
       
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
        
        
    }
    
    /// Button Action for Edit Button
    @IBAction func onEdit(sender: AnyObject)
    {
        sliderMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        if(sliderButton .selected == true)
        {
            sliderButton.selected = false
            
            hideSliderMenu()
            
            
        }
        else
        {
            hideSecondaryMenu()
            filterButton.selected = false
            
            showSliderMenu()
            sliderButton.selected = true
            
        }
        
    }
    
    /// Button Action for Filter Button
    @IBAction func onFilter(sender: AnyObject)
    {
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        if(filterButton.selected == true)
        {
            filterButton.selected = false
            
            hideSecondaryMenu()
            
            
            
        }
        else
        {
            hideSliderMenu()
            sliderButton.selected = false
            showSecondaryMenu()
            filterButton.selected = true
            
        }
        
    }
    
    /// Button Action for Share Button
    @IBAction func onShare(sender: AnyObject)
    {
        let activityController = UIActivityViewController(activityItems: ["Share our app!", imageView.image!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    

    
    /// Action Handler for Slider; Manipulates Filter brightness intensity on slider changed value
    @IBAction func onSlider(sender: AnyObject)
    {
        var currentValue: Float = sliderControl.value
        
        
        if (effectNum == 0)
        {
            //do nothing
        }
            
            
        else if(effectNum == 1 && currentValue != 0 )
        {
            blackWhiteFilter(currentValue * 10)
            
        }
            
        else if(effectNum == 2 && currentValue != 0 )
        {
            redFilter(255, option: 1, intensityValue: currentValue * 10 )
            
        }
            
        else if(effectNum == 3 && currentValue != 0 )
        {
            greenFilter(255, option: 1, intensityValue: currentValue * 10 )
           
        }
            
        else if(effectNum == 4 && currentValue != 0 )
        {
            blueFilter(255, option: 1, intensityValue: currentValue * 10 )
            
        }
        
        
        
    }
    
    
    func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum()
    {
        
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .PhotoLibrary
        
        presentViewController(albumPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //change viewcontroller image
            imageView.image = image
            
            //update imageview image; for filter effects
            RGBA = RGBAImage(image: imageView.image!)
            
            
            //update original image
            original = image
            
            
            //resets compare button and edit button state and checks again to determine whether or not they should be enabled
            state = false
            editButtonState = false
            checkState()
            checkStateEditButton()
            filterState = false
            hasBeenFiltered = false
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showSliderMenu()
    {
        view.addSubview(sliderMenu)
        
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(44)
        
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0.0
        UIView.animateWithDuration(0.5)
        {
            self.sliderMenu.alpha = 1.0
        }
        

        
    }
 
    
    func showSecondaryMenu()
    {
        view.addSubview(secondaryMenu)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0.0
        UIView.animateWithDuration(0.5)
        {
            self.secondaryMenu.alpha = 1.0
        }

    }
    
    func hideSliderMenu()
    {
        UIView.animateWithDuration(0.5, animations:
            {
                
                self.sliderMenu.alpha = 0
                
        }) { completion in
            
            if (completion == true)
            {
                self.sliderMenu.removeFromSuperview()
                
            }
            
        }
    }
    
    func hideSecondaryMenu()
    {
        
        UIView.animateWithDuration(0.5, animations:
            {
            
            self.secondaryMenu.alpha = 0

            }) { completion in
                
                if (completion == true)
                {
                    self.secondaryMenu.removeFromSuperview()

                }
        }

    }

}

