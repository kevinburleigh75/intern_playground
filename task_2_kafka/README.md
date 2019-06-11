
## Targets

- AWS Kafka template

  - Summary of Findings
    - Kafka and MSK exist, but do not have some features that indicate that there will be further expansion on MSK later (e.g., no templates, failure of the command line to return things without the debuf function) or furhter issues.
    - Also, testing kafka is incredibly annoying or expensive; there is no way to simply stop a kafka cluster; you have to shut it down and restart.
    - There are kafka ami's avalible in EC2 (community), but I have not looked into using those.
  - end goal:
    - we want to distribute immutable event histories to other systems for analysis
  - initial target:
    - create a template to spin up a Kafka cluster
      - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html
      - MSK is not on the list of available services
      - https://github.com/awslabs/aws-servicebroker/issues/91 Does not appear to be on timeline
    - test basic usage (clients, etc.)
      - Starting Here: https://docs.aws.amazon.com/msk/latest/developerguide/create-vpc.html
      - We need to attach a policy with the role "AmazonMSKFullAccess" to any ec2 instance
      - Kafka needs java on your instance
      - aws kafka describe-cluster --region us-east-2 --cluster-arn $ARN for information
      - Create topic: bin/kafka-topics.sh --create --zookeeper 10.0.1.127:2181,10.0.3.196:2181,10.0.2.167:2181 --replication-factor 3 --partitions 1 --topic WLHTestTopic
      - When getting the bootstrap string with get-bootstrap, use the --debug option, as the bootstrap string does not appear otherNise :(
      - Need a high amoutn of memory (does not work on t2.micro, aws recommends t2.2xlarge)
      - Will need to increase java heap size; export \_JAVA_OPTIONS="-Xmx1g"
      - Created an image with kafka and java installed and configured
    - evaluate 3rd party library support (ruby, python, etc.)
