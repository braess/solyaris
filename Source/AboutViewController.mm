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
#pragma mark Properties

// accessors
@synthesize delegate;


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
	
    // about
    AboutBackgroundView *about = [[AboutBackgroundView alloc] initWithFrame:vframe];
	about.opaque = YES;
    about.backgroundColor = [UIColor clearColor];
    about.autoresizingMask = UIViewAutoresizingNone;
    about.autoresizesSubviews = YES;
    
	// view
    self.view = about;
    [about release];
    
    
    // frames
    CGRect bframe = CGRectMake(0, 1, 44, 44);
    CGRect tframe = iPad ? CGRectMake(0, 5, vframe.size.width, 18) : CGRectMake(44, 5, vframe.size.width-44, 18);
    CGRect cframe = iPad ? CGRectMake(0, 23, vframe.size.width, 18) : CGRectMake(44, 23, vframe.size.width-44, 18);
    CGRect aframe = CGRectMake(0, kAboutHeaderHeight+5, vframe.size.width+20, vframe.size.height-kAboutFooterHeight-kAboutHeaderHeight);
    CGRect abframe = CGRectMake(0, vframe.size.height-kAboutFooterHeight+(iPad?5:2), vframe.size.width, 45);
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblTitle.shadowOffset = CGSizeMake(0,1);
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
	lblClaim.shadowOffset = CGSizeMake(0,1);
	lblClaim.opaque = YES;
	lblClaim.numberOfLines = 1;
	[lblClaim setText:NSLocalizedString(@"Visual Movie Browser",@"Visual Movie Browser")];
	[self.view addSubview:lblClaim];
	[lblClaim release];
    
    // button back
    if (!iPad) {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom]; 
        btnBack.frame = bframe;
        [btnBack setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnBack];
    }
    
	// description
	UITextView *txtAbout = [[UITextView alloc] initWithFrame:aframe];
    txtAbout.contentInset = UIEdgeInsetsMake(0,-7,-20,-20);
	txtAbout.backgroundColor = [UIColor clearColor];
	txtAbout.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	txtAbout.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
	txtAbout.opaque = YES;
    txtAbout.userInteractionEnabled = NO;
    txtAbout.editable = NO;
	[txtAbout setText:NSLocalizedString(@"Solyaris is an exploration into organic information design to visualise movies, actors, directors and their relationship. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, Rotten Tomatoes, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.",@"Solyaris is an exploration into organic information design to visualise movies, actors, directors and their relationship. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, Rotten Tomatoes, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.")];
    [self.view addSubview:txtAbout];
	[txtAbout release];
    
    // link buttons
    LinkButton *lbTMDb = [[LinkButton alloc] initWithFrame:CGRectZero];
    lbTMDb.delegate = self;
    lbTMDb.link = @"http://www.themoviedb.org";
    
    LinkButton *lbCinder = [[LinkButton alloc] initWithFrame:CGRectZero];
    lbCinder.delegate = self;
    lbCinder.link = @"http://libcinder.org";
    
    
    // ipad
    if (iPad) {
        
        // localization: de
        if ([[SolyarisLocalization currentLanguage] isEqualToString:kLanguageDE]) {
            lbTMDb.frame = CGRectMake(196, 272, 44, 20);
            lbCinder.frame = CGRectMake(118, 348, 51, 20);
        }
        // localization: en
        else {
            lbTMDb.frame = CGRectMake(0, 272, 44, 20);
            lbCinder.frame = CGRectMake(72, 368, 49, 20);
        }
    }
    else {
        
        // localization: de
        if ([[SolyarisLocalization currentLanguage] isEqualToString:kLanguageDE]) {
            lbTMDb.frame = CGRectMake(0, 292, 44, 20);
            lbCinder.frame = CGRectMake(118, 368, 51, 20);
        }
        // localization: en
        else {
            lbTMDb.frame = CGRectMake(122, 252, 44, 20);
            lbCinder.frame = CGRectMake(72, 386, 49, 20);
        }
    }
    
    // add
    [self.view addSubview:lbTMDb];
    [self.view addSubview:lbCinder];
    
    // release
    [lbTMDb release];
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
    nspace.width = -15;
    
    
    // action feedback
    ActionBarButtonItem *actionFeedback = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_feedback.png"] 
                                                                              title:NSLocalizedString(@"Feedback", @"Feedback") 
                                                                              target:self 
                                                                              action:@selector(actionFeedback:)];

    
    // action email
    ActionBarButtonItem *actionEmail = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_email.png"] 
                                                                            title:NSLocalizedString(@"Email", @"Email") 
                                                                           target:self 
                                                                           action:@selector(actionEmail:)];
    
    // action twitter
    ActionBarButtonItem *actionTwitter = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_twitter.png"] 
                                                                              title:NSLocalizedString(@"Twitter", @"Twitter") 
                                                                             target:self 
                                                                             action:@selector(actionTwitter:)];
    
    // action app store
    ActionBarButtonItem *actionAppStore = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_appstore.png"] 
                                                                               title:NSLocalizedString(@"AppStore", @"AppStore")
                                                                              target:self 
                                                                              action:@selector(actionAppStore:)];
    
    // dark
    [actionFeedback dark:YES];
    [actionEmail dark:YES];
    [actionTwitter dark:YES];
    [actionAppStore dark:YES];
    
    
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
    [actionBar release];
    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();

    // track
    [Tracker trackView:@"About"];
}


/*
 * Rotate.
 */
- (BOOL)shouldAutorotate {
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
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
	if ([MailComposeController canSendMail]) {
        
        // mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"Solyaris iPhone/iPad App"]];
        
		// message
        NSString *message = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\n--- Solyaris\nVisual Movie Browser",@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\n--- Solyaris\nVisual Movie Browser"),vAppStoreURL];
		[composer setMessageBody:message isHTML:NO];
		
		// promo image
		UIImage *pimg = [UIImage imageNamed:@"promo.png"];
		NSData *data = UIImagePNGRepresentation(pimg);
		[composer addAttachmentData:data mimeType:@"image/png" fileName:@"Solyaris"];
        
		// show off
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composer animated:YES completion:nil];
        
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
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        // initial tweet text
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"Solyaris - a visual movie browser to find and discover films and explore their connections. ",@"Solyaris - a visual movie browser to find and discover films and explore their connections. "),vAppStoreURL ]];
        
        // promo image
        UIImage *pimg = [UIImage imageNamed:@"promo.png"];
        [composeViewController addImage:pimg];
        
        
        // completion handler
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            // dismiss the composition view controller
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            // result
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    FLog("SLCompose: cancel");
                    break;
                case SLComposeViewControllerResultDone:
                    FLog("SLCompose: done");
                    break;
                default:
                    break;
            }
            
        };
        [composeViewController setCompletionHandler:completionHandler];
        
        // modal
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeViewController animated:YES completion:nil];
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
	if (! [MailComposeController canSendMail]) {
        
	}
	else {
		
		// mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[Solyaris] Feedback v%@",[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
        
		// show off
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];

		
	}
}


/*
 * Action back.
 */
- (void)actionBack:(id)sender  {
    DLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(aboutBack)]) {
        [delegate aboutBack];
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
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark -
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
	
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
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.54 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kAboutHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kAboutHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, kAboutHeaderHeight);
	CGContextAddLineToPoint(context, w, kAboutHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.54 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kAboutFooterHeight);
	CGContextAddLineToPoint(context, w, h-kAboutFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, h-kAboutFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-kAboutFooterHeight+1);
	CGContextStrokePath(context);
    
    
}




@end