Phase One: Set up an ASG with an ELB, attach it to Route53 and a database in an app stack. Do so in a template.


~~Step One: Set up an auto-scaling group with an ELB.~~
 - One attaches an ASG to an ELB rather than the other way around
 - We are using application load balancers
  - Use "TargetGroupARNs:" in an ASG to attach
  - Default port is 3000, not 80
  - Set up basic HTTP server on instances
    - $ python -m SimpleHTTPServer 3000
  - Connected to server with curl, and by browser url with correct port to verify success
  - Tested proper deletion of ASG stack - successful.
~~Step Two: Get Automation Working~~
 - Attach said ELB to Route53 (nvm will fry entire system)
 - Get startup code running
  - Get it working with image
     - Created ami with service on it
     - Using aws linux 2 (image1 is aws linux 1) as linux 1 does not have systemd support
     - Of key note; cannot simply copy service over, make sure user is correct (ec2-user vs ubuntu)
        - The failure of the service will not even show up in the log
Step Three: Cleanup
 - ~~Fix template formatting~~
 - Convert from launch configuration to template
 - ~~Change exports for the ability to create two stacks at the same time~~
