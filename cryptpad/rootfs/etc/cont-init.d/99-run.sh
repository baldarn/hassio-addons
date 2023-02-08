#!/usr/bin/env bashio
# shellcheck shell=bash

# CPAD_MAIN_DOMAIN	CryptPad main domain FQDN	Yes	None
# CPAD_SANDBOX_DOMAIN	CryptPad sandbox subdomain FQDN	Yes	None
# CPAD_API_DOMAIN	CryptPad API subdomain FQDN	No	$CPAD_MAIN_DOMAIN
# CPAD_FILES_DOMAIN	CryptPad files subdomain FQDN	No	$CPAD_MAIN_DOMAIN
# CPAD_TRUSTED_PROXY	Trusted proxy address or CIDR	No	None
# CPAD_REALIP_HEADER	Header to get client IP from (X-Real-IP or X-Forwarded-For)	No	X-Real-IP
# CPAD_REALIP_RECURSIVE	Instruct Nginx to perform a recursive search to find client's real IP (on/off) (see ngx_http_realip_module)	No	off
# CPAD_TLS_CERT	Path to TLS certificate file	No	None
# CPAD_TLS_KEY	Path to TLS private key file	No	None
# CPAD_TLS_DHPARAM	Path to Diffie-Hellman parameters file	No	/etc/nginx/dhparam.pem
# CPAD_HTTP2_DISABLE

CPAD_TLS_CERT="/ssl/$(bashio::config 'certfile')" "$file"
CPAD_TLS_KEY="/ssl/$(bashio::config 'keyfile')" "$file"

##################
# ADAPT DOMAIN #
##################

if bashio::config.true 'CPAD_MAIN_DOMAIN'; then
    bashio::log.blue "CPAD_MAIN_DOMAIN set, using value : $(bashio::config 'CPAD_MAIN_DOMAIN')"
else
    CPAD_MAIN_DOMAIN="$PROTOCOL://$(bashio::config 'DOMAIN'):$(bashio::addon.port 3000)"
    bashio::log.blue "CPAD_MAIN_DOMAIN not set, using extrapolated value : $CPAD_MAIN_DOMAIN"
    sed -i "/server/a CPAD_MAIN_DOMAIN=$CPAD_MAIN_DOMAIN" "$file"
fi

##################
# ADAPT SANDBOX_DOMAIN #
##################

if bashio::config.true 'CPAD_SANDBOX_DOMAIN'; then
    bashio::log.blue "CPAD_SANDBOX_DOMAIN set, using value : $(bashio::config 'CPAD_SANDBOX_DOMAIN')"
else
    CPAD_SANDBOX_DOMAIN="$PROTOCOL://$(bashio::config 'SANDBOX_DOMAIN'):$(bashio::addon.port 3001)"
    bashio::log.blue "CPAD_SANDBOX_DOMAIN not set, using extrapolated value : $CPAD_SANDBOX_DOMAIN"
    sed -i "/server/a CPAD_SANDBOX_DOMAIN=$CPAD_SANDBOX_DOMAIN" "$file"
fi

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./usr/bin/entrypoint
