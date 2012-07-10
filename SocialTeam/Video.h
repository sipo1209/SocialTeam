//
//  Video.h
//  Campioni del Milan
//
//  Created by Luca Gianneschi on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//modello del singolo video

@interface Video : NSObject{
    //istanze delle stringhe che prelevo dal JSON
    NSString *titolo;
    NSString *description;
    NSArray *tags;
    NSString *thumbURL;
    NSString *urlVideo;
}
//definizione delle properties dell'oggetto video
@property (nonatomic,strong) NSString *titolo;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,strong) NSString *thumbURL;
@property (nonatomic,strong) NSString *urlVideo;


+(id)videoWithTitle:(NSString *)title 
        description:(NSString *)description 
               tags:(NSArray *)tags 
           thumbURL:(NSString *)thumbURL 
           urlVideo:(NSString *)urlVideo;

@end
