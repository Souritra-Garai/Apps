#!/usr/bin/bash

# This script sets up the environment
# to find binaries and libraries in the Apps directory.

append_pathvar() {
	local var_name="$1"
	local new_value="$2"
	# Check if the new value is not in the variable
	if [[ ":${!var_name}:" != *":$new_value:"* ]]; then
		# Append the new value to the variable
		export "$var_name=${!var_name:+${!var_name}:}$new_value"
	fi
}

prepend_pathvar() {
	local var_name="$1"
	local new_value="$2"
	# Check if the new value is not in the variable
	if [[ ":${!var_name}:" != *":$new_value:"* ]]; then
		# Prepend the new value to the variable
		export "$var_name=$new_value${!var_name:+:${!var_name}}"
	fi
}

store_old_env() {
	local var_name="$1"
	local old_var_name="_OLD_$var_name"
	# Check if the old variable does not already exist
	if [ -z "${!old_var_name+x}" ]; then
		# Store the current value of the variable
		export "$old_var_name=${!var_name}"
	fi
}

restore_old_env() {
	local var_name="$1"
	local old_var_name="_OLD_$var_name"
	# Check if the old variable exists and is not empty
	if [ -n "${!old_var_name+x}" ]; then
		# If it is set, restore its value
		export "$var_name=${!old_var_name}"
		unset "$old_var_name"
	else
		# Otherwise, unset the variable
		unset "$var_name"
	fi
}

# Store current values of environment variables, if not already stored
store_old_env PATH
store_old_env LD_LIBRARY_PATH
store_old_env C_INCLUDE_PATH
store_old_env CPLUS_INCLUDE_PATH
store_old_env PKG_CONFIG_PATH
store_old_env MANPATH

deactivate_apps() {
	restore_old_env PATH
	restore_old_env LD_LIBRARY_PATH
	restore_old_env C_INCLUDE_PATH
	restore_old_env CPLUS_INCLUDE_PATH
	restore_old_env PKG_CONFIG_PATH
	restore_old_env MANPATH

	unset -f prepend_pathvar
	unset -f append_pathvar
	unset -f deactivate_apps
}

APPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

prepend_pathvar PATH "$APPS_DIR/bin"
prepend_pathvar LD_LIBRARY_PATH "$APPS_DIR/lib"

append_pathvar C_INCLUDE_PATH "$APPS_DIR/include"
append_pathvar CPLUS_INCLUDE_PATH "$APPS_DIR/include"
append_pathvar PKG_CONFIG_PATH "$APPS_DIR/lib/pkgconfig"

prepend_pathvar MANPATH "$APPS_DIR/share/man"

unset APPS_DIR
