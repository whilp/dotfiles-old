#!/bin/sh

case ${SSH_ORIGINAL_COMMAND} in
    *[\;\&]*)
        echo "Connection refused."
        ;;
    *\|\|*)
        echo "Connection refused."
        ;;
    rsync*)
        sudo ${SSH_ORIGINAL_COMMAND}
        ;;
    *)
        echo "Connection refused."
        ;;
esac
