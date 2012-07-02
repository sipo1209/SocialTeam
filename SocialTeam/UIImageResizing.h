//
//  UIImageResizing.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.



//QUESTA E' UNA CLASSE DI SERVIZIO CHE MI SERVER PER FARE il RESIZE DELLE IMMAGINI

#import <UIKit/UIKit.h>

@interface  UIImage (Resize)

-(UIImage *)scaledToSize:(CGSize) newSize;

@end
