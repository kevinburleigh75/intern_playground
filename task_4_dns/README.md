Rapid assignment of DNS to newly-created resources (especially ELBs)
end goal:
 - when we spin up a new environment, we need to assign an easy-to-remember DNS name to its endpoints (e.g., blah.environment.openstax.org)
 - the subdomain names will already be determined, so just focus on assigning a known subdomain name
 - we also need to make sure that the new DNS information trickles through the system quickly (seconds as opposed to days)
initial target:
 - I think the Negative Response TTL is the way to control this: we should set it to be something reasonably small (30? sec) but leave the regular TTL set to something bigger (1? hour)

 - Only information gathered, did not get ELB template working
  - Negative ttl seems to be refered to as "negative caching" in the documentation
    - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/SOA-NSrecords.html
    - It seems that you have to access the "Start of Authority Record" to change the negative TTL
    - At this point, I have
  - Can adjust ttl in Route53
    - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordset.html
    - argument is literally TTL
