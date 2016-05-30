#!/usr/bin/env bash

default_cert_import_path=/mnt-ssh-config/cert

read -p "File path to import ($default_cert_import_path): " file
test "$file" || file="$default_cert_import_path"
test -r "$file" && test -f "$file" || { echo "File not found: '$file'"; exit 1 ;}
until test "$alias"; do read -p 'Type an alias for the certificate: ' alias; done
exec keytool -import -alias "$alias" -keystore "$JAVA_HOME"/jre/lib/security/cacerts -file "$file"