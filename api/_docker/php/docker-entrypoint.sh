#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'bin/console' ]; then
  # Add any other folders that your web application needs to create here
  mkdir -p var/cache var/sessions var/log var/uploads config/jwt

	if [ "$APP_ENV" != 'prod' ]; then
	  # local filesystem mounts after install in Dockerfile so run again here
	  composer install --prefer-dist --no-progress --no-suggest --no-interaction

	  # Check bin/console is executable now because the file should definitely exist
    chmod +x bin/console

		# Uncomment the following line if you are using Symfony Encore
		#yarn run watch
  else
    composer run-script --no-dev post-install-cmd
    php bin/console doctrine:fixtures:load --no-interaction
		# Uncomment the following line if you are using Symfony Encore
		#yarn run build
	fi

	if [ ! -f $JWT_PRIVATE_KEY_PATH ]; then
    openssl genrsa -out $JWT_PRIVATE_KEY_PATH -aes256 -passout pass:$JWT_PASSPHRASE 4096
    openssl rsa -passin pass:$JWT_PASSPHRASE -pubout -in $JWT_PRIVATE_KEY_PATH -out $JWT_PUBLIC_KEY_PATH
  fi

	# Permissions hack because setfacl does not work on Mac and Windows
	# Add any other paths that your web application may need to write to
	chown -R www-data var config
fi

exec docker-php-entrypoint "$@"
