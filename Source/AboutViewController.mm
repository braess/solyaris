//
//  AboutViewController.m
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

#import "AboutViewController.h"
#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"
#import "SolyarisLocalization.h"
#import "Tracker.h"


/**
 * AboutViewController.
 */
@implementation AboutViewController



#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 480)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
        
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
	
	
	// view
    self.view = [[AboutBackgroundView alloc] initWithFrame:vframe];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    // frames
    CGRect tframe = CGRectMake(0, 0, vframe.size.width, 18);
    CGRect cframe = CGRectMake(0, 18, vframe.size.width, 18);
    CGRect aframe = CGRectMake(0, kAboutHeaderHeight+5, vframe.size.width+20, vframe.size.height-kAboutFooterHeight-kAboutHeaderHeight);
    CGRect abframe = CGRectMake(0, vframe.size.height-kAboutFooterHeight+5, vframe.size.width, 45);
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblTitle.shadowOffset = CGSizeMake(1,1);
	lblTitle.opaque = YES;
	lblTitle.numberOfLines = 1;
	[lblTitle setText:NSLocalizedString(@"Solyaris",@"Solyaris")];
	[self.view addSubview:lblTitle];
	[lblTitle release];
    
    // claim
	UILabel *lblClaim = [[UILabel alloc] initWithFrame:cframe];
	lblClaim.backgroundColor = [UIColor clearColor];
	lblClaim.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblClaim.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblClaim.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblClaim.shadowOffset = CGSizeMake(1,1);
	lblClaim.opaque = YES;
	lblClaim.numberOfLines = 1;
	[lblClaim setText:NSLocalizedString(@"Visual Movie Browser",@"Visual Movie Browser")];
	[self.view addSubview:lblClaim];
	[lblClaim release];
    
	
	// description
	UITextView *txtAbout = [[UITextView alloc] initWithFrame:aframe];
    txtAbout.contentInset = UIEdgeInsetsMake(0,-7,-20,-20);
    txtAbout.textAlignment = UITextAlignmentLeft;
	txtAbout.backgroundColor = [UIColor clearColor];
	txtAbout.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	txtAbout.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
	txtAbout.opaque = YES;
    txtAbout.userInteractionEnabled = NO;
    txtAbout.editable = NO;
	[txtAbout setText:NSLocalizedString(@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or persons. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.",@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or persons. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.")];
    [self.view addSubview:txtAbout];
	[txtAbout release];
    
    
    // link buttons
    LinkButton *lbTMDb = [[LinkButton alloc] initWithFrame:CGRectMake(0, 267, 46, 20)];
    lbTMDb.delegate = self;
    lbTMDb.link = @"http://www.themoviedb.org";
    
    LinkButton *lbIMDb = [[LinkButton alloc] initWithFrame:CGRectMake(49, 267, 41, 20)];
    lbIMDb.delegate = self;
    lbIMDb.link = @"http://www.imdb.com";
    
    LinkButton *lbYouTube = [[LinkButton alloc] initWithFrame:CGRectMake(92, 267, 65, 20)];
    lbYouTube.delegate = self;
    lbYouTube.link = @"http://www.youtube.com";
    
    LinkButton *lbWikipedia = [[LinkButton alloc] initWithFrame:CGRectMake(186, 267, 72, 20)];
    lbWikipedia.delegate = self;
    lbWikipedia.link = @"http://www.wikipedia.org";
    
    LinkButton *lbCinder = [[LinkButton alloc] initWithFrame:CGRectMake(72, 343, 49, 20)];
    lbCinder.delegate = self;
    lbCinder.link = @"http://libcinder.org";
    
    // localization: de
    if ([[SolyarisLocalization currentLanguage] isEqualToString:kLanguageDE]) {
        lbTMDb.frame = CGRectMake(219, 227, 46, 20);
        lbIMDb.frame = CGRectMake(268, 227, 41, 20);
        lbYouTube.frame = CGRectMake(0, 247, 64, 20);
        lbWikipedia.frame = CGRectMake(93, 247, 72, 20);
        lbCinder.frame = CGRectMake(118, 343, 51, 20);
    }
    
    // add
    [self.view addSubview:lbTMDb];
    [lbTMDb release];
    
    [self.view addSubview:lbIMDb];
    [lbIMDb release];
    
    [self.view addSubview:lbYouTube];
    [lbYouTube release];
    
    [self.view addSubview:lbWikipedia];
    [lbWikipedia release];
    
    [self.view addSubview:lbCinder];
    [lbCinder release];
    
    
    // actions
    ActionBar *actionBar = [[ActionBar alloc] initWithFrame:abframe];
    
    
    // flex
	UIBarButtonItem *itemFlex = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                 target:nil 
                                 action:nil];
    
    // negative space (weird 12px offset...)
    UIBarButtonItem *nspace = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                 target:nil 
                                 action:nil];
    nspace.width = -12;
    
    
    // action feedback
    ActionBarButtonItem *actionFeedback = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_feedback.png"] 
                                                                              title:NSLocalizedString(@"Feedback", @"Feedback") 
                                                                              target:self 
                                                                              action:@selector(actionFeedback:)];
    [actionFeedback modeDarkie];

    
    // action email
    ActionBarButtonItem *actionEmail = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_email.png"] 
                                                                            title:NSLocalizedString(@"Email", @"Email") 
                                                                           target:self 
                                                                           action:@selector(actionEmail:)];
    [actionEmail modeDarkie];
    
    // action twitter
    ActionBarButtonItem *actionTwitter = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_twitter.png"] 
                                                                              title:NSLocalizedString(@"Twitter", @"Twitter") 
                                                                             target:self 
                                                                             action:@selector(actionTwitter:)];
    [actionTwitter modeDarkie];
    
    // action app store
    ActionBarButtonItem *actionAppStore = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_appstore.png"] 
                                                                               title:NSLocalizedString(@"AppStore", @"AppStore")
                                                                              target:self 
                                                                              action:@selector(actionAppStore:)];
    [actionAppStore modeDarkie];
    
    
    // actions
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:nspace];
    [actions addObject:actionFeedback];
    [actions addObject:itemFlex];
    [actions addObject:actionEmail];
    if(NSClassFromString(@"TWTweetComposeViewController") != nil) {
        [actions addObject:actionTwitter];
    }
    [actions addObject:actionAppStore];
    [actions addObject:nspace];

    
    // add & release actions
    [actionBar setItems:actions];
    [actionFeedback release];
    [actionEmail release];
    [actionTwitter release];
    [actionAppStore release];
    [itemFlex release];
    [nspace release];
    [actions release];
    
    // add action bar
    [self.view addSubview:actionBar];
    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();


}

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Actions


/*
 * Action Email.
 */
- (void)actionEmail:(id)sender {
	DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Email" label:[NSString stringWithFormat:@"%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];

	
	// check mail support
	if ([MFMailComposeViewController canSendMail]) {
        
        // mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"Solyaris iPad App"]];
        
		// message
        NSString *message = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or persons. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\n--- Solyaris\nVisual Movie Browser",@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or persons. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\n--- Solyaris\nVisual Movie Browser"),vAppStoreURL];
		[composer setMessageBody:message isHTML:NO];
		
		// promo image
		UIImage *pimg = [UIImage imageNamed:@"promo_solyaris.png"];
		NSData *data = UIImagePNGRepresentation(pimg);
		[composer addAttachmentData:data mimeType:@"image/png" fileName:@"solyaris"];
        
		// show off
		[self presentModalViewController:composer animated:YES];
        
		// release
		[composer release];
        
	}
	else {
		
		
	}
}

/*
 * Action Twitter.
 */
- (void)actionTwitter:(id)sender {
	DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Twitter" label:[NSString stringWithFormat:@"%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
    

    // check twitter support
    if(NSClassFromString(@"TWTweetComposeViewController") != nil) {
        
        // twitter composition view controller
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        // initial tweet text
        [tweetViewController setInitialText:NSLocalizedString(@"Solyaris iPad App. A Visual Movie Browser. http://solyaris.cecinestpasparis.net\n",@"Solyaris iPad App. A Visual Movie Browser. http://solyaris.cecinestpasparis.net\n")];
        
        // promo image
        UIImage *pimg = [UIImage imageNamed:@"promo_solyaris.png"];
        [tweetViewController addImage:pimg];
        
        // completion handler
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    FLog("Twitter: cancel");
                    break;
                case TWTweetComposeViewControllerResultDone:
                    FLog("Twitter: done");
                    break;
                default:
                    break;
            }
            
            // dismiss the tweet composition view controller
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        // modal
        [self presentModalViewController:tweetViewController animated:YES];
    }

}

/*
 * Action AppStore.
 */
- (void)actionAppStore:(id)sender {
	DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"AppStore" label:[NSString stringWithFormat:@"%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"AppStore",@"AppStore")
						  message:NSLocalizedString(@"Thank you for rating Solyaris or writing a nice review.",@"Thank you for rating Solyaris or writing a nice review.")
						  delegate:self 
						  cancelButtonTitle:NSLocalizedString(@"Maybe later",@"Maybe later")
						  otherButtonTitles:NSLocalizedString(@"Visit",@"Visit"),nil];
	[alert setTag:AlertAboutAppStore];
	[alert show];    
	[alert release];
    
}


/*
 * Action Feedback.
 */
- (void)actionFeedback:(id)sender {
	DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Feedback" label:[NSString stringWithFormat:@"%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {
        
	}
	else {
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[Solyaris] Feedback v%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
        
		// show off
        [self presentModalViewController:composer animated:YES];
        
		// release
		[composer release];

		
	}
}


#pragma mark -
#pragma mark LinkButton Delegate

/*
 * LinkButton.
 */
- (void)linkButtonTouched:(LinkButton *)lb {
	FLog();
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lb.link]];
}




#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // App Store
		case AlertAboutAppStore: {
            
			// cancel
			if (buttonIndex == 0) {
			}
			// visit app store
			else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:vAppStoreLink]];
			}
			break;
		}
            
        // default
		default: {
			break;
		}
	}
	
}






#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Protocol

/*
 * Dismisses the email composition interface when users tap Cancel or Send.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	FLog();
	
	// result
	switch (result) {
		case MFMailComposeResultCancelled:
			FLog("Email: canceled");
			break;
		case MFMailComposeResultSaved:
			FLog("Email: saved");
			break;
		case MFMailComposeResultSent:
			FLog("Email: sent");
			break;
		case MFMailComposeResultFailed:
			FLog("Email: failed");
			break;
		default:
			FLog("Email: not sent");
			break;
	}
	
	// close modal
    [self dismissModalViewControllerAnimated:YES];
    
}



#pragma mark -
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// duper
    [super dealloc];
}


@end



/**
 * AboutBackgroundView.
 */
@implementation AboutBackgroundView


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
    
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        
		// return
		return self;
	}
	
	// nop
	return nil;
}


/*
 * Draw that thing.
 */
- (void)drawRect:(CGRect)rect {
    
	// vars
	float w = self.frame.size.width;
	float h = self.frame.size.height;
    
    // rects
    CGRect mrect = CGRectMake(0, 0, w, h);
    
    
	// context
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
    CGContextSetShouldAntialias(context, NO);
	
	// background
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, mrect);
	
	// header lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kAboutHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kAboutHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, kAboutHeaderHeight);
	CGContextAddLineToPoint(context, w, kAboutHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kAboutFooterHeight);
	CGContextAddLineToPoint(context, w, h-kAboutFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, h-kAboutFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-kAboutFooterHeight+1);
	CGContextStrokePath(context);
    
    
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}

/*
 * Touches.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}



@end