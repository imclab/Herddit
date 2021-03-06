//
//  HRDRecordingViewController.m
//  Herddit
//
//  Created by Daniel Finlay on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HRDRecordingViewController.h"

@implementation HRDRecordingViewController
@synthesize recordButton;
@synthesize stopRecordingButton;
@synthesize playButton;
@synthesize postButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        recorder = [[HRDAudioRecorder alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRecordButton:nil];
    [self setPlayButton:nil];
    [self setPostButton:nil];
    [self setStopRecordingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recordButtonPressed:(id)sender {
    if (recording == NO){
    [recorder startRecording];
        recording = YES;
    }else{
        if (paused == YES){
            [recorder resumeRecording];
        }else{
        [recorder pauseRecording];
        paused = YES;
        }
    }
}
- (IBAction)playButtonPressed:(id)sender {
    if (playing == NO){
        [recorder startPlaying];
        playing = YES;
    }else{
        if (paused == NO){
        [recorder pausePlaying];
        paused = YES;
        }else{
            [recorder resumePlaying];
        }
    }
}

- (IBAction)postButtonPressed:(id)sender {
    
    NSURL *trackURL = recorder.url;
    
    SCShareViewController *shareViewController;
    shareViewController = [SCShareViewController shareViewControllerWithFileURL:trackURL completionHandler:^(NSDictionary *trackInfo, NSError *error){
                                                                  
            if (SC_CANCELED(error)) {
                NSLog(@"Canceled!");
            } else if (error) {
                NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
            } else {
                // If you want to do something with the uploaded
                // track this is the right place for that.
                NSLog(@"Uploaded track: %@", trackInfo);
                                                                      
               streamURL = [[NSString alloc] initWithString:
                            [trackInfo valueForKey:@"stream_url"]];
                downloadURL = [[NSString alloc] initWithString:
                               [trackInfo valueForKey:@"download_url"]];
                
                NSLog(@"Stream URL: %@, Download URL: %@", streamURL, downloadURL);
                                                                    
            }
            }];
    /**
    // If your app is a registered foursquare app, you can set the client id and secret.
    // The user will then see a place picker where a location can be selected.
    // If you don't set them, the user sees a plain plain text filed for the place.
    [shareViewController setFoursquareClientID:@"<foursquare client id>"
                                  clientSecret:@"<foursquare client secret>"];
     **/
    
    // We can preset the title ...
    [shareViewController setTitle:@"Herddit Post"];
    
    // ... and other options like the private flag.
    [shareViewController setPrivate:NO];
    
    // Now present the share view controller.
    [self presentModalViewController:shareViewController animated:YES];
    
}
- (IBAction)stopRecordingPressed:(id)sender {
    [recorder stopRecording];
}

-(void)replyTo:(NSString *)fullName{
    replyTo = fullName;
    NSLog(@"Recording view replying to: %@", fullName);
}
@end
