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
    
    // app
    this->setDeviceOrientation(UIDeviceOrientationPortrait);
    
    // graph
    graph = Graph(768,1024);
    
    // sketch
    bg = Color(30.0/255.0, 30.0/255.0, 30.0/255.0);
    
    
    // IMDG
    imdgViewController = [[IMDGViewController alloc] init];
    imdgViewController.imdgApp = this;
    [imdgViewController loadView];
    

}


/*
 * Cinder settings.
 */
void IMDGApp::prepareSettings(Settings *settings) {
    DLog();
    
    // stage
    settings->setWindowSize(768, 1024);
    
    // device
    settings->enableMultiTouch();
}


/*
 * Sets the orientation.
 */
void IMDGApp::setDeviceOrientation(int dorientation) {
    
    // orientation
    orientation = dorientation;
    
    // angle
    float a = 0;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            FLog("UIDeviceOrientationPortrait");
            this->setWindowSize(768, 1024);
            a = 0;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            FLog("UIDeviceOrientationPortraitUpsideDown");
            this->setWindowSize(768, 1024);
            a = M_PI;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            FLog("UIDeviceOrientationLandscapeLeft");
            this->setWindowSize(1024, 768);
            a = M_PI/2.0f;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            FLog("UIDeviceOrientationLandscapeRight");
            this->setWindowSize(1024, 768);
            a = -M_PI/2.0f;
            break;
            
        default:
            FLog("default");
            this->setWindowSize(768, 1024);
            a = 0;
            break;
    }
    
    // app
    orientationMatrix.setToIdentity();
    orientationMatrix.translate( Vec3f( getWindowSize() / 2.0f, 0 ) );
    orientationMatrix.rotate( Vec3f( 0, 0, a) );
    orientationMatrix.translate( Vec3f( -getWindowSize() / 2.0f, 0 ) );
    
}

/*
 * Position depending on orientation.
 */
Vec2f IMDGApp::opos(Vec2f p) {
    GLog();
    
    // position
    Vec2f op = p;
    op -= (getWindowSize()/2.0);
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            op.rotate(-M_PI);
            break;
        case UIDeviceOrientationLandscapeLeft:
            op.rotate(-M_PI/2.0f);
            break;
        case UIDeviceOrientationLandscapeRight:
            op.rotate(M_PI/2.0f);
            break;
        default:
            op = p;
            break;
    }
    op += (getWindowSize()/2.0);
    return op;
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
    glPushMatrix();
    //gl::translate( getWindowSize()/2.0f );
    glMultMatrixf(orientationMatrix);
    graph.draw();
    glPopMatrix();

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
    FLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // taps
        int taps = [(UITouch*)touch->getNative() tapCount];
        
        // touch
        if (taps == 1) {
            
            // touch graph
            Vec2f tp = opos(touch->getPos());
            graph.touchBegan(tp,touch->getId());
        }
        
        // double tap
        if (taps == 2) {
          
            // tap graph
            Vec2f tp = opos(touch->getPos());
            NodePtr node = graph.doubleTap(tp,touch->getId());
            if (node != NULL) {
                
                // tap controller
                NSString *nid = [NSString stringWithCString:node->nid.c_str() encoding:[NSString defaultCStringEncoding]];
                
                // load
                if (! node->isActive()) {
                    [imdgViewController nodeLoad:nid];
                }
                // information
                else {
                    [imdgViewController nodeInformation:nid];
                }
            }
        }
        
    }
}
void IMDGApp::touchesMoved( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        Vec2f tp = opos(touch->getPos());
        Vec2f tpp = opos(touch->getPrevPos());
        graph.touchMoved(tp,tpp,touch->getId());
        
    }
}
void IMDGApp::touchesEnded( TouchEvent event ){
    GLog();
    
    // touch
    for( vector<TouchEvent::Touch>::const_iterator touch = event.getTouches().begin(); touch != event.getTouches().end(); ++touch ) {
        
        // graph
        Vec2f tp = opos(touch->getPos());
        graph.touchEnded(tp,touch->getId());
    }
}



#pragma mark -
#pragma mark Business


/*
 * Creates a node.
 */
NodePtr IMDGApp::createNode(string nid, string type, double x, double y) {
    GLog();
    
    // graph
    return graph.createNode(nid,type,x,y);
}

/*
 * Gets a node.
 */
NodePtr IMDGApp::getNode(string nid) {
    GLog();
    
    // graph
    return graph.getNode(nid);
}

/*
 * Creates an edge.
 */
EdgePtr IMDGApp::createEdge(string eid, string type, NodePtr n1, NodePtr n2) {
    GLog();
    
    // graph
    return graph.createEdge(eid,type,n1,n2);
}

/*
 * Gets an edge.
 */
EdgePtr IMDGApp::getEdge(string nid1, string nid2) {
    GLog();
    
    // graph
    return graph.getEdge(nid1,nid2);
}



CINDER_APP_NATIVE( IMDGApp, RendererGl )
