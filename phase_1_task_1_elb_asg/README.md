Phase One: Set up an ASG with an ELB, attach it to Route53 and a database in an app stack. Do so in a template.


~~Step One: Set up an auto-scaling group with an ELB.~~
 - One attaches an ASG to an ELB rather than the other way around
 - We are using application load balancers
  - Use "TargetGroupARNs:" in an ASG to attach
  - Default port is 3000, not 80
  - Set up basic HTTP server on instances
    - $ python -m SimpleHTTPServer 8000
  - Connected to server with curl, and by browser url with correct port to verify success
  - Tested proper deletion of ASG stack - successful.

Step Two:
  Attach said ELB to Route53
