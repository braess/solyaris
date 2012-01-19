//
//  SolyarisLocalization.h
//  Solyaris
//
//  Created by Beat Raess on 15.12.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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

#import <Foundation/Foundation.h>


// Defaults
#define kLocalizedDefaultIMDb        @"imdb_com"
#define kLocalizedDefaultWikipedia   @"wikipedia_en"
#define kLocalizedDefaultAmazon      @"amazon_us"

// Supported Languages
#define kLanguageDE                  @"de"

/**
 * Localization Support.
 */
@interface SolyarisLocalization : NSObject {
    
    // data
    NSMutableDictionary *_imdb;
    NSMutableDictionary *_wikipedia;
    NSMutableDictionary *_amazon;
}

// Class
+ (NSString*)currentLanguage;

// Translations
+ (NSString*)translateTMDbJob:(NSString*)job;

// Methods
- (NSString*)urlIMDbMovie;
- (NSString*)urlIMDbSearch;
- (NSString*)urlWikipediaSearch;
- (NSString*)urlAmazonSearch;

// Methods
- (NSArray*)propertiesIMDb;
- (NSArray*)propertiesWikipedia;
- (NSArray*)propertiesAmazon;

@end


/**
 * LocalizationProperty.
 */
@interface LocalizationProperty : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *label;


// Initializer
- (id)initWithKey:(NSString*)k value:(NSString*)v label:(NSString*)l;

@end