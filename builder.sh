source $stdenv/setup

echo "setting up network..."
modprobe virtio_net
ip link set eth0 up
ip addr add 10.0.0.10/24 dev eth0
ip route add default via 10.0.0.2 # gateway provided by qemu
echo "nameserver 10.0.0.3" > /etc/resolv.conf # dns server provided by qemu

echo "mounting httpdirfs..."
modprobe fuse
httpMount=$(mktemp -d)
httpdirfs --single-file-mode "$isoUrl" "$httpMount"

isoFile=$(ls "$httpMount")

echo "mounting iso..."
modprobe loop
loopDev=$(losetup -f --show "$httpMount/$isoFile")
isoMount=$(mktemp -d)
mount -t udf "$loopDev" "$isoMount"

echo "extracting fonts..."
mkdir -p "$out/share/fonts/$version"
7z e -o"$out/share/fonts/$version" "$isoMount/sources/install.wim" Windows/Fonts/"*".{ttf,ttc}
