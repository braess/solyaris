//
//  SolyarisConstants.h
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
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


// Types
#define typeMovie                       @"movie"
#define typePerson                      @"person"	
#define typePersonActor                 @"person_actor"	
#define typePersonDirector              @"person_director"	
#define typePersonCrew                  @"person_crew"	
#define typeSearch                      @"search"

// Connections
#define connRelated                     @"related"

// Categories
#define catEntertainment                @"entertainment"
#define catViolence                     @"violence"
#define catCreativity                   @"creativity"
#define catPassion                      @"passion"
#define catHappiness                    @"happiness"
#define catNatural                      @"natural"


// Assets
#define assetProfile                    @"profile"
#define assetPoster                     @"poster"
#define assetBackdrop                   @"backdrop"
#define assetTrailer                    @"trailer"
#define assetSizeOriginal               @"original"
#define assetSizeMed                    @"med"
#define assetSizeMid                    @"mid"
#define assetSizeThumb                  @"thumb"



// User Default Keys
#define udInformationAppVersion			@"information_app_version"
#define udGraphLayoutNodesDisabled      @"graph_layout_nodes_disabled"
#define udGraphLayoutSubnodesDisabled   @"graph_layout_subnodes_disabled"
#define udGraphCrewEnabled              @"graph_crew_enabled"	
#define udGraphNodeInitial              @"graph_node_initial"	
#define udGraphEdgeLength               @"graph_edge_length"	
#define udSearchTerm                    @"search_term"	
#define udSearchType                    @"search_type"
#define udSearchSection                 @"search_section"
#define udvSectionSearch                @"section_search"
#define udvSectionPopular               @"section_popular"
#define udvSectionNowPlaying            @"section_nowplaying"
#define udvSectionFavorites             @"section_favorites"
#define udvSectionHistory               @"section_history"

// Localization
#define udLocalizationIMDb              @"localization_imdb"
#define udLocalizationWikipedia         @"localization_wikipedia"
#define udLocalizationAmazon            @"localization_amazon"


// URLs
#define urlTMDbMovie                    @"http://www.themoviedb.org/movie/"
#define urlTMDbPerson                   @"http://www.themoviedb.org/person/"
#define urlTMDbMissing                  @"http://www.themoviedb.org/movie"
#define urlITunesSearch                 @"itms://ax.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?term="


// Values
#define vAppEmail                       @"solyaris@cecinestpasparis.net"	
#define vAppStoreLink                   @"itms-apps://itunes.apple.com/app/id481963410"
#define vAppStoreURL                    @"http://itunes.apple.com/app/solyaris-visual-movie-browser/id481963410?mt=8"

// Triggers
#define triggerAppInstall               @"trigger_app_install"
#define triggerAppUpdate                @"trigger_app_update"

// Notifications
#define ntSearchTerm                    @"notification_search_term"
#define ntvSearchTerm                   @"search_term"

// Flags
#define iPad                            (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define iPhone                          (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)

