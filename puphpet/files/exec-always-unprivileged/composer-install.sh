#!/usr/bin/env bash

echo -e "${YELLOW}${BLightGrey}<<< ::: COMPOSER PACKAGES INSTALLATION ::: >>>${NOCOLOR}"

# Composer Parameters
# List any global Composer packages that you want to install

exit 0;

COMPOSER_PACKAGES=(
    "phpunit/phpunit=^8.0"
    # "codeception/codeception=^2.6@dev"
    "phpspec/phpspec=^5.1"
    "squizlabs/php_codesniffer=^3.4"
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
        echo "$((i+1)): ${COMPOSER_PACKAGES[i]}"
        
        # Add Composer's Global Bin to ~/.bash_profile path
        if [[ -f "/home/vagrant/.bash_profile" ]]; then
            if ! grep -qsc 'COMPOSER_HOME=' /home/vagrant/.bash_profile; then
                # Ensure COMPOSER_HOME variable is set. This isn't set by Composer automatically
                printf "\n\nCOMPOSER_HOME=\"/home/vagrant/.composer\"" >> /home/vagrant/.bash_profile
                # Add composer home vendor bin dir to PATH to run globally installed executables
                printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:$COMPOSER_HOME/vendor/bin' >> /home/vagrant/.bash_profile

                # Source the .bash_profile to pick up changes
                . /home/vagrant/.bash_profile
            fi
        fi

        if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer global require ${COMPOSER_PACKAGES[i]} --no-progress
        else
            sudo chmod -R 777 ~/.composer/
            composer global require ${COMPOSER_PACKAGES[i]} --no-progress
        fi
    fi

done

echo -e "${yellow}${BBlue}[SUCCESS] Composer install packages. Well done ;-)${NOCOLOR}"
exit 0