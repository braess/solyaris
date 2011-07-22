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
 * Cinder Setup.
 */
void IMDGApp::setup() {
    DLog();
    
    // graph
    graph = Graph(768,1024,0);
    
    
    // sketch
    bg = Color(30.0/255.0, 30.0/255.0, 30.0/255.0);
    
    
    // components
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    float wwidth = window.frame.size.width;
    //float wheight = window.frame.size.height;
    
    // IMDG
    CGRect frameIMDG = CGRectMake(0, 0, wwidth, 40);
    imdgViewController = [[IMDGViewController alloc] initWithFrame:frameIMDG];
    imdgViewController.imdgApp = this;
	[window addSubview:imdgViewController.view];
	[window bringSubviewToFront:imdgViewController.view];
    [imdgViewController loadView];
	[imdgViewController viewWillAppear:NO];
    
    // check
    console() << "MT: " << System::hasMultiTouch() << " Max points: " << System::getMaxMultiTouchPoints() << std::endl;

}


/*
 * Cinder settings.
 */
void IMDGApp::prepareSettings(Settings *settings) {
    DLog();
    
    // stage
    settings->setWindowSize(768, 1024);
    //settings->setFrameRate( 24.0f );
    
    
    // device
    settings->enableMultiTouch();
}



#pragma mark -
#pragma mark Sketch

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
    
    // prepare
    gl::setMatricesWindow( getWindowSize() );
	gl::setViewport( getWindowBounds() );
    gl::enableDepthWrite();
    //gl::enableAlphaBlending( false );
    
    // clear
	gl::clear(bg);    
    
    // graph
    graph.draw();

}


/*
 * Cinder reset.
 */
void IMDGApp::reset() {

    // graph
    graph.reset();
    
}



#pragma mark -
#pragma mark Touch

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



#pragma mark -
#pragma mark Business

/*
 * Test.
 */
void IMDGApp::test() {
    DLog();
    
    // graph
    graph.reset();
    graph.test();
    
}

/*
 * Adds a node.
 */
void IMDGApp::addNode(Node n) {
    DLog();
    
    // graph
    graph.addNode(n);
    
}

/*
 * Gets a node.
 */
Node* IMDGApp::getNode(string nid) {
    DLog();
    
    // graph
    return graph.getNode(nid);
    
}

/*
 * Activates a node.
 */
void IMDGApp::activateNode(Node *n) {
    DLog();
    
    // graph
    graph.activateNode(n);
    
}

CINDER_APP_NATIVE( IMDGApp, RendererGl )
