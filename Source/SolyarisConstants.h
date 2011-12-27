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


// Assets
#define assetProfile                    @"profile"
#define assetPoster                     @"poster"
#define assetBackdrop                   @"backdrop"
#define assetSizeOriginal               @"original"
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


// Localization
#define udLocalizationIMDb              @"localization_imdb"
#define udLocalizationWikipedia         @"localization_wikipedia"
#define udLocalizationAmazon            @"localization_amazon"


// URLs
#define urlTMDbMovie                    @"http://www.themoviedb.org/movie/"
#define urlTMDbPerson                   @"http://www.themoviedb.org/person/"
#define urlITunesSearch                 @"itms://ax.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?term="


// Values
#define vAppEmail                       @"solyaris@cecinestpasparis.net"	
#define vAppStoreLink                   @"itms-apps://itunes.apple.com/app/id481963410"

// Messages
#define msgAppInstall                   @"message_app_install"
#define msgAppUpdate                    @"message_app_update"


// System Version
#define iOS4    ([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending)
