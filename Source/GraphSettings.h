//
//  GraphSettings.h
//  Solyaris
//
//  Created by CNPP on 19.8.2011.
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

#pragma once
#include <boost/lexical_cast.hpp>
#include <iostream>
#include <string> 
#include <map>

// namespace
using namespace std;

// declare
class Default;


// constants
const string  sGraphLayoutNodesDisabled        = "graph_layout_nodes_disabled";
const string  sGraphLayoutSubnodesDisabled     = "graph_layout_subnodes_disabled";
const string  sGraphCrewEnabled                = "graph_crew_enabled";	
const string  sGraphNodeInitial                = "graph_node_initial";	
const string  sGraphEdgeLength                 = "graph_edge_length";



/**
 * Graph Settings.
 */
class GraphSettings {
    
    // public
    public:
    
    // Setting
    GraphSettings();
    
    // Accessors
    void setDefault(string key, string value);
    Default getDefault(string key);
    
    // private
    private:
    
    // Fields
    map<string,Default>defaults;
};


/**
 * Graph Default.
 */
class Default {
    
    // public
    public:
    
    // Setting
    Default();
    Default(string k, string v); 
    
    // Accessors
    bool isSet();
    string stringVal();
    int intVal();
    float floatVal();
    double doubleVal();
    bool boolVal();
    
    // private
    private:
    
    // Fields
    string key;
    string value;
    bool set;
};