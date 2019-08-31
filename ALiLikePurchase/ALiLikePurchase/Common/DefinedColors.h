//
//  DefinedColors.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#ifndef DefinedColors_h
#define DefinedColors_h



#define RGB(R,G,B) RGBA((R),(G),(B),0.99)

#define RGBA(R,G,B,A) [UIColor colorWithRed:((R)/255.0) green:((G)/255.0) blue:((B)/255.0) alpha:(A)]

#define TEXTNORMALCOLOR    RGB(102, 102, 102)
#define TEXTCHANGECOLOR    RGB(51, 51, 51)

#define REDLINECOLOR RGB(251, 87, 84)

#endif /* DefinedColors_h */
