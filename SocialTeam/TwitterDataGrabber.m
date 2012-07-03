//
//  TwitterDataGrabber.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterDataGrabber.h"


@implementation TwitterDataGrabber


-(void)getTwitterData{
    //devi prendere lo screen_name e metterlo come parametro in questa richiesta di dati, il resto e' ok
    NSURL *twitt = [NSURL URLWithString:@"https://api.twitter.com/1/users/show.json?screen_name=lucagianneschi"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:twitt];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&response 
                                                     error:&error];
    //NSString *dataTodisplay = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   NSDictionary *dati = [NSJSONSerialization JSONObjectWithData:data 
                                                   options:NSJSONReadingMutableLeaves 
                                                     error:&error];
    
    //imposto i dati dall'utente FB all'utente PARSE
    //faccio un check che nessuno dei dati sia null, se e' nullo non imposto alcun dato su parse, verra' lasciato vuoto e l'utente potra' inserirlo dalla finestra di dialogo
    
    PFUser *user = [PFUser currentUser];
    
    if ([dati objectForKey:@"name"]) [user setObject:[dati objectForKey:@"name"]
                                              forKey:@"nome"];
    
    if ([dati objectForKey:@"url"]) [user setObject:[dati objectForKey:@"url"]
                                            forKey:@"webSite"];
    
    if ([dati objectForKey:@"location"]) [user setObject:[dati objectForKey:@"location"] 
                                                  forKey:@"citta"];
    
    if([dati objectForKey:@"screen_name"])[user setObject:[dati objectForKey:@"name"]
                                                   forKey:@"username"];
    if ([dati objectForKey:@"profile_image_url"]) {
        NSString *path = [dati objectForKey:@"profile_image_url"];
        NSURL *avatarURL = [NSURL URLWithString:path];
        NSData *imageData = [NSData dataWithContentsOfURL:avatarURL];
        UIImage *avatar = [[UIImage alloc] initWithData:imageData];
        
        NSData *image = UIImagePNGRepresentation(avatar);
        NSString *fileName = [[NSString alloc] initWithFormat:@"avatar.png"];
        PFFile *imageFile = [PFFile fileWithName:fileName 
                                            data:image];
        [imageFile save];
        
        [user setObject:imageFile 
                 forKey:@"avatar"];
        [user saveInBackground];
        
        
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error userInfo]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

}


@end
