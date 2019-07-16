## For details, see:
##    https://github.com/rbenv/rbenv
##    https://github.com/jf/rbenv-gemset
##    https://stackoverflow.com/questions/17618113/the-command-rbenv-install-is-missing
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset
cd ~/.rbenv && src/configure && make -C src
cd

## Add rbenv setup to .bash_profile
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
