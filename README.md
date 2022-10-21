# Finix

Finicking with NixOS. Probably only useful to me. If you find this useful we
should be friends.

## Usage

1. Install Parallels on your Apple Silicon Mac.
2. Create a VM called "Dev" and boot it using an [`aarch64` NixOS
   ISO](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.iso_minimal_new_kernel.aarch64-linux).
3. Set the `root` password to `root` by running `sudo su -` and `passwd` from
   within the VM.
4. Run `make bootstrap` from your Mac to get the VM setup with a base NixOS
   installation.
5. Once rebooted, run `make configure` from your Mac to get the VM set up with
   my personal configuration.
