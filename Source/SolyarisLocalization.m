//
//  Localization.m
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

#import "SolyarisLocalization.h"
#import "SolyarisConstants.h"

/**
 * Localization Support.
 */
@implementation SolyarisLocalization


#pragma mark -
#pragma mark Constants

// Constants
#define kLocalizedAmazonSearch       @"/s/field-keywords="
#define kLocalizedWikipediaSearch    @"/w/index.php?search="


#pragma mark -
#pragma mark Class Methods

/**
 * Returns the current language.
 */
+ (NSString*)currentLanguage {
    FLog();
    
    // defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    
    // return current
    return [languages objectAtIndex:0];
}

/**
 * Translates the TMDb job.
 */
+ (NSString*)translateTMDbJob:(NSString*)job {
    
    
    // translated core
    NSString *translated = [job stringByReplacingOccurrencesOfString:@"Director of Photography" withString:NSLocalizedString(@"tmdb_term_director-of-photography", @"Director of Photography")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Director" withString:NSLocalizedString(@"tmdb_term_director", @"Director")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Executive Producer" withString:NSLocalizedString(@"tmdb_term_executive-producer", @"Executive Producer")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Producer" withString:NSLocalizedString(@"tmdb_term_producer", @"Producer")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Editor" withString:NSLocalizedString(@"tmdb_term_editor", @"Editor")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Casting" withString:NSLocalizedString(@"tmdb_term_casting", @"Casting")];
    
    // translated writer
    translated = [translated stringByReplacingOccurrencesOfString:@"Novel" withString:NSLocalizedString(@"tmdb_term_novel", @"Novel")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Screenplay" withString:NSLocalizedString(@"tmdb_term_screenplay", @"Screenplay")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Author" withString:NSLocalizedString(@"tmdb_term_author", @"Author")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Writer" withString:NSLocalizedString(@"tmdb_term_writer", @"Writer")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Original Story" withString:NSLocalizedString(@"tmdb_term_original-story", @"Original Story")];
    
    // translated production
    translated = [translated stringByReplacingOccurrencesOfString:@"Characters" withString:NSLocalizedString(@"tmdb_term_characters", @"Characters")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Production Design" withString:NSLocalizedString(@"tmdb_term_production-design", @"Production Design")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Costume Design" withString:NSLocalizedString(@"tmdb_term_costume-design", @"Costume Design")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Stunts" withString:NSLocalizedString(@"tmdb_term_stunts", @"Stunts")];
    
    // translated music
    translated = [translated stringByReplacingOccurrencesOfString:@"Sound Designer" withString:NSLocalizedString(@"tmdb_term_sound-designer", @"Sound Designer")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Original Music Composer" withString:NSLocalizedString(@"tmdb_term_original-music-composer", @"Original Music Composer")];
    translated = [translated stringByReplacingOccurrencesOfString:@"Music" withString:NSLocalizedString(@"tmdb_term_music", @"Music")];
    
    // back
    return translated;
}



#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)init {
    GLog();
    
    // supa
    if ((self = [super init])) {
        
        
        // wikipedia 
        _wikipedia = [[NSMutableDictionary alloc] init];     
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ar" value:@"http://ar.wikipedia.org" label:@"ar.wikipedia.org"] autorelease] forKey:@"wikipedia_ar"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_bg" value:@"http://bg.wikipedia.org" label:@"bg.wikipedia.org"] autorelease] forKey:@"wikipedia_bg"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ca" value:@"http://ca.wikipedia.org" label:@"ca.wikipedia.org"] autorelease] forKey:@"wikipedia_ca"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_cs" value:@"http://cs.wikipedia.org" label:@"cs.wikipedia.org"] autorelease] forKey:@"wikipedia_cs"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_da" value:@"http://da.wikipedia.org" label:@"da.wikipedia.org"] autorelease] forKey:@"wikipedia_da"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_de" value:@"http://de.wikipedia.org" label:@"de.wikipedia.org"] autorelease] forKey:@"wikipedia_de"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_en" value:@"http://en.wikipedia.org" label:@"en.wikipedia.org"] autorelease] forKey:@"wikipedia_en"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_es" value:@"http://es.wikipedia.org" label:@"es.wikipedia.org"] autorelease] forKey:@"wikipedia_es"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_eo" value:@"http://eo.wikipedia.org" label:@"eo.wikipedia.org"] autorelease] forKey:@"wikipedia_eo"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_eu" value:@"http://eu.wikipedia.org" label:@"eu.wikipedia.org"] autorelease] forKey:@"wikipedia_eu"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_fa" value:@"http://fa.wikipedia.org" label:@"fa.wikipedia.org"] autorelease] forKey:@"wikipedia_fa"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_fr" value:@"http://fr.wikipedia.org" label:@"fr.wikipedia.org"] autorelease] forKey:@"wikipedia_fr"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ko" value:@"http://ko.wikipedia.org" label:@"ko.wikipedia.org"] autorelease] forKey:@"wikipedia_ko"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_hi" value:@"http://hi.wikipedia.org" label:@"hi.wikipedia.org"] autorelease] forKey:@"wikipedia_hi"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_hr" value:@"http://hr.wikipedia.org" label:@"hr.wikipedia.org"] autorelease] forKey:@"wikipedia_hr"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_id" value:@"http://id.wikipedia.org" label:@"id.wikipedia.org"] autorelease] forKey:@"wikipedia_id"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_it" value:@"http://it.wikipedia.org" label:@"it.wikipedia.org"] autorelease] forKey:@"wikipedia_it"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_he" value:@"http://he.wikipedia.org" label:@"he.wikipedia.org"] autorelease] forKey:@"wikipedia_he"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_lt" value:@"http://lt.wikipedia.org" label:@"lt.wikipedia.org"] autorelease] forKey:@"wikipedia_lt"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_hu" value:@"http://hu.wikipedia.org" label:@"hu.wikipedia.org"] autorelease] forKey:@"wikipedia_hu"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ms" value:@"http://ms.wikipedia.org" label:@"ms.wikipedia.org"] autorelease] forKey:@"wikipedia_ms"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_nl" value:@"http://nl.wikipedia.org" label:@"nl.wikipedia.org"] autorelease] forKey:@"wikipedia_nl"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ja" value:@"http://ja.wikipedia.org" label:@"ja.wikipedia.org"] autorelease] forKey:@"wikipedia_ja"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_no" value:@"http://no.wikipedia.org" label:@"no.wikipedia.org"] autorelease] forKey:@"wikipedia_no"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_pl" value:@"http://pl.wikipedia.org" label:@"pl.wikipedia.org"] autorelease] forKey:@"wikipedia_pl"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_pt" value:@"http://pt.wikipedia.org" label:@"pt.wikipedia.org"] autorelease] forKey:@"wikipedia_pt"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_kk" value:@"http://kk.wikipedia.org" label:@"kk.wikipedia.org"] autorelease] forKey:@"wikipedia_kk"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ro" value:@"http://ro.wikipedia.org" label:@"ro.wikipedia.org"] autorelease] forKey:@"wikipedia_ro"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_ru" value:@"http://ru.wikipedia.org" label:@"ru.wikipedia.org"] autorelease] forKey:@"wikipedia_ru"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_sk" value:@"http://sk.wikipedia.org" label:@"sk.wikipedia.org"] autorelease] forKey:@"wikipedia_sk"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_sl" value:@"http://sl.wikipedia.org" label:@"sl.wikipedia.org"] autorelease] forKey:@"wikipedia_sl"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_sr" value:@"http://sr.wikipedia.org" label:@"sr.wikipedia.org"] autorelease] forKey:@"wikipedia_sr"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_fi" value:@"http://fi.wikipedia.org" label:@"fi.wikipedia.org"] autorelease] forKey:@"wikipedia_fi"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_sv" value:@"http://sv.wikipedia.org" label:@"sv.wikipedia.org"] autorelease] forKey:@"wikipedia_sv"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_tr" value:@"http://tr.wikipedia.org" label:@"tr.wikipedia.org"] autorelease] forKey:@"wikipedia_tr"];   
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_uk" value:@"http://uk.wikipedia.org" label:@"uk.wikipedia.org"] autorelease] forKey:@"wikipedia_uk"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_vi" value:@"http://vi.wikipedia.org" label:@"vi.wikipedia.org"] autorelease] forKey:@"wikipedia_vi"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_vo" value:@"http://vo.wikipedia.org" label:@"vo.wikipedia.org"] autorelease] forKey:@"wikipedia_vo"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_war" value:@"http://war.wikipedia.org" label:@"war.wikipedia.org"] autorelease] forKey:@"wikipedia_war"]; 
        [_wikipedia setObject:[[[LocalizationProperty alloc] initWithKey:@"wikipedia_zh" value:@"http://zh.wikipedia.org" label:@"zh.wikipedia.org"] autorelease] forKey:@"wikipedia_zh"]; 
    
        
        // amazon 
        _amazon = [[NSMutableDictionary alloc] init];
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_ca" value:@"http://www.amazon.ca" label:@"www.amazon.ca"] autorelease] forKey:@"amazon_ca"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_cn" value:@"http://www.amazon.cn" label:@"www.amazon.cn"] autorelease] forKey:@"amazon_cn"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_fr" value:@"http://www.amazon.fr" label:@"www.amazon.fr"] autorelease] forKey:@"amazon_fr"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_de" value:@"http://www.amazon.de" label:@"www.amazon.de"] autorelease] forKey:@"amazon_de"];
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_it" value:@"http://www.amazon.it" label:@"www.amazon.it"] autorelease] forKey:@"amazon_it"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_jp" value:@"http://www.amazon.co.jp" label:@"www.amazon.co.jp"] autorelease] forKey:@"amazon_jp"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_es" value:@"http://www.amazon.es" label:@"www.amazon.es"] autorelease] forKey:@"amazon_es"]; 
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_uk" value:@"http://www.amazon.co.uk" label:@"www.amazon.co.uk"] autorelease] forKey:@"amazon_uk"];   
        [_amazon setObject:[[[LocalizationProperty alloc] initWithKey:@"amazon_us" value:@"http://www.amazon.com" label:@"www.amazon.com"] autorelease] forKey:@"amazon_us"]; 
        
        
        // back
		return self;
	}
	return nil;
}




#pragma mark -
#pragma mark Methods


/**
 * Returns the localized wikipedia search url.
 */
- (NSString*)urlWikipediaSearch {
    
    
    // amazon store
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *keyWikipedia = [userDefaults objectForKey:udLocalizationWikipedia];
    keyWikipedia = keyWikipedia ? keyWikipedia : kLocalizedDefaultWikipedia;
    
    // return localized property
    LocalizationProperty *property = [_wikipedia objectForKey:keyWikipedia];
    return [NSString stringWithFormat:@"%@%@",property.value,kLocalizedWikipediaSearch];
    
}

/**
 * Returns the localized amazon search url.
 */
- (NSString*)urlAmazonSearch {
    
    // amazon store
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *keyAmazon = [userDefaults objectForKey:udLocalizationAmazon];
    keyAmazon = keyAmazon ? keyAmazon : kLocalizedDefaultAmazon;
    
    // return localized property
    LocalizationProperty *property = [_amazon objectForKey:keyAmazon];
    return [NSString stringWithFormat:@"%@%@",property.value,kLocalizedAmazonSearch];
}


/**
 * Returns the properties.
 */
- (NSArray*)propertiesWikipedia {
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease];
    return [[_wikipedia allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}
- (NSArray*)propertiesAmazon {
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease];
    return [[_amazon allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
    [_wikipedia release];
    [_amazon release];
	
	// super
    [super dealloc];
}

@end




/**
 * LocalizationProperty.
 */
@implementation LocalizationProperty

#pragma mark -
#pragma mark Properties

// accessors
@synthesize key;
@synthesize value;
@synthesize label;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initWithKey:(NSString*)k value:(NSString*)v label:(NSString*)l {
	GLog();
	if ((self = [super init])) {
		self.key = k;
		self.value = v;
		self.label = l;
		return self;
	}
	return nil;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[key release];
	[value release];
	[label release];
	
	// super
    [super dealloc];
}

@end
