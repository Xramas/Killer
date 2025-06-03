#!/bin/bash
# i18n.sh - Internationalization Helper

# Determine the script's directory to find the locales folder
# This assumes i18n.sh is in the project root, and locales/ is also in the project root.
SCRIPT_DIR_I18N="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOCALES_DIR="$SCRIPT_DIR_I18N/locales"

# Default language
DEFAULT_LANG="zh_CN"

# Try to get language from environment (LANG, LC_ALL), fallback to default
USER_LANG_FULL="${LANG:-${LC_ALL:-$DEFAULT_LANG}}"
USER_LANG=$(echo "$USER_LANG_FULL" | cut -d. -f1) # Get base like en_US or zh_CN

SELECTED_LANG=""

# Check for full locale match (e.g., zh_CN)
if [[ -f "$LOCALES_DIR/${USER_LANG}.sh" ]]; then
    SELECTED_LANG="$USER_LANG"
# Check for base language match (e.g., en_US -> en)
elif [[ -f "$LOCALES_DIR/${USER_LANG%_*}.sh" ]]; then
    SELECTED_LANG="${USER_LANG%_*}"
else
    SELECTED_LANG="$DEFAULT_LANG" # Fallback to default
fi

# Source the selected language file
if [[ -f "$LOCALES_DIR/${SELECTED_LANG}.sh" ]]; then
    source "$LOCALES_DIR/${SELECTED_LANG}.sh"
else
    # If even the default language file is missing, provide some hardcoded English defaults
    echo "Warning: Language file for '$SELECTED_LANG' or default '$DEFAULT_LANG' not found in $LOCALES_DIR."
    echo "Please ensure locales directory and language files (e.g., en.sh, zh_CN.sh) exist."
    # Define critical messages in English as a last resort
    STR_ERROR_PREFIX="Error:"
    STR_WARNING_PREFIX="Warning:"
    STR_FALLBACK_MESSAGE="Critical error: Language files missing."
    # Add any other absolutely essential fallback strings here if needed
fi

# Helper function to get a string.
# Usage: local my_text=$(_ "SOME_KEY")
# For direct variable usage after sourcing, this function is not strictly needed
# but can be a central point for more complex logic later (e.g., printf formatting).
# For now, scripts will use the STR_VARS directly.
# _() {
#     local key="$1"
#     # Construct the variable name (e.g., STR_SOME_KEY)
#     local var_name="STR_$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr ' ' '_')"
#     if [[ -n "${!var_name}" ]]; then
#         echo -n "${!var_name}"
#     else
#         # Fallback: return the key itself or a placeholder to indicate missing translation
#         echo -n "[$key]"
#     fi
# }
