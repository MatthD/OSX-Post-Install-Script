#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\
# Ce script est à utiliser après la synchronisation des données Dropbox (ou Google Drive, ou iCloud, ou ce que vous voulez)


echo "Installation de oh-my-zsh"
# Installation de oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

echo "Installation de nvm"
# Installation de nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

echo "Installation de nodev8"
# Installation de node
nvm install 8

echo "Installation de mackup et restauration des préférences."
brew install mackup
# Sélection du service de cloud (à commenter si vous utilisez Dropbox, c'est le service par défaut) : https://github.com/lra/mackup/blob/master/doc/README.md
#echo -e "[storage]\nengine = google_drive" >> ~/.mackup.cfg

# Récupéeation de la sauvegarde sans demander à chaque fois l'autorisation
mackup restore -n

sudo softwareupdate --install -all