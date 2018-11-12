//
//  MyMeme.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-11-03.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import Foundation
import UIKit


struct MyMeme {
    
    let originalImage:UIImage?
    let memedImage:UIImage?
    let upperText:String?
    let bottomText:String?
    
    init(original:UIImage?, memed:UIImage?,upperText:String?,bottomText:String?) {
        self.originalImage = original
        self.memedImage = memed
        self.upperText = upperText
        self.bottomText = bottomText
    }
    
    
    
}
