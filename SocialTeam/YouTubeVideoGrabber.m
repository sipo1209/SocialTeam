//
//  YouTubeVideoGrabber.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeVideoGrabber.h"
#import "Video.h"

@implementation YouTubeVideoGrabber
@synthesize datiVideo,arrayVideo;

#pragma mark - #pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //inserisco un AlertView
    /*
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Errore di caricamento Video", @"Errore di caricamento Video Alert")
                                                 message:@"Spiacente, si e' verificato un errore nel caricamento dei dati del video"
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];    
    [alert show];
     */
    NSLog(@"errore caricamento video");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.datiVideo setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.datiVideo appendData:data];
}


//devo passare a questo metodo diretta
+(NSMutableArray *)listaVideo:(NSString *)video{
    NSLog(@"CARICAMENTO VIDEO DA YOUTUBE");
    //lista per contenere i video del canale di youtube
    NSMutableArray *lista = [[NSMutableArray alloc] init];
    
    //array per contenere la lista degli oggetti video
    NSURL *urlDati = [[NSURL alloc] initWithString:video];
        
    //stringa dalla quale tirare fuori il JSON 
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlDati];
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&response 
                                                     error:&error];
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data 
                                                         options:kNilOptions 
                                                           error:&error];
    
    if(!jsonArray){
        NSLog(@"Error Parsing JSON: %@",error);
    }else {
        NSString *apiVersion = [jsonArray objectForKey:@"apiVersion"];
        NSArray *videos = [[jsonArray objectForKey:@"data"] objectForKey:@"items"];
        NSLog(@"apiversion %@",apiVersion);
        NSLog(@"items: %d",[videos count]);
        for (int i = 0; i < [videos count]; i = i + 1) {
            NSString *title = [[videos objectAtIndex:i] objectForKey:@"title"];
            NSString *description = [[videos objectAtIndex:i] objectForKey:@"description"];
            NSString *thumbURL = [[[videos objectAtIndex:i] objectForKey:@"thumbnail"] objectForKey:@"sqDefault"];
            NSString *urlVideo = [[[videos objectAtIndex:i] objectForKey:@"player"] objectForKey:@"default"];
            NSArray *tags = [[videos objectAtIndex:i] objectForKey:@"tags"];
            NSNumber *duration = [[videos objectAtIndex:i] objectForKey:@"duration"];
            NSString *uploaded = [[videos objectAtIndex:i] objectForKey:@"uploaded"];
            
            [lista addObject:[Video videoWithTitle:title 
                                       description:description 
                                              tags:tags 
                                          thumbURL:thumbURL 
                                          urlVideo:urlVideo
                                          duration:duration
                                          uploaded:uploaded]];
        }
    }
    return lista;
}

@end
