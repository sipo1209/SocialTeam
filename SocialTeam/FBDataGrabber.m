//
//  FBDataGrabber.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBDataGrabber.h"
#import <objc/runtime.h>


@implementation FBDataGrabber 

-(void)FBDataGrab{
    NSLog(@"FBGRAB");
    NSString *requestPath = @"me/?fields=id,name,location,gender,birthday,picture,email,website,hometown,first_name,last_name,statuses";
    [[PFFacebookUtils facebook] requestWithGraphPath:requestPath 
                                         andDelegate:self];
}
-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@",[error userInfo]);
}

-(void)request:(PF_FBRequest *)request didLoad:(id)result{
     NSLog(@"FBGRAB request");
    //prendo i dati da FB
    NSDictionary *userData = (NSDictionary *) result;
    
    NSString *FBid = [userData objectForKey:@"id"];
    NSString *name = [userData objectForKey:@"name"];
    NSString *location = [[userData objectForKey:@"location"] objectForKey:@"name"];
    NSString *gender = [userData objectForKey:@"gender"];
    NSString *birthDay = [userData objectForKey:@"birthday"];
    NSString *email = [userData objectForKey:@"email"];
    NSString *webSite = [userData objectForKey:@"website"];
    NSString *homeTown = [userData objectForKey:@"hometown"];
    NSString *nome = [userData objectForKey:@"first_name"];
    NSString *cognome = [userData objectForKey:@"last_name"];
    
    //prendo lo status utente: prendo tutti gli stati, seleziono il primo, poi prendo il campo "message"
    NSDictionary *dict = [userData objectForKey:@"statuses"];
    NSArray *array = [dict objectForKey:@"data"];
    NSDictionary *datiMessaggio = [array objectAtIndex:0];
    
    NSString *messaggioDiStato= [datiMessaggio objectForKey:@"message"];
     
    
    
    
        
    //check, questi log poi vanno tolti
    NSLog(@"ID %@",FBid);
    NSLog(@"USERNAME %@",name);
    NSLog(@"GENERE %@",gender);
    NSLog(@"DATA DI NASCITA %@",birthDay);
    NSLog(@"POSIZIONE %@",location);
    NSLog(@"EMAIL %@",email);
    NSLog(@"SITO INTERNET%@",webSite);
    NSLog(@"CITTA' NATALE %@",homeTown);
    NSLog(@"NOME %@",nome);
    NSLog(@"COGNOME %@",cognome);
    NSLog(@"STATO %@",messaggioDiStato);
    
   
    
        
    //imposto i dati dall'utente FB all'utente PARSE
    //faccio un check che nessuno dei dati sia null, se e' nullo non imposto alcun dato su parse, verra' lasciato vuoto e l'utente potra' inserirlo dalla finestra di dialogo
    
    PFUser *user = [PFUser currentUser];
    if (name) [user setObject:name
                       forKey:@"username"];
    if (gender) [user setObject:gender
                 forKey:@"genere"];
    if (email) [user setObject:email
                 forKey:@"email"];
    if (webSite) [user setObject:webSite
                 forKey:@"webSite"];
    if (homeTown) [user setObject:homeTown 
                 forKey:@"citta"];
    if(nome) [user setObject:nome 
                 forKey:@"nome"];
    if (cognome) [user setObject:cognome 
                 forKey:@"cognome"];
    if (messaggioDiStato) [user setObject:messaggioDiStato 
                                   forKey:@"status"];
    
    //impostazione dell'avatar
    imageData = [[NSMutableData alloc] init];
    NSString *pictureURL = [userData objectForKey:@"picture"];
    if (pictureURL) {
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pictureURL] 
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                              timeoutInterval:2];
        urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest 
                                                        delegate:self];
        
    }
   [user save];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    PFUser *user = [PFUser currentUser];
    NSData *image = UIImagePNGRepresentation([UIImage imageWithData:imageData]);
    NSString *fileName = [[NSString alloc] initWithFormat:@"avatar.png"];
    PFFile *imageFile = [PFFile fileWithName:fileName 
                                        data:image];
    [imageFile save];
    
    [user setObject:imageFile 
                    forKey:@"avatar"];
    [user saveInBackground];

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error userInfo]);
}


@end
