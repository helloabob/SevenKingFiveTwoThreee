//
//  CLog.h
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#ifndef SevenKingFiveTwoThreee_CLog_h
#define SevenKingFiveTwoThreee_CLog_h


#ifdef DEBUG
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define CLog(format, ...)
#endif

#endif
