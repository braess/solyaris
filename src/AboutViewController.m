//
//  AboutViewController.m
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "AboutViewController.h"
#import "IMDGConstants.h"


/*
 * Helper Stack.
 */
@interface AboutViewController (Helpers)
- (void)recommendEmail;
- (void)recommendTwitter;
- (void)recommendAppStore;
- (void)feedbackEmail;
@end


/**
 * Info Controller.
 */
@implementation AboutViewController


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
	
	
	// prepare table view
	self.tableView.scrollEnabled = NO;
	
	// remove background 
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
	
	// about 
	float height = 110;
    float width = 540;
	float inset = 40;
    float margin = 15;
	UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
	
	// description
	UILabel *lblAbout = [[UILabel alloc] initWithFrame:CGRectMake(inset, margin, width-2*inset, height-margin)];
	lblAbout.backgroundColor = [UIColor clearColor];
	lblAbout.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	lblAbout.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	lblAbout.shadowColor = [UIColor whiteColor];
	lblAbout.shadowOffset = CGSizeMake(1,1);
	lblAbout.opaque = YES;
	lblAbout.numberOfLines = 4;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		lblAbout.numberOfLines = 7;
	}
	[lblAbout setText:NSLocalizedString(@"An exploration into Organic Information Design to visualise movies, actors, directors and their relationships.\nSearch the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography.",@"An exploration into Organic Information Design to visualise movies, actors, directors and their relationships.\nSearch the entire Internet Movie Database collection for movies, actors or directors. Expand nodes to gather information about their relationship. Learn about the cast and filmography.")];
	[aboutView addSubview:lblAbout];
	[lblAbout release];
    
	// table header
	self.tableView.tableHeaderView = aboutView;
	
    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();

}




#pragma mark -
#pragma mark Cell Delegates

/*
 * CellButton.
 */
- (void)cellButtonTouched:(CellButton *)c {
	GLog();
	
	// reset
	switch ([c tag]) {
            
        // recommend
		case ActionAboutRecommend:{
            
			// action sheet
			UIActionSheet *recommendAction = [[UIActionSheet alloc]
                                              initWithTitle:NSLocalizedString(@"Recommend IMDG",@"Recommend IMDG")
                                              delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Email",@"Email"),NSLocalizedString(@"Twitter",@"Twitter"),NSLocalizedString(@"App Store",@"App Store"),nil];
            
			// show
			[recommendAction setTag:ActionAboutRecommend];
			[recommendAction showInView:self.navigationController.view];
			[recommendAction release];
            
            // & break
			break;
		}
            
        // feedback
		case ActionAboutFeedback:{

			// feedback
            [self feedbackEmail];
            
            // & break
			break;
		}
            
		default:
			break;
	}
    
    
}



#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // recommend
		case ActionAboutRecommend: {
			// email
			if (buttonIndex == 0) {
				[self recommendEmail];
			} 
			// email
			if (buttonIndex == 1) {
				[self recommendTwitter];
			} 
			// app store
			if (buttonIndex == 2) {
				[self recommendAppStore];
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
#pragma mark Helpers


/*
 * Recommend Email.
 */
- (void)recommendEmail {
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
 * Recommend Twitter.
 */
- (void)recommendTwitter {
	DLog();

	// ios5 twitter stuff
}

/*
 * Recommend App Store.
 */
- (void)recommendAppStore {
	DLog();
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"App Store" 
						  message:NSLocalizedString(@"Thank you for rating IMDG or writing a nice review.",@"Thank you for rating IMDG or writing a nice review.")
						  delegate:self 
						  cancelButtonTitle:NSLocalizedString(@"Maybe later",@"Maybe later")
						  otherButtonTitles:NSLocalizedString(@"Visit",@"Visit"),nil];
	[alert setTag:AlertAboutRecommendAppStore];
	[alert show];    
	[alert release];
    
}


/*
 * Feedback Email.
 */
- (void)feedbackEmail {
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
            
        // recommend App Store
		case AlertAboutRecommendAppStore: {
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
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	// count it
    return 3;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // section
    switch (section) {
		case SectionAboutRecommend: {
			return 1;
		}
		case SectionAboutApp: {
			return 2;
		}
		case SectionAboutFeedback: {
			return 1;
		}
    }
    
    return 0;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellAboutIdentifier = @"CellAbout";
    static NSString *CellAboutButtonIdentifier = @"CellAboutButton";
	
	// create cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellAboutIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellAboutIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
	
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
			
        // info
        case SectionAboutApp: {
			
			// preferences
            if ([indexPath row] == AboutPreferences) {
				
				// cell
				cell.textLabel.text = NSLocalizedString(@"Preferences",@"Preferences");
				
				// accessory
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			// have a break
			break; 
		}
            
        // recommend
		case SectionAboutRecommend: {
			
			// recommend
            if ([indexPath row] == AboutRecommend) {
				
				// create cell
				CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellAboutButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellAboutButtonIdentifier] autorelease];
				}				
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.tag = ActionAboutRecommend;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Recommend",@"Recommend") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;
                
			}
			
			// break it
			break; 
		}
            
        // feedback
		case SectionAboutFeedback: {
			
			// feedback
            if ([indexPath row] == AboutFeedback) {
				
				// create cell
				CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellAboutButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellAboutButtonIdentifier] autorelease];
				}				
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.tag = ActionAboutFeedback;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Feedback",@"Feedback") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;
                
			}
			
			// break it
			break; 
		}
	}
	
	
	// return
    return cell;
}


/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {	
			
        // app
        case SectionAboutApp: {
			
			// preferences
            if ([indexPath row] == AboutPreferences) {
				
                /*
				// controller
			    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] initWithStyle:UITableViewStyleGrouped];
				
				// navigate 
				[self.navigationController pushViewController:preferencesViewController animated:YES];
				[preferencesViewController release];
                 */
			}
			break;
			
		}
	}
	
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
