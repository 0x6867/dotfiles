Disko Quickstart:

lsblk #for finding name of system disk

cd /tmp
git clone https://0x6867/dotfiles

vi disk-config.nix #check disk name matches lsblk output

echo "thisisasecret" > /tmp/secret.key

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix

mount | grep /mnt #check it worked

nixos-generate-config --no-filesystems --root /mnt #maybe not necessary

mv /tmp/disk-config.nix /mnt/etc/nixos
#copy other files from repo into /mnt/etc/nixos such flake home and config

nix --experimental-features "nix-command flakes" check flake #Check it's working before running nixos-install

nixos-install --flake /mnt/etc/nixos#desktop-nix


