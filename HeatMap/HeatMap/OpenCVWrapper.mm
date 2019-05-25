//
//  OpenCVWrapper.m
//  HeatMap
//
//  Created by Ravi Patel on 5/24/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}



@end
