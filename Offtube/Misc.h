//
//  Misc.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/16.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#ifndef Offtube_Misc_h
#define Offtube_Misc_h


#define ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" \
message:msg \
delegate:self \
cancelButtonTitle:nil \
otherButtonTitles:@"OK", nil]; \
[alert show];





#endif
