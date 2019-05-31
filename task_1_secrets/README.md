
## Targets

- ~~write a CLI tool to put secrets into SM/PS
show how instances (e.g., those in ASGs) can retrieve those secrets~~
  - Wrote script to connect existing instance to database, if secret and database are set up beforehand (and there is a special user with only secret permissions)
  - We can use IAM permissions to give secret access to the images themselves. Magic. s
  - Achieved rotation on above; will automatically update database when rotation command is used.
  - Putting secrets inside SM is chicken and egg problem; the db server needs to come first, and the secret built from the password within that db, or the secret comes first, and db is initialized with server code.
  - Currently can only access and change one database at a time - cµµan probably modify with lambda function.

- ~~figure out under what circumstances we can easily rotate secrets~~
  - AWS has prebuiltin setup for rotating secrets around RDS database (includes PSQL and Aurora). When rotation is called, password changes on server itself and in the key.
  - Existing server is easy; can even be on private VPC and rotation will work (not tested personally)
  - Lambda function runs a python script to update servers. We can download it from online. We can modify this python script to touch more than one db server, but this needs to be done manually.
  - When we create with GUI, creates a CloudFormation stack with a lambda for the sole purpose of rotation. Template is accessible.
  - Rotating is easy; but minimum 30 days rotation and max 365, but can always call rotation command in CLI. I only know how to rotate for one database, but can probably do more.
  - https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets-two-users.html may potentially be useful; secret file is a json file in cloud, and can do stuff in response

- ~~New Goal: Find out what adjustments are needed to templates for automated secrets~~
  - All you do is update the rolestack
  - In EC2 Instance Role, update ManagedPolicyArns with SecretsManagerReadWrite

- Figure out ParameterStore differences
  - It's free.
  - Rotations must be implemented manually with Lambda Functions.
  - You can't just give the role AmazonSSMFullAccess in the template; it doesn't work
  - Need to use IAM user for access to parameterstore (have not figured it out personally without using own admin)

- Figure out double Rotations
  - Implemented own double rotation lambda function
  - Also found one online (after I made own :( )
  - Current bottleneck is figuring out why users do not have permissions to change the passwords of another user
