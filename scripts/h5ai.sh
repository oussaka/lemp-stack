#!/usr/bin/env bash

# echo "Nombre de paramètres : $#"
# echo "Le 1er paramètre est : $1"
green=$(tput -Txterm setaf 2)
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
RED='\033[0;31m'
NC='\033[0m' # No Color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

h5aiDIRECTORY="_h5ai"
DOCUMENTROOT=$1
NEWh5aiINSTALLED=0

for currentDir in `ls ${DOCUMENTROOT}`
do
        cd $DOCUMENTROOT
        if [ -d $currentDir ] && [ ! -d "$DOCUMENTROOT$currentDir/$h5aiDIRECTORY" ] && [ $currentDir != "html" ]; then
          # Control will enter here if $DIRECTORY doesn't exist.
          cd $currentDir
          echo -e ${BYellow}"Download h5ai in $currentDir directory${NC}"
          curl -O http://release.larsjung.de/h5ai/h5ai-0.27.0.zip 
          unzip h5ai-0.27.0.zip -d ./
          # extract h5ai-0.27.0.zip
          cd $DOCUMENTROOT
          NEWh5aiINSTALLED=1
        fi
done

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

# if [ $APACHE_IS_INSTALLED -eq 0 ] && [ $NEWh5aiINSTALLED -eq 1 ]; then
#   echo -e "${BCyan}>>>${NC} ${Blue}Apache Server : Change ${BCyan}DirectoryIndex${NC}"
#   NEW_DIRINDEX="DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php"
# 
#   echo $NEW_DIRINDEX > /etc/apache2/mods-available/dir.conf
#   service apache2 restart
# fi

# if [ $NGINX_IS_INSTALLED -eq 0 ] && [ $NEWh5aiINSTALLED -eq 1 ]; then
#   echo ">>> Installing Nginx Server"
#   echo ">>> ${BBlue}Nginx Server : Change ${BCyan}Index${NC}"
#   nginx 1.2: in nginx.conf set for example:
#   index  index.html  index.php  /_h5ai/server/php/index.php;
# 
#   NEW_DIRINDEX="DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php"
#   sudo NEW_DIRINDEX >> /etc/apache2/mods-available/dir.conf
#   sudo service apache2 restart
# fi

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
     /           //  /     
 \_/' \         |/  /         
  |    |   _,^-'/  /              
  |    , ``  (\/  /_        
   \,.->._    \X-=/^         
   (  /   `-._//^`  
    `Y-.____(__}              
     |     {__)           
           ()`     
EOF