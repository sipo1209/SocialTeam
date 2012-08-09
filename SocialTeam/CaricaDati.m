//
//  CaricaDati.m
//  Campioni del Milan
//
//  Created by Luca Gianneschi on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


///questa classe carica i dati per il Launcher di NIMBUS, lo fa a partire da un file plit, basta editare quello per aumentare diminuire i pulsanti nella spingboard di partenza
#import "CaricaDati.h"

@implementation CaricaDati
@synthesize imagePath,pages;

+(NSArray*) inizializza{
    //inserisco ed ordino i dati del viewcontroller
    NSString *datiPlist = [[NSBundle mainBundle] pathForResource:@"dati" 
                                                          ofType:@"plist"];
    
	NSMutableArray *tmp1 = [[NSMutableArray alloc] initWithContentsOfFile:datiPlist];
    NSMutableArray *dati = tmp1;
    //utilizza il seguente codice per dividere le pagine
    
    NSMutableArray *wholeArray = [[NSMutableArray alloc] init];
     int i;
     for (i = 0; i <= [dati count]-1; i = i+1){
     
    //inizio il ciclo for per inserire i dati contenuti nel plist negli oggetti del modello
    NILauncherItemDetails *item = [NILauncherItemDetails itemDetailsWithTitle:[[dati objectAtIndex:i] objectForKey:@"title"]
                                                                    imagePath:NIPathForBundleResource([NSBundle mainBundle],[[dati objectAtIndex:i] objectForKey:@"imagePath"])];
    
     //aggiungo l'oggetto item all'array
     [wholeArray addObject:item];
     }
    //suddivisione delle pagine
    //pagina 0
    NSArray *page0 = [[NSArray alloc] init];
    NSRange range0 = NSMakeRange(0, 9);
    page0= [wholeArray subarrayWithRange:range0];
    
    //pagina 1
    NSArray *page1 = [[NSArray alloc] init];
    NSRange range1 = NSMakeRange(9, 1);
    page1= [wholeArray subarrayWithRange:range1];
    
    NSArray *pages = [NSArray arrayWithObjects:page0,page1,nil];
    return pages;
    }

@end
