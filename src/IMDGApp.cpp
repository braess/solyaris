//
//  IMDGApp.h
//  IMDG
//
//  Created by CNPP on 4.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "IMDGApp.h"


#pragma mark -
#pragma mark Cinder

/*
 * Cinder settings.
 */
void IMDGApp::prepareSettings(Settings *settings) {
    DLog();
    
    // stage
    settings->setWindowSize(768, 1024);
    //settings->setFrameRate( 60.0f );
    
    
    // device
    settings->enableMultiTouch();
}


/*
 * Cinder Setup.
 */
void IMDGApp::setup() {
    DLog();
    
    // graph
    graph = Graph(768,1024,0);
    graph.test();
    
    // sketch
    bg = Color(30.0/255.0, 30.0/255.0, 30.0/255.0);

}


/*
 * Cinder update.
 */
void IMDGApp::update() {
    
    // graph
    graph.update();
}

/*
 * Cinder draw.
 */
void IMDGApp::draw() {
    
    // clear
	gl::clear(bg);
	gl::enableAlphaBlending();
	gl::enableDepthRead();
    
    gl::setMatricesWindow( getWindowSize() );
	gl::setViewport( getWindowBounds() );
    
    
    // graph
    graph.draw();

}


/*
 * Cinder touch events.
 */
void IMDGApp::touchesBegan( TouchEvent event ) {
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        graph.touchBegan(touch->getPos(),touch->getId());
    }
}
void IMDGApp::touchesMoved( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        graph.touchMoved(touch->getPos(),touch->getPrevPos(),touch->getId());
        
    }
}
void IMDGApp::touchesEnded( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        graph.touchEnded(touch->getPos(),touch->getId());
    }
}

CINDER_APP_COCOA_TOUCH( IMDGApp, RendererGl )
