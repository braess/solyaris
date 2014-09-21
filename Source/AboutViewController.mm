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
#import "Device.h"
#import "Tracker.h"


/*
 * Recommend Stack.
 */
@interface AboutViewController (RecommendStack)
- (void)recommendEmail;
- (void)recommendTwitter;
- (void)recommendFacebook;
- (void)recommendWeibo;
- (void)recommendAppStore;
@end

/*
 * Feedback Stack.
 */
@interface AboutViewController (FeedbackStack)
- (void)feedbackSuggestions;
- (void)feedbackBug;
@end



/**
 * AboutViewController.
 */
@implementation AboutViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object

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
    CGRect tframe = iPad ? CGRectMake(0, 3, vframe.size.width, 24) : CGRectMake(44, 3, vframe.size.width-44, 24);
    CGRect cframe = iPad ? CGRectMake(0, 21, vframe.size.width, 24) : CGRectMake(44, 21, vframe.size.width-44, 24);
    CGRect aframe = CGRectMake(0, kAboutHeaderHeight+5, vframe.size.width+20, vframe.size.height-kAboutFooterHeight-kAboutHeaderHeight);
    CGRect abframe = CGRectMake(0, vframe.size.height-kAboutFooterHeight+(iPad?5:2), vframe.size.width, 45);
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica" size:18.0];
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
	lblClaim.font = [UIFont fontWithName:@"Helvetica" size:18.0];
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
    txtAbout.contentInset = iOS6 ? UIEdgeInsetsMake(0,-7,-20,-20) : UIEdgeInsetsMake(0, -5, -20, -20);
	txtAbout.backgroundColor = [UIColor clearColor];
	txtAbout.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	txtAbout.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
	txtAbout.opaque = YES;
    txtAbout.userInteractionEnabled = NO;
    txtAbout.editable = NO;
	[txtAbout setText:NSLocalizedString(@"Solyaris is an exploration into organic information design to visualise movies, actors, directors and their relationship. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, Rotten Tomatoes, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.",@"Solyaris is an exploration into organic information design to visualise movies, actors, directors and their relationship. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography. \n\nThis app uses the TMDb API but is not endorsed or certified by TMDb. All information provided by TMDb, IMDb, Rotten Tomatoes, YouTube and Wikipedia. Solyaris is not responsible for the content, nor the availability or performance of these services.\n\nMade with Cinder.")];
    [self.view addSubview:txtAbout];
	[txtAbout release];
    
    
    // actions
    ActionBar *actionBar = [[ActionBar alloc] initWithFrame:abframe];

    
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

    
    // action recommend
    ActionBarButtonItem *actionRecommend = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_recommend.png"]
                                                                              title:NSLocalizedString(@"Recommend", @"Recommend") 
                                                                             target:self 
                                                                             action:@selector(actionRecommend:)];
    

    
    // dark
    [actionFeedback dark:YES];
    [actionRecommend dark:YES];
    
    
    // actions
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:nspace];
    [actions addObject:actionFeedback];
    [actions addObject:actionRecommend];
    [actions addObject:nspace];
    
    // add & release actions
    [actionBar setItems:actions];
    [actionFeedback release];
    [actionRecommend release];
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
 * Action back.
 */
- (void)actionBack:(id)sender  {
    DLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(aboutBack)]) {
        [delegate aboutBack];
    }
}

/*
 * Action feedback.
 */
- (void)actionFeedback:(id)sender {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Feedback"];
    
    // action sheet
    UIActionSheet *recommendAction = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"Feedback",@"Feedback")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Send Feedback",@"Send Feedback"),NSLocalizedString(@"Report a Bug",@"Report a Bug"),nil];
    
    // show
    [recommendAction setTag:AboutActionFeedback];
    [recommendAction setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [recommendAction showInView:self.view];
    [recommendAction release];
}

/*
 * Action recommend.
 */
- (void)actionRecommend:(id)sender {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Recommend"];
    
    // services
    BOOL email = [MailComposeController canSendMail];
    BOOL twitter = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    BOOL facebook = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    BOOL weibo = [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
    
    // recommend
    UIActionSheet *recommendAction = [[UIActionSheet alloc] init];
    [recommendAction setDelegate:self];
    [recommendAction setTag:AboutActionRecommend];
    [recommendAction setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [recommendAction setTitle:NSLocalizedString(@"Recommend",@"Recommend")];
    
    // services
    if (email) {
        [recommendAction addButtonWithTitle:NSLocalizedString(@"Email",@"Email")];
    }
    if (twitter) {
        [recommendAction addButtonWithTitle:NSLocalizedString(@"Twitter",@"Twitter")];
    }
    if (facebook) {
        [recommendAction addButtonWithTitle:NSLocalizedString(@"Facebook",@"Facebook")];
    }
    if (weibo) {
        [recommendAction addButtonWithTitle:NSLocalizedString(@"Sina Weibo",@"Sina Weibo")];
    }
    [recommendAction addButtonWithTitle:NSLocalizedString(@"App Store",@"App Store")];
    [recommendAction addButtonWithTitle:NSLocalizedString(@"Cancel",@"Cancel")];
    [recommendAction setCancelButtonIndex:recommendAction.numberOfButtons-1];
    
    // show
    [recommendAction showInView:self.view];
    [recommendAction release];
}



#pragma mark -
#pragma mark Recommend

/*
 * Recommend Email.
 */
- (void)recommendEmail {
	FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Email"];
	
	// check mail support
	if ([MailComposeController canSendMail]) {
        
		// mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
        [composer setSubject:NSLocalizedString(@"Solyaris iPhone/iPad App", @"Solyaris iPhone/iPad App")];
        
		// message
		NSString *message = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\nSolyaris\nVisual Movie Browser",@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\nSolyaris\nVisual Movie Browser"),vAppStoreURL];
		[composer setMessageBody:message isHTML:NO];
        
        // image
		UIImage *img = [UIImage imageNamed:@"asset_promo.png"];
		NSData *data = UIImagePNGRepresentation(img);
		[composer addAttachmentData:data mimeType:@"image/png" fileName:@"Solyaris"];
        
		// show off
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
		[presenter presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];
        
	}
    
}

/*
 * Recommend Twitter.
 */
- (void)recommendTwitter {
	FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Twitter"];
	
	// check twitter support
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        // initial text
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"Solyaris - a visual movie browser to find and discover films and explore their connections. ",@"Solyaris - a visual movie browser to find and discover films and explore their connections. "),vAppStoreURL]];
        
        // image
        [composeViewController addImage:[UIImage imageNamed:@"asset_promo.png"]];
        
        
        // completion handler
        [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            // dismiss the composition view controller
            UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
            [presenter dismissViewControllerAnimated:YES completion:nil];
            
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
            
        }];
        
        // modal
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
        [presenter presentViewController:composeViewController animated:YES completion:nil];
    }
}

/*
 * Recommend Facebook.
 */
- (void)recommendFacebook {
	FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Facebook"];
	
	// check facebook support
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // initial text
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\nSolyaris\nVisual Movie Browser",@"Solyaris is a visual movie browser to find and discover films, actors or directors and explore their connections. \n\nSearch the entire Open Movie Database (TMDb) collection for movies or people. Expand nodes to gather information about their relationships. Learn about the cast and filmography.\n\n\nSolyaris\nVisual Movie Browser"),vAppStoreURL]];
        
        // image
        [composeViewController addImage:[UIImage imageNamed:@"asset_promo.png"]];
        
        // completion handler
        [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
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
        }];
        
        // modal
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
        [presenter presentViewController:composeViewController animated:YES completion:nil];
    }
}

/*
 * Recommend Weibo.
 */
- (void)recommendWeibo {
	FLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Weibo"];
	
	// check twitter support
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        // initial text
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"Solyaris - a visual movie browser to find and discover films and explore their connections. ",@"Solyaris - a visual movie browser to find and discover films and explore their connections. "),vAppStoreURL]];
        
        // image
        [composeViewController addImage:[UIImage imageNamed:@"asset_promo.png"]];
        
        
        // completion handler
        [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            // dismiss the composition view controller
            UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
            [presenter dismissViewControllerAnimated:YES completion:nil];
            
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
            
        }];
        
        // modal
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
        [presenter presentViewController:composeViewController animated:YES completion:nil];
    }
}

/*
 * Recommend App Store.
 */
- (void)recommendAppStore {
	DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"AppStore"];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"App Store",@"App Store")
						  message:NSLocalizedString(@"Thank you for rating Solyaris or writing a nice review.",@"Thank you for rating Solyaris or writing a nice review.")
						  delegate:self
						  cancelButtonTitle:NSLocalizedString(@"Maybe later",@"Maybe later")
						  otherButtonTitles:NSLocalizedString(@"Visit",@"Visit"),nil];
	[alert setTag:AboutAlertAppStore];
	[alert show];
	[alert release];
    
}



#pragma mark -
#pragma mark Feedback

/*
 * Feedback suggestions.
 */
- (void)feedbackSuggestions {
    DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Suggestions"];
    
	// check mail support
	if ([MailComposeController canSendMail]) {
        
		// mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[Solyaris] Feedback v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        
		// show off
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
		[presenter presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];
        
	}
}

/*
 * Feedback bug.
 */
- (void)feedbackBug {
    DLog();
    
    // track
    [Tracker trackEvent:TEventAbout action:@"Bug"];
    
	
	// check mail support
	if ([MailComposeController canSendMail]) {
        
		// mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[Solyaris] Bug v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        
        // message
        NSString *msg = [NSString stringWithFormat:@"%@\n\n\n\n---\nSystem\niOS: %@\nDevice: %@\nDisplay: %@",NSLocalizedString(@"Sorry that Solyaris is not working as expected - please describe the problem and steps involved to reproduce the bug.", @"Sorry that Solyaris is not working as expected - please describe the problem and steps involved to reproduce the bug."),[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] model], [Device retina] ? @"Retina" : @"Default"];
        [composer setMessageBody:msg isHTML:NO];
        
		// show
        UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
		[presenter presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];
        
	}
}



#pragma mark -
#pragma mark UIActionSheet

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // recommend
		case AboutActionRecommend: {
            FLog("AboutActionRecommend");
            
            // action
            if (buttonIndex != actionSheet.cancelButtonIndex) {
                
                // service
                NSString *service = [actionSheet buttonTitleAtIndex:buttonIndex];
                if ([service isEqualToString:@"Email"] || [service isEqualToString:@"E-Mail"] || [service isEqualToString:@"E-mail"]) {
                    [self recommendEmail];
                }
                else if ([service isEqualToString:@"Twitter"]) {
                    [self recommendTwitter];
                }
                else if ([service isEqualToString:@"Facebook"]) {
                    [self recommendFacebook];
                }
                else if ([service isEqualToString:@"Sina Weibo"]) {
                    [self recommendWeibo];
                }
                else if ([service isEqualToString:@"App Store"]) {
                    [self recommendAppStore];
                }
            }
			break;
		}
            
        // feedback
		case AboutActionFeedback: {
            FLog("AboutActionFeedback");
            
			// suggestions
			if (buttonIndex == 0) {
				[self feedbackSuggestions];
			}
			// bug
			if (buttonIndex == 1) {
				[self feedbackBug];
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
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // App Store
		case AboutAlertAppStore: {
            
			// visit
			if (buttonIndex != actionSheet.cancelButtonIndex) {
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
    UIViewController *presenter = (! iOS6) ? self : [UIApplication sharedApplication].keyWindow.rootViewController;
    [presenter dismissViewControllerAnimated:YES completion:nil];
    
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
#pragma mark Object

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
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.6 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kAboutHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kAboutHeaderHeight-1);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.6 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kAboutFooterHeight);
	CGContextAddLineToPoint(context, w, h-kAboutFooterHeight);
	CGContextStrokePath(context);
    
    
}




@end