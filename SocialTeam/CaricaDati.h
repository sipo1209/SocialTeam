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

//inizializza il numero di pulsanti che servono all'APP, con nome e icona a partire da un file Plist
+(NSArray *) inizializza;

//imposta local notification per aprire l'App in corrispondenza di date importanti per la squadra, i dai li prendo da PARSE in modo da aggiornare i dati periodicamente
+(void)impostaLocalNotification;

@property(nonatomic,strong) NSString *imagePath;
@property(nonatomic,strong) NSArray *pages;


@end
