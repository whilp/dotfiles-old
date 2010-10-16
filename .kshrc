BOLD=$(tput bold)
UNBOLD=$(tput sgr0)

shorten () {
    typeset LENGTH=$1; shift
    typeset STRING="$*"
    typeset -L "$((${LENGTH} - 4))" NEW="${STRING}^"
    typeset NEWSTRING="${NEW}"
    NEWSTRING="${NEWSTRING%%^ *}"
    NEWSTRING="${NEWSTRING%^}"
    [ "${NEWSTRING}" = "${STRING}" ] || NEWSTRING="${NEWSTRING}..."
    echo "${NEWSTRING}"
}

ps1 () {
    typeset PS1PWD=
    typeset PS1SESSION="${PS1SESSION:-${HOSTNAME}}"
    typeset MAXPS1LEN=$((${MAXPS1LEN:-20} - 5 - ${#PS1SESSION}))
    case "${PWD}" in
        "${HOME}") PS1PWD='~';;
        "${HOME}"/*) PS1PWD='~'"${PWD#${HOME}}";;
        *) PS1PWD="${PWD}";;
    esac

    typeset TILDE=
    if [ -z "${PS1PWD%%~*}" ]; then
        TILDE="~"
        PS1PWD="${PS1PWD#~}"
        MAXPS1LEN=$((${MAXPS1LEN} - 1))
    fi
    typeset LAST="${PS1PWD##*/}"
    typeset TRUNCATE=
    if [ "${#LAST}" -gt "${MAXPS1LEN}" ]; then
        # Truncate.
        typeset -R"$((${MAXPS1LEN} + 1))" TMPLAST="${LAST}"
        TRUNCATE=1
        LAST="${TMPLAST#?}"
    else
        while [ -n "${PS1PWD}" -a "${#LAST}" -lt "${MAXPS1LEN}" ]; do
            PS1PWD="${PS1PWD%/*}"
            LAST="${PS1PWD##*/}/${LAST#/}"
        done
        typeset -R"${MAXPS1LEN}" TMPLAST="${LAST}"
        if [ -n "${PS1PWD}" ]; then
            LAST="${TMPLAST}"
            TRUNCATE=1
        fi
    fi
    if [ -n "${TRUNCATE}" ]; then
        TRUNCATE="${UNBOLD}<${BOLD}"
        TILDE=
    fi
    PS1PWD="${TRUNCATE}${TILDE}${LAST%/}"

    echo -ne "\a${PS1SESSION}:${BOLD}${PS1PWD}${UNBOLD} \$"
}

PS1="\$(ps1) "
export PS1

set -o vi-tabcomplete
