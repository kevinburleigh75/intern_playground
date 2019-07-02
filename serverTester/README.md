#ServerTester
##Pinger.rb
Includes 2 methods:\
measure_request\
ping_looper
####measure_request
Parameters:
- host - string containing the host of the desired url
- port - string containing the port of the desired url
- path - string containing the path of the desired url
- timeout - integer representing read timeout in seconds

Effects:\
Returns a hash containing the following information:
- uuid - a randomly generated uuid given to the request
- request_time - a timestamp 
- endpoint - a string containing the url
- success - a boolean indicating connection success. Only true when status is 200
- status - the http status number returned by the server
- elapsed - the total time it took for the request and response to process

Given a host, port, path, and timeout, constructs a parsable uri, 
which is then used to send the appropriate request depending on the given path ("ping" => GET, "hello => POST).
When given an invalid path, throws and argument error, and returns correct error values inside the hash.

####ping_looper
Parameters:
- host - string containing the host of the desired url
- port - string containing the port of the desired url
- path - string containing the path of the desired url
- timeout - integer representing read timeout in seconds
- count - integer representing the number of requests to be sent

Effects:\
Creates a new record per request, inputting values returned by measure_request

Given a host, port, path, timeout, and count, calls on measure_request count number of times, 
recording returned hash values into the database.


