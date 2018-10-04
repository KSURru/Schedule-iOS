//
//  CornerStickers.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24/09/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

enum CornerStickerType {
    case left, right
}

let cornerStickers: [CornerStickerType: [UIImage]] = [
    
    .left: [
                UIImage(named: "cornerSticker1Left")!,
                UIImage(named: "cornerSticker2Universal")!,
                UIImage(named: "cornerSticker3Left")!,
                UIImage(named: "cornerSticker4Left")!,
                UIImage(named: "cornerSticker5Left")!,
                UIImage(named: "cornerSticker6Left")!,
                UIImage(named: "cornerSticker7Universal")!,
                UIImage(named: "cornerSticker8Left")!
    ],
    
    .right: [
                UIImage(named: "cornerSticker1Right")!,
                UIImage(named: "cornerSticker2Universal")!,
                UIImage(named: "cornerSticker3Right")!,
                UIImage(named: "cornerSticker4Right")!,
                UIImage(named: "cornerSticker5Right")!,
                UIImage(named: "cornerSticker6Right")!,
                UIImage(named: "cornerSticker7Universal")!,
                UIImage(named: "cornerSticker8Right")!
    ]
    
]
