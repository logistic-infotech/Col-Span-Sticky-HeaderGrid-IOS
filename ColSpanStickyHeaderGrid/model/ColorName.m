//
//  ColorName.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColorName.h"

@implementation ColorName

+ (ColorName*)colorNameWithColor:(UIColor *)color name:(NSString *)name
{
    ColorName *cn = [[ColorName alloc] init];
    cn.color = color;
    cn.name = name;
    return cn;
}

@end

@implementation ColorName (Random)

+ (ColorName*)randomColorName
{
    static NSArray *choices = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        choices = @[
                    [ColorName colorNameWithColor:[UIColor blueColor] name:@"Blue"],
                    [ColorName colorNameWithColor:[UIColor redColor] name:@"Red"],
                    [ColorName colorNameWithColor:[UIColor greenColor] name:@"Green"],
                    [ColorName colorNameWithColor:[UIColor yellowColor] name:@"Yellow"],
                    [ColorName colorNameWithColor:[UIColor orangeColor] name:@"Orange"],
                    [ColorName colorNameWithColor:[UIColor purpleColor] name:@"Purple"],
                    [ColorName colorNameWithColor:[UIColor lightGrayColor] name:@"Gray"],
                    [ColorName colorNameWithColor:[UIColor colorWithHue:0 saturation:0.5 brightness:1 alpha:1.0] name:@"Pink"]
                    ];
    });
    
    NSInteger randIdx = arc4random() % choices.count;
    return choices[randIdx];
}
    
@end