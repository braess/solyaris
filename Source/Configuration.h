//
//  Configuration.h
//  Solyaris
//
//  Created by Beat Raess on 28.3.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#pragma once
#include <boost/lexical_cast.hpp>
#include <iostream>
#include <string> 
#include <map>

// namespace
using namespace std;

// declare
class Config;


// constants
const string  cDisplayRetina        = "conf_display_retina";



/**
 * Graph Configuration.
 */
class Configuration {
    
    // public
    public:
    
    // Setting
    Configuration();
    
    // Accessors
    void setConfiguration(string key, string value);
    Config getConfiguration(string key);
    
    // private
    private:
    
    // Fields
    map<string,Config>configurations;
};


/**
 * Graph Config.
 */
class Config {
    
    // public
    public:
    
    // Setting
    Config();
    Config(string k, string v); 
    
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
