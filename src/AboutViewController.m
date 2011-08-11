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
int aboutHeaderHeight = 45;
int aboutFooterHeight = 45;


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
    CGRect aframe = CGRectMake(0, aboutHeaderHeight+5, vframe.size.width+20, vframe.size.height-aboutFooterHeight-aboutHeaderHeight);
    CGRect bframe = CGRectMake(0, vframe.size.height-aboutFooterHeight+5, vframe.size.width, 40);
    CGRect btnframe = CGRectMake(0, 0, 32, 32);
    float spacer = 15;
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
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
	lblClaim.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblClaim.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblClaim.shadowOffset = CGSizeMake(1,1);
	lblClaim.opaque = YES;
	lblClaim.numberOfLines = 1;
	[lblClaim setText:NSLocalizedString(@"The Internet Movie Database Graph.",@"The Internet Movie Database Graph.")];
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
    txtAbout.userInteractionEnabled = YES;
    txtAbout.editable = NO;
    //txtAbout.dataDetectorTypes = UIDataDetectorTypeLink;
	[txtAbout setText:NSLocalizedString(@"An exploration into organic information design to visualise movies, actors, directors and their relationships. \n\nSearch the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography. \n\nInformation courtesy of The Internet Movie Database (http://www.imdb.com). Used with permission.",@"An exploration into organic information design to visualise movies, actors, directors and their relationships. \n\nSearch the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography. \n\nInformation courtesy of The Internet Movie Database (http://www.imdb.com). Used with permission.")];
    [self.view addSubview:txtAbout];
	[txtAbout release];
    
    
    // buttons
    UIView *buttonView = [[UIView alloc] initWithFrame:bframe];
    buttonView.backgroundColor = [UIColor clearColor];
	buttonView.opaque = YES;
    
    // button feedback
	UIButton *btnFeedback = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnFeedback.frame = btnframe;
	[btnFeedback setImage:[UIImage imageNamed:@"btn_feedback.png"] forState:UIControlStateNormal];
	[btnFeedback addTarget:self action:@selector(actionFeedback:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:btnFeedback];

    
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
	CGContextMoveToPoint(context, 0, aboutHeaderHeight-1);
	CGContextAddLineToPoint(context, w, aboutHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, aboutHeaderHeight);
	CGContextAddLineToPoint(context, w, aboutHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-aboutFooterHeight);
	CGContextAddLineToPoint(context, w, h-aboutFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, h-aboutFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-aboutFooterHeight+1);
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