//
//  CaricaDati.h
//  Campioni del Milan
//
//  Created by Luca Gianneschi on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaricaDati : NSObject{
    NSString *imagePath;
    NSArray *pages;
}

+(NSArray *) inizializza;

@property(nonatomic,strong) NSString *imagePath;
@property(nonatomic,strong) NSArray *pages;


@end
