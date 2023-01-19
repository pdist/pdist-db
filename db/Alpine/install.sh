
$bin=$(which start-alpine)
work_dir="~/.cache/pdist"
sitfs="~/.local/share/pdist/alpine"
LATEST="v3.17.0"
rm -rf $work_dir
mkdir -p $work_dir
case `dpkg --print-architecture` in
		aarch64)
			arch="arm64" ;;
		arm)
			arch="armhf" ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac
		echo "Get File"
		cd $work_dir; curl -LO https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$arch/alpine-minirootfs-3.17.0-$arch.tar.gz
		echo "Extract FS"
		rm -rf $sitfs; mkdir -p $sitfs; cd $sitfs
		proot --link2symlink tar -xf ${cur}/${tarball} --exclude='dev' 2> /dev/null||:
		echo "Get Launch Script"
		cd /data/data/com.termux/files/usr/bin
		cp ~/.local/share/pdist/db/Alpine/start-alpine -r /data/data/com.termux/files/usr
		echo "Setup Alpine For First Time"
		cd $sitfs/etc
		echo "nameserver 1.1.1.1" > resolv.conf
		echo "nameserver 8.8.8.8" >> resolv.conf
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash apk update
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash apk add shadow
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash adduser user
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash passwd user
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash usermod -aG wheel user
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash apk add sudo
		proot --link2symlink -0 -r $sitfs -b /dev -b /proc -b /sys /bin/ash usermod -aG sudo user
		echo "Done"
		termux-fix-shebang $bin
		chmod +x $bin
		echo "You can now start alpine using start-alpine command"