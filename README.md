# Data Distributor (WiP)

A client for looking up 
  1. people in the danish CPR registry
  2. buildings in the central building registry

## Install
You can install data_distributor via rubygems:
````
$ gem install data_distributor
````  
Or add this to your Gemfile:
````
gem 'data_distributor'
````


## Usage

### CPR-client:


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



### BBR-client:
````
Description of BBR-client goes here
````



ToDo: development - opdatering af cassetter - opsætning - dependencies
howto test - køre tests
TODO: omdøbe master branch til Main
