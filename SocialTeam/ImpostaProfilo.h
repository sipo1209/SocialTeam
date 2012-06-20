//
//  ImpostaProfilo.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//Questa classe imposta la grafica del view controller di dialogo. I dati presi da parse vengono presi in background

#import <Foundation/Foundation.h>

@class QRootElement;


@interface ImpostaProfilo : NSObject

@property(nonatomic,strong) NSArray *rosa;

+(QRootElement *)inizializzazioneForm;
+(QRootElement *)inizializzazioneSquadre;

@end
