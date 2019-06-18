Phase One: Set up an ASG with an ELB, attach it to Route53 and a database in an app stack. Do so in a template.


Step One: Set up an auto-scaling group with an ELB.
 - One attaches an ASG to an ELB rather than the other way around
 - We are using application load balancers
  - Use "TargetGroupARNs:" in an ASG to attach

Step Two:
  Attach said ELB to Route53
