SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY = bootstrap copy configure test switch

bootstrap:
	ssh $(SSH_OPTIONS) root@dev " \
		parted /dev/sda -- mklabel gpt; \
		parted /dev/sda -- mkpart primary 512MiB -8GiB; \
		parted /dev/sda -- mkpart primary linux-swap -8GiB 100\%; \
		parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/sda -- set 3 esp on; \
		mkfs.ext4 -L nixos /dev/sda1; \
		mkswap -L swap /dev/sda2; \
		mkfs.fat -F 32 -n boot /dev/sda3; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixUnstable;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
  			services.openssh.enable = true;\n \
			services.openssh.passwordAuthentication = true;\n \
			services.openssh.permitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd; \
		reboot; \
	"

copy:
	rsync \
		--archive \
		--verbose \
		--rsh='ssh $(SSH_OPTIONS)' \
		--exclude='.git/' \
		. root@dev:/nix-config

configure: copy
	ssh $(SSH_OPTIONS) root@dev 'nixos-rebuild switch --flake "/nix-config#dev"; reboot'

test:
	sudo nixos-rebuild test --flake ".#dev"

switch:
	sudo nixos-rebuild switch --flake ".#dev"
