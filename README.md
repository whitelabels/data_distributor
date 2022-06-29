# data_distributor

## Introduction

A client for looking up 
  1. people in the danish CPR registry
  2. buildings in the central building registry

## Installation
You can install data_distributor via rubygems:
````
$ gem install data_distributor
````  
Or add this to your Gemfile:
````
gem 'data_distributor'
````

## Dependencies
None

## Usage

### CPR-client
With the gem, you can make queries into the Danish CPR registry and get information about a person based on CPR number.
It requires a certificate, which you can read more about here: https://cpr.dk/kunder/offentlige-myndigheder/datafordeler

````
require 'data_distributor'

client = DataDistributor::CPR::Client.new(DataDistributor::Authentication::Proxy.new(proxy_host: "http://localhost:9060"))

person = client.person(cpr: "0101851001")

if person.nil?
  puts "Not found or cpr-number is name protected"
else
  puts person.first_name + " " + person.last_name + " is " + person.age + " years old."
  puts "and lives on " + person.address.street_name + " " + person.address.building_number

````
#### Proxy
This example uses a http-proxy written in js.

````
/**
 * Module dependencies.
 */

var http = require('http'),
    httpProxy = require('http-proxy');
var fs = require('fs');

/**
 * Create HTTP server.
 */

httpProxy.createProxyServer({
    target: {
        protocol: 'https:',
        host: 'Insert host name',
        port: 443,
        pfx: fs.readFileSync('Certificate ---.p12'),
        passphrase: 'Password'
    },
    // secure: false,
    changeOrigin: true
}).listen(9060);
````

#### How to test

Tests goes here


### BBR-client
````
Description of BBR-client goes here
````



ToDo: development - opdatering af cassetter - opsætning - dependencies
howto test - køre tests
TODO: omdøbe master branch til Main
