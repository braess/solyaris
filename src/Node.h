//
//  Node.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "cinder/Vector.h"
#include "cinder/Color.h"


// namespace
using namespace std;
using namespace ci;


/**
 * Graph Node.
 */
class Node {
    
    // Fields
    double perimeter;
    double damping;
    double strength;
    double ramp;
    double mvelocity;
    double speed;
    
    // color
    ColorA bg;
    
    
    // Methods
    public:
    
    // object
    Node();
    Node(double x, double y, double r); 
    
    // sketch
    void update();
    void draw();
    
    
    // business
    void attract(Node &n);
    void moveTo(double x, double y);
    void moveTo(Vec2d p);
    void move(double dx, double dy);
    void move(Vec2d d);
    
    
    // Public Fields
    Vec2d pos;
    Vec2d mpos;
    float radius;
    float mass;
	Vec2d velocity;
    
    // states
    bool selected;

};
