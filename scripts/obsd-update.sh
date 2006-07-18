#!/bin/sh
# Set a PKG_PATH, unless there is one already.

if [ ! $1 ]; then
	echo "'$0 pre' to prepare and run the upgrade or"
	echo "'$0 post' to clean up and merge"
	exit 1
fi

MY_PP=ftp://ftp5.usa.openbsd.org/pub/OpenBSD/snapshots/packages/i386/:ftp://mirrors.tds.net/pub/OpenBSD/snapshots/packages/i386/
PKG_PATH=${PKG_PATH:-${MY_PP}}
VERSION=39
WORKDIR="${HOME}/BSD"
BACKUPDIR=/home/backup
EXCLUDE_RE="/var/space"

case "x$1" in
   xpre)

	# Fetch installsets.
	mkdir "${WORKDIR}" 2>/dev/null
	cd "${WORKDIR}"
	ftp ${PKG_PATH%%packages*}/$(machine)/\*

	# Backup /bsd and /bsd.rd; prepare to upgrade.
	sudo cp /bsd /bsd.old
	sudo cp /bsd.rd /bsd.rd.old
	sudo cp bsd.rd /bsd.rd
	echo sudo ln -f /bsd.rd /bsd        # In case the thing doesn't want to boot from bsd.rd.

	# Reboot into the upgrade process. Follow the instructions (like an
	# install).
	echo sudo shutdown -r now
	exit
	;;
   xpost)
	# Boot into the new system and update packages.
	echo sudo pkg_add -iu

	# Backup and merge changes to /etc, /var and /root (which aren't
	# covered by the upgrade process). I think /dev is covered by the
	# install process.
	cd "${WORKDIR}"
	mkdir merge 2>/dev/null
	tar xvzf "etc${VERSION}.tgz" -C merge/

        set -x
	sudo mkdir "${BACKUPDIR}" 2>/dev/null
	DIRS="etc var root"
	for DIR in ${DIRS}; do
	    sudo sh -c "tar cvzf \"${BACKUPDIR}/${DIR}-$(date "+%Y%m%d-%H%M%S").tgz\" \
                $(find /${DIR} -maxdepth 1 -mindepth 1 | grep -vE "${EXCLUDE_RE}")"
	    #sudo tar cvzf "${BACKUPDIR}/${DIR}-$(date "+%Y%m%d-%H%M%S").tgz" "/${DIR}"
	done
        set +x

        # Prepare to merge.
        echo "===> We're about to merge changes to /etc, /var/, and /root."
        echo "===> Remove files from ${WORKDIR}/merge now to avoid useless"
        echo "===> merging (eg var/www/htdocs/...)."
        echo "===> Press [Enter] to continue."
        read RESPONSE

	# Merge changes.
	sudo pkg_add mergemaster
	sudo IGNORE_MOTD=yes mergemaster -rt "${WORKDIR}/merge"

	# Rebuild the password databases (/etc/pwd.db and /etc/spwd.db).
	# sudo pwd_mkdb /etc/master.passwd
	;;
esac
