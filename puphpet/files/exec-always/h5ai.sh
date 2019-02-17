#!/usr/bin/env bash

h5aiDIRECTORY="_h5ai"
DOCUMENTROOT="/var/www"
NEWh5aiINSTALLED=0

cd $DOCUMENTROOT

  if [ -d $DOCUMENTROOT ] && [ ! -d "$DOCUMENTROOT/$h5aiDIRECTORY" ]; then

    # Control will enter here if $DIRECTORY doesn't exist.
    echo -e "${YELLOW}${BWhite}<<< ::: Download h5ai in $DOCUMENTROOT directory ::: >>>${NOCOLOR}"
    # curl -O https://release.larsjung.de/h5ai/h5ai-0.29.0.zip 
    wget --progress=bar:force https://release.larsjung.de/h5ai/h5ai-0.29.0.zip
    unzip h5ai-0.29.0.zip -d ./ | pv -l >/dev/null
    # extract h5ai-0.29.0.zip
    rm -f h5ai-0.29.0.zip
    cd $DOCUMENTROOT
    NEWh5aiINSTALLED=1
  fi

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

if [ $APACHE_IS_INSTALLED -eq 0 ] && [ $NEWh5aiINSTALLED -eq 1 ]; then
  echo -e "${BCyan}>>>${NOCOLOR} ${Blue}Apache Server : Change ${BCyan}DirectoryIndex${NOCOLOR}"
  NEW_DIRINDEX="DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php"

  echo $NEW_DIRINDEX > /etc/apache2/mods-available/dir.conf
  service apache2 restart
fi

if [ $NGINX_IS_INSTALLED -eq 0 ] && [ $NEWh5aiINSTALLED -eq 1 ]; then
  echo ">>> Installing Nginx Server"
  echo ">>> ${BBlue}Nginx Server : Change ${BCyan}Index${NOCOLOR}"
  # nginx 1.2: in nginx.conf set for example:
  # index  index.html  index.php  /_h5ai/server/php/index.php;

  # NEW_DIRINDEX="DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php"
  # sudo NEW_DIRINDEX >> /etc/apache2/mods-available/dir.conf
  # sudo service apache2 restart
fi