# dotfiles

## Pacman install from list

```bash
$ pacman -Qqe > pkglist.txt
```

https://wiki.archlinux.org/title/pacman/Tips_and_tricks#List_of_installed_packages

## Pacman install from list

```bash
$ pacman -S --needed - < pkglist.txt
```

or

```bash
$ pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
```

https://wiki.archlinux.org/title/pacman/Tips_and_tricks#Install_packages_from_a_list
