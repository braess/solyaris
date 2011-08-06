//
//  AboutViewController.m
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "AboutViewController.h"
#import "IMDGConstants.h"



/**
 * AboutViewController.
 */
@implementation AboutViewController


#pragma mark -
#pragma mark Properties

// local vars
CGRect vframe;


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
    self.view = [[UIView alloc] initWithFrame:vframe];
    self.view.opaque = YES;
    
    // frames
    CGRect tframe = CGRectMake(0, 0, vframe.size.width, 18);
    CGRect cframe = CGRectMake(0, 18, vframe.size.width, 18);
    CGRect a1frame = CGRectMake(0, 39, vframe.size.width, 60);
    CGRect a2frame = CGRectMake(0, 90, vframe.size.width, 120);
    CGRect bframe = CGRectMake(0, 210, vframe.size.width, 40);
    CGRect btnframe = CGRectMake(0, 0, 32, 32);
    float spacer = 15;
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	lblTitle.textColor = [UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0];
	lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblTitle.shadowOffset = CGSizeMake(1,1);
	lblTitle.opaque = YES;
	lblTitle.numberOfLines = 1;
	[lblTitle setText:NSLocalizedString(@"IMDG",@"IMDG")];
	[self.view addSubview:lblTitle];
	[lblTitle release];
    
    // claim
	UILabel *lblClaim = [[UILabel alloc] initWithFrame:cframe];
	lblClaim.backgroundColor = [UIColor clearColor];
	lblClaim.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblClaim.textColor = [UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0];
	lblClaim.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblClaim.shadowOffset = CGSizeMake(1,1);
	lblClaim.opaque = YES;
	lblClaim.numberOfLines = 1;
	[lblClaim setText:NSLocalizedString(@"The Internet Movie Database Graph.",@"The Internet Movie Database Graph.")];
	[self.view addSubview:lblClaim];
	[lblClaim release];
    
	
	// description
	UILabel *lblAbout1 = [[UILabel alloc] initWithFrame:a1frame];
	lblAbout1.backgroundColor = [UIColor clearColor];
	lblAbout1.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	lblAbout1.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	lblAbout1.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblAbout1.shadowOffset = CGSizeMake(1,1);
	lblAbout1.opaque = YES;
	lblAbout1.numberOfLines = 3;
	[lblAbout1 setText:NSLocalizedString(@"An exploration into Organic Information Design to visualise movies, actors, directors and their relationships.",@"An exploration into Organic Information Design to visualise movies, actors, directors and their relationships.")];
	[self.view addSubview:lblAbout1];
	[lblAbout1 release];
    
    UILabel *lblAbout2 = [[UILabel alloc] initWithFrame:a2frame];
	lblAbout2.backgroundColor = [UIColor clearColor];
	lblAbout2.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	lblAbout2.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	lblAbout2.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblAbout2.shadowOffset = CGSizeMake(1,1);
	lblAbout2.opaque = YES;
	lblAbout2.numberOfLines = 5;
	[lblAbout2 setText:NSLocalizedString(@"Search the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography.",@"Search the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography.")];
	[self.view addSubview:lblAbout2];
	[lblAbout2 release];
    
    // buttons
    UIView *buttonView = [[UIView alloc] initWithFrame:bframe];
    buttonView.backgroundColor = [UIColor clearColor];
	buttonView.opaque = YES;
    
    // button feedback
    /*
	UIButton *btnFeedback = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnFeedback.frame = btnframe;
	[btnFeedback setImage:[UIImage imageNamed:@"btn_feedback.png"] forState:UIControlStateNormal];
	[btnFeedback addTarget:self action:@selector(actionFeedback:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:btnFeedback];
     */
    
    // button app store
	UIButton *btnAppStore = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnAppStore.frame = CGRectMake(bframe.origin.x+bframe.size.width-btnframe.size.width-5, 0, btnframe.size.width, btnframe.size.height);
	[btnAppStore setImage:[UIImage imageNamed:@"btn_appstore.png"] forState:UIControlStateNormal];
	[btnAppStore addTarget:self action:@selector(actionAppStore:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:btnAppStore];
    
    // button twitter
	UIButton *btnTwitter = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnTwitter.frame = CGRectMake(btnAppStore.frame.origin.x-btnframe.size.width-spacer, 0, btnframe.size.width, btnframe.size.height);
	[btnTwitter setImage:[UIImage imageNamed:@"btn_twitter.png"] forState:UIControlStateNormal];
	[btnTwitter addTarget:self action:@selector(actionTwitter:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:btnTwitter];
    
    
    // button email
	UIButton *btnEmail = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnEmail.frame = CGRectMake(btnTwitter.frame.origin.x-btnframe.size.width-spacer, 0, btnframe.size.width, btnframe.size.height);
	[btnEmail setImage:[UIImage imageNamed:@"btn_email.png"] forState:UIControlStateNormal];
	[btnEmail addTarget:self action:@selector(actionEmail:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:btnEmail];
    
    
    // add buttons
    [self.view addSubview:buttonView];
    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();


}





#pragma mark -
#pragma mark Actions


/*
 * Action Email.
 */
- (void)actionEmail:(id)sender {
	DLog();

	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {
     
	}
	else {
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"IMDG"]];
        
		// message
		NSString *message = NSLocalizedString(@"\n\n\n---IMDG\nThe Internet Movie Database Graph.\nhttp://imdg.cecinestpasparis.net",@"\n\n\n---IMDG\nThe Internet Movie Database Graph.\nhttp://imdg.cecinestpasparis.net");
		[composer setMessageBody:message isHTML:NO];
		
		// promo image
		UIImage *pimg = [UIImage imageNamed:@"iTunesArtwork"];
		NSData *data = UIImagePNGRepresentation(pimg);
		[composer addAttachmentData:data mimeType:@"image/png" fileName:@"imdg"];
        
        
		// show off
		[self presentModalViewController:composer animated:YES];
        
		// release
		[composer release];
		
	}
}

/*
 * Action Twitter.
 */
- (void)actionTwitter:(id)sender {
	DLog();

	// ios5 twitter stuff
}

/*
 * Action AppStore.
 */
- (void)actionAppStore:(id)sender {
	DLog();
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"App Store" 
						  message:NSLocalizedString(@"Thank you for rating IMDG or writing a nice review.",@"Thank you for rating IMDG or writing a nice review.")
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
	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {
        
	}
	else {
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[IMDG] Feedback"]];
        
		// show off
		[self presentModalViewController:composer animated:YES];
        
		// release
		[composer release];
		
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
		case AlertAboutAppStore: {
			// cancel
			if (buttonIndex == 0) {
			}
			// visit app store
			else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com"]];
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
