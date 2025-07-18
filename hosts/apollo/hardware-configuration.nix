# Hardware configuration for Apollo (Beelink SER8)
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "amdgpu"
  ];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd" "amdgpu"];
  boot.extraModulePackages = [];

  # Enable early KMS (Kernel Mode Setting) for AMD GPU - already configured above
  boot.kernelParams = [
    # AMD GPU specific parameters for SER8 (Radeon 780M)
    "amdgpu.dc=1"
    "amdgpu.gpu_recovery=1"
    "amdgpu.runpm=0" # Disable runtime power management to prevent glitches
    "amdgpu.dpm=1" # Enable dynamic power management
    # SER8 specific optimizations
    "amdgpu.ppfeaturemask=0xffffffff" # Enable all power features
    "amdgpu.exp_hw_support=1" # Enable experimental hardware support for newer GPUs
    # Memory and IOMMU settings for SER8
    "amd_iommu=on" # Enable IOMMU for SER8 (newer hardware handles this better)
    "iommu=pt" # Use passthrough mode for better performance
  ];

  # CPU configuration
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD GPU drivers
      amdvlk
      rocmPackages.clr.icd
      # Mesa drivers
      mesa.drivers
      # Video acceleration
      libvdpau-va-gl
      vaapiVdpau
      # Additional AMD support
      libva
      libva-utils
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      amdvlk
      mesa.drivers
    ];
  };

  # Video drivers
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable firmware updates
  hardware.enableRedistributableFirmware = true;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # Networking
  networking.useDHCP = lib.mkDefault true;
}
