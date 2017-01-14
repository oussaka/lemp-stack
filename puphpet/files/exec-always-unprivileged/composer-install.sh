#!/usr/bin/env bash

echo -e "${YELLOW} \e[1m <<< ::: COMPOSER PACKAGES INSTALLATION ::: >>>"
# Composer Parameters
# List any global Composer packages that you want to install
COMPOSER_PACKAGES=(
	"phpunit/phpunit=^5.4.0" 
	"codeception/codeception=~2.2.7" 
	"phpspec/phpspec=~3.2.2" 
	"squizlabs/php_codesniffer:2.7.1" 
)
GITHUB_TOKEN="3b4abe53acc7164ffd79ce8744b8e6dd7071b785"

# chmod +x ./composer.sh

echo -e "${NOCOLOR}"
# /bin/bash ./composer.sh $GITHUB_TOKEN "${COMPOSER_PACKAGES[@]}"


# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?
# exit 0;


[[ $HHVM_IS_INSTALLED -ne 0 && $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP/HHVM is not installed.\n    Installing Composer aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# Getting the arguments
GITHUB_OAUTH=$1

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
    echo ">>> Installing Composer"
    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        # Install Composer
        sudo wget --quiet https://getcomposer.org/installer
        hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 installer
        sudo mv composer.phar /usr/local/bin/composer
        sudo rm installer

        # Add an alias that will allow us to use composer without timeout's
        printf "\n# Add an alias for sudo\n%s\n# Use HHVM when using Composer\n%s" \
        "alias sudo=\"sudo \"" \
        "alias composer=\"hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer\"" \
        >> "/home/vagrant/.profile"

        # Resource .profile
        # Doesn't seem to work do! The alias is only usefull from the moment you log in: vagrant ssh
        . /home/vagrant/.profile
    else
        # Install Composer
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
    fi
else
    echo ">>> Updating Composer"

    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        sudo hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer self-update
    else
        sudo composer self-update
    fi
fi

if [[ $GITHUB_OAUTH != "" ]]; then
    if [[ ! $COMPOSER_IS_INSTALLED -eq 1 ]]; then
        echo ">>> Setting Github Personal Access Token"
        composer config -g github-oauth.github.com $GITHUB_OAUTH
    fi
fi

# Install Global Composer Packages if any are given
for i in `seq 0 $(( ${#COMPOSER_PACKAGES[@]} ))` ; do
    if [[ ${COMPOSER_PACKAGES[i]} != "" ]]; then

        echo ">>> Installing Global Composer Packages:"
        echo "$i: ${COMPOSER_PACKAGES[i]}"
        
        # Add Composer's Global Bin to ~/.profile path
        if [[ -f "/home/vagrant/.profile" ]]; then
            if ! grep -qsc 'COMPOSER_HOME=' /home/vagrant/.profile; then
                # Ensure COMPOSER_HOME variable is set. This isn't set by Composer automatically
                printf "\n\nCOMPOSER_HOME=\"/home/vagrant/.composer\"" >> /home/vagrant/.profile
                # Add composer home vendor bin dir to PATH to run globally installed executables
                printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:$COMPOSER_HOME/vendor/bin' >> /home/vagrant/.profile

                # Source the .profile to pick up changes
                . /home/vagrant/.profile
            fi
        fi

        if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer global require ${COMPOSER_PACKAGES[i]}
        else
            sudo chmod -R 777 ~/.composer/
            composer global require ${COMPOSER_PACKAGES[i]}
        fi
    fi

done

echo -e "${GREEN}[SUCCESS] Composer install packages. Well done ;-)"
echo -e "${NOCOLOR}"
exit 0