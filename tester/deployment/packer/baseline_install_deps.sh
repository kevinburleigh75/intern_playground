## doing this twice _seems_ to cut down
## on the number of intermittant failures
sudo apt-get update
sudo apt-get update

## needed for installing rubies
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install libssl-dev libreadline-dev zlib1g-dev
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install build-essential

## needed for postgres and pg gem
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install postgresql postgresql-contrib libpq-dev

## needed for rails migrations, etc.
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install nodejs
