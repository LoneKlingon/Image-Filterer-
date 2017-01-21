//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Anthony Youbi Sobodker on 1/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import Foundation
import UIKit



/**
 Method used to select color filter
 - Parameter color: The color filter to be applied
 - Parameter value: The value to set the filter to
 - Parameter obj: RBGBAImage class object
 - Returns: The processed Photo
 */
func colorFilter(color: String, value: Int, obj: RGBAImage) -> UIImage?
{
    var y: Int, x: Int
    
    var copy = obj //copy of myRGBA object
    
    
    for (y = 0; y<obj.height; y++)
    {
        
        for (x = 0; x<obj.width; x++)
        {
            let index = y*(obj.width) + x
            var pixel = obj.pixels[index]
            
            
            
            switch color
            {
            case "red":
                pixel.red = UInt8(min(255, value))
                
            case "green":
                pixel.green = UInt8(min(255, value))
                
            case "blue":
                pixel.blue = UInt8(min(255, value))
                
            default:
                print("Invalid Color")
            }
            
            
            
            
            copy.pixels[index] = pixel
            
            
            
            
            
            
            
        }
        
    }
    
    return copy.toUIImage() //New Image is returned here
    
}


/**
 
 Allows user to select rgb values for images; Used to modifiy color filter intensity
 - Parameter red, green, blue: Color inputs to modify
 - Parameter offset: Brightness manipulator controls intensity
 - Parameter choice: Slider between various options default options are 1-3
 - Parameter obj: RBGBAImage class object
 - Returns: The Processed Photo
 
 This Method uses an offset as a fractional multiplier to manipulate brightness as well as it can be used for direct rgb pixel color input
 */
func rgbselect(var red:Int, var green:Int, var blue:Int, offset:Float, choice:Int, obj: RGBAImage) -> UIImage?
{
    
    var y: Int, x: Int
    
    var copy = obj //copy of myRGBA object
    
    for (y = 0; y<obj.height; y++)
    {
        
        for (x = 0; x<obj.width; x++)
        {
            let index = y*(obj.width) + x
            var pixel = obj.pixels[index]
            
            
            
            if (choice <= 0 || choice > 3 )
            {
                print ("Wrong Selection. Please Try again")
            }
            
            if (choice == 2 || choice==3 )
            {
                red = Int(pixel.red)
                green = Int(pixel.green)
                blue = Int(pixel.blue)
                
            }
            
            if (choice==3)
            {
                let bw = (red + green + blue) / 3
                
                pixel.red = UInt8( bw )
                pixel.blue = UInt8( bw )
                pixel.green = UInt8( bw)
                
                pixel.red = UInt8( min(255, Float(pixel.red) / offset ) )
                pixel.blue = UInt8( min (255, Float(pixel.blue) / offset ) )
                pixel.green = UInt8( min(255, Float(pixel.green) / offset) )
                
                
            }
            else if (choice == 1)
            {
                pixel.red = UInt8( min(255, Float(pixel.red) / offset ) )
                pixel.blue = UInt8( min (255, Float(pixel.blue) / offset ) )
                pixel.green = UInt8( min(255, Float(pixel.green) / offset) )
            }
                
                
            else
                
            {
                
                pixel.red = UInt8( min(255, Float(red) / offset ) )
                pixel.blue = UInt8( min (255,Float(blue) / offset ) )
                pixel.green = UInt8( min(255, Float(green) / offset) )
            }
            
            
            copy.pixels[index] = pixel
            
            
            
            
            
            
            
        }
        
    }
    
    return copy.toUIImage() //New Image is returned here
    
    
    
}


