//
//  SolyarisConstants.h
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//


// Types
#define typeMovie                       @"movie"
#define typePerson                      @"person"	
#define typePersonActor                 @"person_actor"	
#define typePersonDirector              @"person_director"	
#define typePersonCrew                  @"person_crew"	
#define typeAll                         @"all"
#define typeSearch                      @"search"


// Assets
#define assetProfile                    @"profile"
#define assetPoster                     @"poster"
#define assetBackdrop                   @"backdrop"
#define assetSizeOriginal               @"original"
#define assetSizeMid                    @"mid"
#define assetSizeThumb                  @"thumb"



// User Default Keys
#define udInformationAppVersion			@"information_app_version"	
#define udGraphLayout                   @"graph_layout"
#define udGraphLayoutNone               @"graph_layout_none"
#define udGraphLayoutForce              @"graph_layout_force"
#define udGraphTooltipDisabled          @"graph_tooltip_disabled"	
#define udGraphNodeCrewEnabled          @"graph_node_crew_enabled"	
#define udGraphNodeChildren             @"graph_node_children"	
#define udGraphEdgeLength               @"graph_edge_length"	
#define udSearchTerm                    @"search_term"	


// URLs
#define urlIMDbMovie                    @"http://www.imdb.com/title/"
#define urlIMDbSearch                   @"http://www.imdb.com/find?q="
#define urlWikipediaSearch              @"http://en.wikipedia.org/w/index.php?search="
#define urlTMDbMovie                    @"http://www.themoviedb.org/movie/"
#define urlTMDbPerson                   @"http://www.themoviedb.org/person/"
#define urlAmazonSearch                 @"http://www.amazon.com/s/field-keywords="
#define urlITunesSearch                 @"http://www.amazon.com/s/field-keywords="


// Values
#define vAppEmail                       @"solyaris@cecinestpasparis.net"	


// System Version
#define iOS4    ([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending)
