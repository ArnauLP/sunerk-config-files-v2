#!/bin/bash

# colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

tput civis
trap ctrl_c INT

base_dir=$(pwd)

# capture SIGQUIT
function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
    tput cnorm;
    exit 0
}

echo "Run install-root.sh with root privileges to apply config for root user."

echo -e "${yellowColour}\n[+]First Update your system to the latest version possible.${endColour}"
read -p "y/n: " yn

if [[ $yn == 'y' || $yn == 'yes' ]]; then
    echo "Updating..."
    crnt_kernel_ver=$(uname -r)
    sleep 1
    sudo apt-get update -y 2>/dev/null
    sudo apt-get upgrade -y 2>/dev/null
    new_kernel_ver=$(uname -r)
    if [[ $crnt_kernel_ver != $new_kernel_ver ]]; then
        read -p "-> Reboot system now?. [y/n] (recommended): " sys_reboot
        if [[ $sys_reboot == 'y' || $sys_reboot == 'yes' ]]; then
            sudo reboot
        fi
    fi
elif [[ $yn == 'n' || $yn == 'no' ]]; then
    echo "Continuing..."
    sleep 1
else
    echo -e "${redColour}[!] Invalid input!${endColour}\n"
    exit 0
fi

echo -e "${yellowColour}\n[!]Required dependencies: {neovim, kitty, JetBrainsMono Nerd Font}.${endColour}\n"
sleep 2
echo "Will attempt to install."
sleep 1

# create important directories
echo "creating directories..."
mkdir -p repos
mkdir -p repos{picom,oh-my-zsh}
mkdir -p ~/.config/{bspwm,sxhkd,kitty,nvim,rofi,polybar,picom}
sleep 1

# NERD FONT INSTALL
sudo mkdir -p /usr/share/fonts/JetBrainsMono/
sudo cp -r ./fonts/* /usr/share/fonts/JetBrainsMono/

# NVCHAD config (later binari installation)
cp -r ./nvim/* ~/.config/nvim/

# ROFI config
echo -e "\n[+]Attempting to install ${greenColour}rofi${endColour}...\n"
sudo apt install -y rofi 2>/dev/null
cp -r ./rofi/ ~/.config/rofi/

# KITTY config (later binari installation)
echo -e "\n[+] Attempting to install ${greenColour}kitty${endColour}...\n"
sudo apt install -y kitty 2>/dev/null
cp -r ./kitty/* ~/.config/kitty/

# BSPWM config
echo -e "\n[+] Attempting to install ${greenColour}bspwm${endColour}...\n"
cp -r ./bspwm/* ~/.config/bspwm/

# SXHKD config
echo -e "\n[+] Attempting to install ${greenColour}sxhkd${endColour}...\n"
cp -r ./sxhkd/* ~/.config/sxhkd/

echo -e "${blueColour}[+]Installing some dependencies. (it may ask for sudo privileges)${endColour}"
sleep 1

# install dependencies to avoid problems
sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev
# copy to other places for neovim/system
sudo apt install -y xclip xsel
# install bspwm & sxhkd
sudo apt install -y sxhkd
# install picom dependencies
sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

# PICOM - compilation and installation
echo -e "\n${blueColour}[+]Installing and configuring picom...\n${endColour}"
sleep 1
git clone https://github.com/yshui/picom.git ./repos/picom
cd ./repos/picom/
meson setup --buildtype=release build
ninja -C build
sudo ninja -C build install
cd $base_dir
echo "configuring..."
sleep 2
cp -r ./picom/* ~/.config/picom/

# POLYBAR
echo -e "\n${blueColour}[+]Installing and configuring polybar...\n${endColour}"
sudo apt install -y polybar 2>/dev/null
cp -r ./polybar/* ~/.config/polybar/

# ZSH related
echo -e "\n${blueColour}[+]Installing and configuring zsh, oh-my-zsh & powerlevel10k...\n${endColour}"
sleep 1
sudo apt install -y zsh
echo "-> Installed (1/3)."
sudo apt install -y curl wget 2>/dev/null
sudo apt install -y neofetch 2>/dev/null
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "-> Installed (2/3)."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
echo "Installed (3/3)."
sleep 1

echo -e "${yellowColour}\n[+]Instructions:\n-> Logout and then reopen terminal (preferably kitty or use a nerd font in current terminal).\n-> Follow in-screen prompt instructions.\n-> Run ./install-part2.sh\n${endColour}.\n"
sleep 5

cat << "EOF"
       _,.
     ,` -.)
    '( _/'-\\-.               
   /,|`--._,-^|            ,     
   \_| |`-._/||          ,'|       
     |  `-, / |         /  /      
     |     || |        /  /       
      `r-._||/   __   /  /  
  __,-<_     )`-/  `./  /
 '  \   `---'   \   /  / 
     |           |./  /  
     /           //  /     oOoOoOoOoOoOoOoOoOo
 \_/' \         |/  /      OoOo| Script by |oO
  |    |   _,^-'/  /       oOoO| mr.Sunerk |oO
  |    , ``  (\/  /_       ------------------- 
   \,.->._    \X-=/^       oOoOoOoOoOoOoOoOoOo  
   (  /   `-._//^`  
    `Y-.____(__}              
     |     {__)           
           ()`     
EOF

tput cnorm
