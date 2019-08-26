#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

## La base : Homebrew et les lignes de commande
if test ! $(which brew)
then
	echo 'Installation de Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vérifier que tout est bien à jour
brew update

## Utilitaires pour les autres apps : Cask et mas (Mac App Store)
echo 'Installation de mas, pour installer les apps du Mac App Store.'
brew install mas
echo "Saisir le mail du compte iTunes :"
read COMPTE
echo "Saisir le mot de passe du compte : $COMPTE"
read PASSWORD
mas signin $COMPTE "$PASSWORD"

# Installation d'apps avec mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==> $1 est déjà installée"
	else
		echo "==> Installation de $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

echo 'Installation de Cask, pour installer les autres apps.'
brew tap caskroom/cask

## Installations des logiciels
echo 'Installation des outils en ligne de commande.'
brew install wget cmake coreutils psutils git ffmpeg libssh zsh vim git-extras java sshfs boost opencv htop
brew tap zyedidia/micro
brew install micro bower xmlstarlet
gem install sass

# Installer oh My zsh & met ZSH par default
sudo curl -L http://install.ohmyz.sh | sh
chsh -s /bin/zsh
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions


echo 'Installation des apps : utilitaires.'
brew cask install google-backup-and-sync  dropbox  slack hyperdock sublime-text osxfuse webstorm clion visual-studio-code iterm2
install "FastScripts"
install "MacTracker"

## Add theme to oh-my-zsh
cp bullet-train.zsh-theme ~/.oh-my-zsh/themes

## Install police  powerfont for terminal
sh ./fonts-master/install.sh

#echo "Ouverture de Google Drive pour commencer la synchronisation"
open -a Google\ Drive

# Installation manuelle de SearchLink
cd /tmp/ && curl -O http://cdn3.brettterpstra.com/downloads/SearchLink2.2.3.zip && unzip SearchLink2.2.3.zip && cd SearchLink2.2.3 && mv SearchLink.workflow ~/Library/Services/

echo 'Installation des apps : bureautique.'
install "Marked"
easy_install SpoofMAC

## INSTALL SUBLIME 3 VERSION
defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'
brew cask install sublime-text
## INSTALL SUBLIME PACKAGE MANAGEMENT
wget https://sublime.wbond.net/Package%20Control.sublime-package
mv Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/

echo 'Installation des apps : développement.'
brew cask install install "docker"


echo 'Installation des apps : communication.'
brew cask install google-chrome firefox
brew cask install silverlight flash-player --appdir=/Applications


#echo 'Installation des apps : photo et vidéo.'
#brew cask install imageoptim sketch qlimagesize

echo 'Installation des apps : loisir.'
brew cask install vlc the-unarchiver spotify --appdir=/Applications

# DockArt (installation manuelle, faute de mieux)
cd /tmp/ && curl -O http://www.splook.com/Software/DockArt_files/DockArt2.zip && unzip DockArt2.zip && cd DockArt\ 2.2 && mv DockArt.bundle ~/Library/iTunes/iTunes\ Plug-ins


## Install de tesseract & quelques Library
brew install htop
brew install leptonica --with-libtiff
brew install imagemagick
brew install tesseract --with-all-languages
brew tap homebrew/science
brew install boost
brew install opencv

## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut…"

## Desactive la surveillance des disque (pour un ssd)
sudo pmset -a sms 0

## FINDER

# Affichage de la bibliothèque
chflags nohidden ~/Library

# Finder : affichage de la barre latérale / affichage par défaut en mode liste / affichage chemin accès / extensions toujours affichées
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
defaults write com.apple.finder ShowPathbar -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Afficher le dossier maison par défaut
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

#Afficher disques externe sur le bureau
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Recherche dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Coup d'œîl : sélection de texte
defaults write com.apple.finder QLEnableTextSelection -bool true

# Pas de création de fichiers .DS_STORE
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Affichage dossier cachés par default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Rend les icones des app cachés transluicides
defaults write com.apple.dock showhidden -bool true


## RÉGLAGES DOCK
# Taille du texte au minimum
#defaults write com.apple.dock tilesize -int 15
# Agrandissement actif
defaults write com.apple.dock magnification -bool true
# Taille maximale pour l'agrandissement
defaults write com.apple.dock largesize -float 90

## MISSION CONTROL
# Pas d'organisation des bureaux en fonction des apps ouvertes
defaults write com.apple.dock mru-spaces -bool false

# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## COINS ACTIFS
# En haut à gauche : bureau
#defaults write com.apple.dock wvous-tl-corner -int 4
#defaults write com.apple.dock wvous-tl-modifier -int 0
# En haut à droite : bureau
#defaults write com.apple.dock wvous-tr-corner -int 4
#defaults write com.apple.dock wvous-tr-modifier -int 0
# En bas à gauche : fenêtres de l'application
#defaults write com.apple.dock wvous-bl-corner -int 3
#defaults write com.apple.dock wvous-bl-modifier -int 0
# En bas à droite : Mission Control
#defaults write com.apple.dock wvous-br-corner -int 2
#defaults write com.apple.dock wvous-br-modifier -int 0

## CLAVIER ET TRACKPAD

# Désactivation du scroll naturel
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Accès au clavier complet (tabulation dans les boîtes de dialogue)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

## Aficher la batterie en %
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

## Active clique droit
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Arrêt pop-up clavier façon iOS
sudo defaults write -g ApplePressAndHoldEnabled -bool false

# Répétition touches plus rapide
sudo defaults write NSGlobalDomain KeyRepeat -int 1
# Délai avant répétition des touches
sudo defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Alertes sonores quand on modifie le volume
sudo defaults write ~/Library/Preferences/.GlobalPreferences.plist -int 1

# Réglages Trackpad : toucher pour cliquer
#sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trier l'activité du moniteur par CPU
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Desactivation des DASHBOARD
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Desactivation du fast User switch
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false

# Desactive TimeMachien sur les nouveaux volumes
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


## Activation de debug dans utilitaire de disque
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

## APPS

# Désactivation de l'autocorrection
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Safari : menu développeur / URL en bas à gauche / URL complète en haut / Do Not Track / affichage barre favoris
defaults write com.apple.safari IncludeDevelopMenu -int 1
defaults write com.apple.safari ShowOverlayStatusBar -int 1
defaults write com.apple.safari ShowFullURLInSmartSearchField -int 1
defaults write com.apple.safari SendDoNotTrackHTTPHeader -int 1
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Desactivationd es miniatures safari
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Activation du retour arriére avec backspace safari
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES


# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

# Raccourci pour exporter
sudo defaults write -g NSUserKeyEquivalents '{"Export…"="@$e";"Exporter…"="@$e";}'

# Configuration de git
git_configs=(
  "branch.autoSetupRebase always"
  "color.ui auto"
  "core.autocrlf input"
  "core.pager cat"
  "credential.helper osxkeychain"
  "merge.ff false"
  "pull.rebase true"
  "push.default simple"
  "rebase.autostash true"
  "rerere.autoUpdate true"
  "rerere.enabled true"
  "user.name MatthD"
  "user.email matthias.dieudonne@gmail.com"
)

for config in "${git_configs[@]}"
do
  git config --global ${config}
done

echo "Installing mac CLI ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder


echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo "ET VOILÀ !"

# Active le trimeForce (Pour les SSD)
echo "Le trimeforce va etre activé pour votre SSD , un redemarage est requis, executez script post-cloud.sh aprés le redemarage"
trimforce enable
