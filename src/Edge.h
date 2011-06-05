//
//  Edge.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "Node.h"
#include "cinder/Color.h"


// namespace
using namespace std;
using namespace ci;

/**
 * Graph Edge.
 */
class Edge {
    
    // Fields
    double length;
    double stiffness;
    double damping;
    
    // color
    ColorA stroke;
    
    
    // Methods
    public:
    
    // object
    Edge();
    Edge(Node &n1, Node &n2); 
    
    // sketch
    void update();
    void draw();
    
    // business
    void repulse();
    
    // Public Fields
    Node *node1;
    Node *node2;
};