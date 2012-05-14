//
//  Solyaris.h
//  Solyaris
//
//  Created by CNPP on 4.6.2011.
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

#include "Solyaris.h"
#include "Utils.h"

#pragma mark -
#pragma mark Cinder

/*
 * Cinder Launch.
 */
void Solyaris::launch( const char *title, int argc, char * const argv[] ) {
    DLog();
    
    // custom app delegate
	::UIApplicationMain( argc, const_cast<char**>( argv ), nil, @"SolyarisAppDelegate" );
}

/*
 * Cinder Setup.
 */
void Solyaris::setup() {
    DLog();
    
    // redux
    redux = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? false : true;
    
    // display
    retina = false;
    dwidth = redux ? 320 : 768;
    dheight = redux ? 480 : 1024;
    
    // retina
    if ([Utils isRetina]) {
        retina = true;
        dwidth = redux ? 640 : 1536;
        dheight = redux ? 960 : 2048;
    }

    
    // sketch
    bg = Color(30.0/255.0, 30.0/255.0, 30.0/255.0);
    
    // graph
    graph = Graph(dwidth,dheight,UIDeviceOrientationPortrait);
    
    // vars
    pscale = 1.0;
    ppinch = CGPointMake(0,0);
    
    // app
    this->applyDeviceOrientation(UIDeviceOrientationPortrait);
    this->applySettings();
    
    // configuration
    Configuration conf = Configuration();
    conf.setConfiguration(cDeviceRedux,redux ? "1" : "0");
    conf.setConfiguration(cDisplayRetina,retina ? "1" : "0");
    graph.config(conf);
    
    
    // translations
    I18N tls = I18N();
    tls.setTranslation(i18nTooltipActor1, [NSLocalizedString(@"graph_tooltip_actor_1", @" is ") UTF8String]);
    tls.setTranslation(i18nTooltipActor2, [NSLocalizedString(@"graph_tooltip_actor_2", @" in ") UTF8String]);
    tls.setTranslation(i18nTooltipCrew1, [NSLocalizedString(@"graph_tooltip_crew_1", @" is the ") UTF8String]);
    tls.setTranslation(i18nTooltipCrew2, [NSLocalizedString(@"graph_tooltip_crew_2", @" of ") UTF8String]);
    graph.i18n(tls);
    
    // Solyaris
    solyarisViewController = [[SolyarisViewController alloc] init];
    solyarisViewController.solyaris = this;
    [solyarisViewController loadView];

}


/*
 * Cinder settings.
 */
void Solyaris::prepareSettings(Settings *settings) {
    FLog();
    
    // stage
    settings->setWindowSize(dwidth, dheight);
    
    // device
    settings->enableMultiTouch();
}


/**
 * Applies the orientation.
 */
void Solyaris::applyDeviceOrientation(int dorientation) {
    GLog();
    
    // orientation
    orientation = dorientation;
    
    // orientation
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        this->setWindowSize(dheight, dwidth);
        graph.resize(dheight,dwidth,orientation);
    }
    else {
        this->setWindowSize(dwidth, dheight);
        graph.resize(dwidth,dheight,orientation);
    }
    
}


/**
 * Applies the user defaults.
 */
void Solyaris::applySettings() {
    GLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// defaults
    Defaults defaults = Defaults();
    
    // user defaults
	NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    for (NSString *key in keys) {
        NSObject *def = [userDefaults objectForKey:key];
        
        // string
        if ([def isKindOfClass:[NSString class]]) {
            
            // match
            NSRange range = [key rangeOfString : @"graph_"];
            if (range.location != NSNotFound) {
                defaults.setDefault([key UTF8String], [(NSString*)def UTF8String]);
            }
        }
    }
    
    // apply
    graph.defaults(defaults);
}







#pragma mark -
#pragma mark Sketch

/*
 * Cinder update.
 */
void Solyaris::update() {
    
    // graph
    graph.update();
}

/*
 * Cinder draw.
 */
void Solyaris::draw() {
    
    // prepare
    gl::setMatricesWindow( getWindowSize() );
	gl::setViewport( getWindowBounds() );
    
    // clear
	gl::clear(bg);    
    
    // graph
    graph.draw();

}


/*
 * Cinder reset.
 */
void Solyaris::reset() {
    
    // app
    pscale = 1.0;
    
    // graph
    graph.reset();
    
}



#pragma mark -
#pragma mark Touch

/*
 * Cinder touch events.
 */
void Solyaris::touchesBegan( TouchEvent event ) {
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // taps
        int taps = [(UITouch*)touch->getNative() tapCount];
        
        // touch
        if (taps == 1) {
            
            // touch graph
            graph.touchBegan(touch->getPos(),touch->getId());
        }
        
        // double tap
        if (taps == 2) {
          
            // tap graph
            NodePtr node = graph.doubleTap(touch->getPos(),touch->getId());
            if (node != NULL) {
                
                // tap controller
                NSString *nid = [NSString stringWithCString:node->nid.c_str() encoding:[NSString defaultCStringEncoding]];
                
                // load
                if (! node->isActive() && ! node->isLoading()) {
                    
                    // data
                    [solyarisViewController nodeLoad:nid];
                }
                // open
                if (node->isClosed()) {
                    node->open();
                }
                // information
                else {
                    // data
                    [solyarisViewController nodeInformation:nid];
                }
            }
        }
        
    }
}
void Solyaris::touchesMoved( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        graph.touchMoved(touch->getPos(),touch->getPrevPos(),touch->getId());
        
    }
}
void Solyaris::touchesEnded( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        graph.touchEnded(touch->getPos(),touch->getId());
    }
}



#pragma mark -
#pragma mark Gestures




/*
 * Pinched.
 */
void Solyaris::pinched(UIPinchGestureRecognizer* recognizer) {
    GLog();
    
    // states
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // reset
        pscale = 1.0;
        ppinch = [recognizer locationInView:recognizer.view];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }

    
    // check
    if ([recognizer numberOfTouches] == 2) {
        
        // position
        CGPoint pinch = [recognizer locationInView:recognizer.view];
        double scale = recognizer.scale;
        
        // graph
        graph.pinched(Vec2d(pinch.x,pinch.y), Vec2d(ppinch.x,ppinch.y), scale, pscale);
        
        // value
        pscale = scale;
        ppinch = pinch;
    }

}




#pragma mark -
#pragma mark Business


/*
 * Creates a node.
 */
NodePtr Solyaris::createNode(string nid, string type) {
    GLog();
    
    // graph
    return graph.createNode(nid,type);
}
NodePtr Solyaris::createNode(string nid, string type, double x, double y) {
    GLog();
    
    // graph
    return graph.createNode(nid,type,x,y);
}

/*
 * Gets a node.
 */
NodePtr Solyaris::getNode(string nid) {
    GLog();
    
    // graph
    return graph.getNode(nid);
}

/*
 * Creates an edge.
 */
EdgePtr Solyaris::createEdge(string eid, string type, NodePtr n1, NodePtr n2) {
    GLog();
    
    // graph
    return graph.createEdge(eid,type,n1,n2);
}

/*
 * Gets an edge.
 */
EdgePtr Solyaris::getEdge(string nid1, string nid2) {
    GLog();
    
    // graph
    return graph.getEdge(nid1,nid2);
}

/*
 * Prepares solyaris for loading.
 */
void Solyaris::load(NodePtr n) {
    GLog();
    
    // graph
    graph.load(n);
}

/**
 * Unloads a node.
 */
void Solyaris::unload(NodePtr n) {
    GLog();
    
    // graph
    graph.unload(n);
}



CINDER_APP_NATIVE( Solyaris, RendererGl )
