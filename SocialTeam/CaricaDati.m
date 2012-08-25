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
    NSRange range1 = NSMakeRange(9, 2);
    page1= [wholeArray subarrayWithRange:range1];
    
    NSArray *pages = [NSArray arrayWithObjects:page0,page1,nil];
    return pages;
    }

+(void)impostaLocalNotification{
    NSLog(@"Imposta local notification");
    
    PFQuery *query = [PFQuery queryWithClassName:@"LocalNotification"];
    [query whereKeyExists:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i = 0; i < objects.count; i = i +1) {
                //imposto il calendario per la schedulazione della notifica
                NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
                NSCalendarUnit unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
                
                //prendo la data dall'oggetto parse
                NSDate *data = [[objects objectAtIndex:i] objectForKey:@"data"];
                NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:data];
                NSDate *itemDate = [calendar dateFromComponents:dateComponents];
                UILocalNotification *notifica = [[UILocalNotification alloc]init];
                if (notifica == nil){
                    return;
                }
                //imposto i parametri della notifica con i dati presi dall'oggetto parse
                notifica.fireDate = itemDate;
                notifica.timeZone = [NSTimeZone defaultTimeZone];
                
                NSString *messaggio = [[objects objectAtIndex:i] objectForKey:NSLocalizedString(@"messaggio", @"messaggio chiave parse")];
                
                notifica.alertBody = messaggio;
                notifica.alertAction = NSLocalizedString(@"Apri", @"Apri Local NOtification");
                notifica.soundName = UILocalNotificationDefaultSoundName;
                notifica.applicationIconBadgeNumber =1;
                notifica.repeatInterval = NSYearCalendarUnit;
                [[UIApplication sharedApplication] scheduleLocalNotification:notifica];
            }
            NSLog(@"Successfully retrieved %d local notification.", objects.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
