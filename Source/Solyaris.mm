//
//  Solyaris.h
//  Solyaris
//
//  Created by CNPP on 4.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "Solyaris.h"


#pragma mark -
#pragma mark Cinder

/*
 * Cinder Launch.
 */
void Solyaris::launch( const char *title, int argc, char * const argv[] ) {
    
    // custom app delegate
	::UIApplicationMain( argc, const_cast<char**>( argv ), nil, @"SolyarisAppDelegate" );
}

/*
 * Cinder Setup.
 */
void Solyaris::setup() {
    DLog();
    
    // sketch
    bg = Color(30.0/255.0, 30.0/255.0, 30.0/255.0);
    
    // graph
    graph = Graph(768,1024,UIDeviceOrientationPortrait);
    
    // app
    this->applyDeviceOrientation(UIDeviceOrientationPortrait);
    this->applySettings();
    
    
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
    settings->setWindowSize(768, 1024);
    
    // device
    settings->enableMultiTouch();
}


/**
 * Applies the orientation.
 */
void Solyaris::applyDeviceOrientation(int dorientation) {
    
    // orientation
    orientation = dorientation;
    
    // orientation
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        this->setWindowSize(1024, 768);
        graph.resize(1024,768,orientation);
    }
    else {
        this->setWindowSize(768, 1024);
        graph.resize(768,1024,UIDeviceOrientationPortrait);
    }
    
}


/**
 * Applies the user defaults.
 */
void Solyaris::applySettings() {
    GLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// graph settings
    GraphSettings gsettings = GraphSettings();
	NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    for (NSString *key in keys) {
        NSObject *def = [userDefaults objectForKey:key];
        
        // string
        if ([def isKindOfClass:[NSString class]]) {
            
            // match
            NSRange range = [key rangeOfString : @"graph_"];
            if (range.location != NSNotFound) {
                gsettings.setDefault([key UTF8String], [(NSString*)def UTF8String]);
            }
        }
    }
    
    // apply
    graph.setting(gsettings);
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
                if (! node->isActive()) {
                    [solyarisViewController nodeLoad:nid];
                }
                // information
                else {
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
#pragma mark Business


/*
 * Creates a node.
 */
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



CINDER_APP_NATIVE( Solyaris, RendererGl )
