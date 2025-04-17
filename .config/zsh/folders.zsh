create_or_cd () {
  [ ! -d $1 ] && mkdir $1
  cd $1
}

work () { create_or_cd ~/Documents/working }
learn () { create_or_cd ~/Documents/learning }
play () { create_or_cd ~/Documents/playground }
oss () { create_or_cd ~/Documents/open-source }
cfg () { create_or_cd ~/dotfiles } 
