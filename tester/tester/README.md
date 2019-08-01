# README


This is a driver for a testing application, and a basic pinger.

All code is in requester.rb, in app/lib.
All time is in seconds. 

There are three classes.
 - DriverData
    - Simply stores the rate values, and updates them functionally. 
    - Also handles connecting to the database and pulling new rates.
    
 - Driver
    - Handles all the running of the actual tester.
    - Does randomize start time.
    - Initalized as follows:
        - `initialize(lambda, num_threads, dvr_upd_intvl, chld_upd_invl, stop = false, num_iterations = 10)`
        - `lambda` - the desired lambda
        - `num_threads` - the number of pinger threads; also creates one more thread for the pinger controller (for num_threads + 1 new threads)
        - `dvr_upd_intvl` - how often the pinger controller checks the database
        - `chld_upd_intvl` - how often the child threads check for new pinger data in the local object
        - `stop` - whether it stops
        - `num_intervals` - How many times it runs the lambda before a thread stop
    - Use `Driver.run()` to start.
    - When all child threads die, the controller is killed.
    
 - DriverChild
    - Handles the logic of one driver child.
    - If randomization of times is desired to be added, it would be added here.
    - Uses a "debt" system; would be 1 - desired distribution 
    
    

Notes:
 - I changed the config for the database cleaner in rails_helper from using transactions to truncation; this is needed for the tests to work. 



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
