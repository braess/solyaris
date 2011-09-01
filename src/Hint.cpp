//
//  Hint.cpp
//  IMDG
//
//  Created by CNPP on 4.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#include "Hint.h"
#include "cinder/gl/gl.h"
#include "cinder/Text.h"
#include "cinder/CinderMath.h"


#pragma mark -
#pragma mark Object

/**
 * Creates an Hint object.
 */
Hint::Hint() {
}
Hint::Hint(Vec2d b) {
    
    // state
    visible = false;
    
    // position
    pos.set(0,0);
    border.set(10,50);
    bounds = b;
    
    // color
    cbg = ColorA(0.9,0.9,0.9,0.9);
    ctxt = ColorA(0,0,0,1);
    
    
    // font
    font = Font("Helvetica",12);
    sfont = Font("Helvetica",3);
    size.set(0,0);
    offset.set(0,-60);
    inset.set(6,6);
    textureText = gl::Texture(0,0);
}


#pragma mark -
#pragma mark Cinder

/*
 * Resize.
 */
void Hint::resize(int w, int h) {
    
    // fields
    bounds = Vec2d(w,h);
}


#pragma mark -
#pragma mark Sketch

/**
 * Updates the Hint.
 */
void Hint::update() {
   
    // timeout (avoids flickering)
    timeout--;
    
    // alpha
    if (timeout < 0) {
        alpha = min(cbg.a,alpha+0.3f);
    }
    
}

/**
 * Draws the Hint.
 */
void Hint::draw() {
    
    // position
    float px = max(border.x,(pos.x-size.x/2.0+offset.x));
    float py = max(border.y,(pos.y-size.y+offset.y));
    px += min(0.0,bounds.x-(px+size.x+border.x));
    py += min(0.0,bounds.y-(py+size.y+border.y));
    
    // blend
    gl::enableAlphaBlending();
    
    // background
    Rectf rect = Rectf(px,py,px+size.x,py+size.y);
    glColor4f(cbg.r,cbg.g,cbg.b,alpha);
    gl::drawSolidRect(rect, false);
        
    // unblend
    gl::enableAlphaBlending(true);
        
    // draw
    gl::draw(textureText, Vec2d(px,py)+inset);
    
    
}


#pragma mark -
#pragma mark Business



/**
 * States.
 */
bool Hint::isVisible() {
    return visible;
}



/**
 * Renders the text.
 */
void Hint::renderText(vector<string> txts) {
    GLog();
    
    // text
    TextLayout tlText;
	tlText.clear(ColorA(0, 0, 0, 0));
	tlText.setFont(font);
	tlText.setColor(ctxt);
    
    // lines
    for (vector<string>::iterator txt = txts.begin(); txt != txts.end(); ++txt) {
        tlText.setFont(sfont);
        tlText.addLine(" ");
        tlText.setFont(font);
        tlText.addLine((*txt));
    }
    
    // render
	Surface8u rendered = tlText.render(true, true);
	textureText = gl::Texture(rendered);
    
    // offset
    size.x = textureText.getWidth() + 2*abs(inset.x);
    size.y = textureText.getHeight()+ 2*abs(inset.y);
    
}

/**
 * Show / Hide.
 */
void Hint::show() {
    
    // props
    visible = true;
    alpha = 0;
    timeout = 12;
    
}
void Hint::hide() {
    visible = false;
    alpha = 0;
}


/**
 * Position.
 */
void Hint::position(Vec2d p) {
    pos = p;
}



