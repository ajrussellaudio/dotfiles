hash -d work="$HOME/Documents/working"
hash -d learn="$HOME/Documents/learning"
hash -d play="$HOME/Documents/playground"
hash -d oss="$HOME/Documents/open-source"
hash -d dots="$HOME/dotfiles"

create_or_cd () {
  [ ! -d $1 ] && mkdir $1
  cd $1
}

work () { create_or_cd ~work }
learn () { create_or_cd ~learn }
play () { create_or_cd ~play }
oss () { create_or_cd ~oss }
cfg () { create_or_cd ~dots } 
