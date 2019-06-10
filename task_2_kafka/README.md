
## Targets

- AWS Kafka template
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
      - bin/kafka-topics.sh --create --zookeeper 10.0.3.100:2181,10.0.2.18:2181,10.0.1.184:2181 --replication-factor 3 --partitions 1 --topic WLHTestTopic

    - evaluate 3rd party library support (ruby, python, etc.)
