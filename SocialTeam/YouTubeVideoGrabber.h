//
//  YouTubeVideoGrabber.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//classe utility per il caricamento dei dati dei video da YouTube

@interface YouTubeVideoGrabber : NSObject <UIAlertViewDelegate>{
    NSMutableData *datiVideo;
}

@property (nonatomic,strong) NSMutableData *datiVideo;

//metodo di classe che restituisce la lista dei video da caricare nella tabella
+(NSMutableArray *)listaVideo:(NSString *)video;

@end
