## Make sure we have the latest code from the repo.
cd ~/intern_playground
git fetch origin

## Checkout the target branch-or-SHA
git checkout $BRANCH_OR_SHA

## Install gems.
cd tester/tester/
bundle install

## Migrate, if necessary.
## TODO: This will be removed once
##       we hook up to RDS.
bundle exec rake db:create db:migrate
