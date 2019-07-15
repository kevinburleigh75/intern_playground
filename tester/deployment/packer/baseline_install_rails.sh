## Create an 'ubuntu' superuser so that rails
## migration commands will work.
sudo -u postgres createuser -s ubuntu

## Clone the repo baseline.  In the future
## this should be the master branch.
git clone https://github.com/kevinburleigh75/intern_playground.git
cd intern_playground
git checkout klb_merge

## Install the project's baseline gems
## so that future calls to 'bundle install'
## will (usually) be much faster.
cd tester/tester/
gem install bundler
bundle install
