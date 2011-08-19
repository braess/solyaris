//
//  GraphSettings.h
//  IMDG
//
//  Created by CNPP on 19.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#pragma once
#include <boost/lexical_cast.hpp>:
#include <iostream>
#include <string> 
#include <map>

// namespace
using namespace std;

// declare
class Default;


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