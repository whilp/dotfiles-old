#!/bin/sh -x


MPD_HOST=localhost
MPC_COMMAND=
INCREMENT=7
CURVOL=$(MPD_HOST=${MPD_HOST} mpc volume | sed -e 's/[^0-9]//g')
MINVOL=30
MAXVOL=80
FORMAT="[[%artist% - ]%title%|%name%|%file%]"

if [ $# -eq 0 ]; then
    # Just open ncmpc in a new window
    term -e "ncmpc --host ${MPD_HOST}"
else
    case $1 in
        toggle)
            MPC_COMMAND="toggle >/dev/null 2>&1"
            ;;
        volume)
            MPC_COMMAND="volume $2 >/dev/null 2>&1"
            ;;
        up|down|query)
            # just ignore -- they're special
            ;;
        next)
            MPC_COMMAND="next >/dev/null 2>&1"
            ;;
        prev)
            MPC_COMMAND="prev >/dev/null 2>&1"
            ;;
        *)
            echo "Bad command: $1."
            exit 1
            ;;
    esac
    MPD_HOST=${MPD_HOST} mpc "${MPC_COMMAND}"

    case $1 in
        query)
            MPD_HOST=${MPD_HOST} mpc --format "${FORMAT}"
            ;;
    esac

    # Special tricky slides
    case $1 in
        down)
            while [ ${CURVOL} -gt ${MINVOL} ]; do
                MPD_HOST=${MPD_HOST} mpc volume -${INCREMENT} >/dev/null 2>&1
                CURVOL=$(MPD_HOST=${MPD_HOST} mpc volume | sed -e 's/[^0-9]//g')
            done
            ;;
        up)
            while [ ${CURVOL} -lt ${MAXVOL} ]; do
                MPD_HOST=${MPD_HOST} mpc volume +${INCREMENT} >/dev/null 2>&1
                CURVOL=$(MPD_HOST=${MPD_HOST} mpc volume | sed -e 's/[^0-9]//g')
            done
            ;;
        slide)
            INC=1
            # The modulo bits are intended to smooth the slide;
            # there may be a better method, but it seems rather
            # efficient to do it this way.
            if [ ${CURVOL} -gt 50 ]; then
                while [ ${CURVOL} -gt ${MINVOL} ]; do
                    # Slide down
                    MPD_HOST=${MPD_HOST} mpc volume -${INC} >/dev/null 2>&1
                    CURVOL=$(MPD_HOST=${MPD_HOST} mpc volume | sed -e 's/[^0-9]//g')
                    if [ $((INC % 2)) -eq 0 ]; then
                        INC=$((INC + 1))
                    fi
                done
            else
                while [ ${CURVOL} -lt ${MAXVOL} ]; do
                    # Slide up
                    MPD_HOST=${MPD_HOST} mpc volume +${INC} >/dev/null 2>&1
                    CURVOL=$(MPD_HOST=${MPD_HOST} mpc volume | sed -e 's/[^0-9]//g')
                    if [ $((INC % 2)) -eq 0 ]; then
                        INC=$((INC + 1))
                    fi
                done
            fi
            ;;
    esac
fi

