touch ~/.secrets

echo source ~/.secrets >> ~/.bash_profile

## Deail with interactive/non-interactive shell oddities
## by making sure .bashrc sources .bash_profile
sed -i -e '1i. $HOME/.bash_profile\' ~/.bashrc
