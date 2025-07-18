{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.amd-optimization;
in {
  options.amd-optimization = {
    enable = mkEnableOption "Enable AMD optimizations";
    cpu = {
      updateMicrocode = mkOption {
        type = types.bool;
        default = true;
        description = "Update AMD CPU microcode";
      };
      coreCount = mkOption {
        type = types.int;
        default = 32;
        description = "Number of CPU cores for optimization";
      };
    };
    gpu = {
      enable = mkEnableOption "Enable AMD GPU optimizations";
    };
  };

  config = mkIf cfg.enable {
    # AMD Ryzen optimizations
    hardware.cpu.amd.updateMicrocode = cfg.cpu.updateMicrocode;

    # Enable AMD-specific kernel modules and optimizations
    boot.kernelModules = ["kvm-amd" "amd_pstate"] ++ (optionals cfg.gpu.enable ["amdgpu"]);
    boot.kernelParams =
      [
        "amd_pstate=active"
        "processor.max_cstate=5"
        "rcu_nocbs=0-${toString (cfg.cpu.coreCount - 1)}" # Adjust based on your core count
      ]
      ++ (optionals cfg.gpu.enable [
        "amdgpu.ppfeaturemask=0xffffffff" # Enable all power features for AMD GPU
        "amdgpu.dc=1" # Enable Display Core for better display support
        "amdgpu.gpu_recovery=1" # Enable GPU recovery
      ]);

    # Enable CPU frequency scaling with optimized settings
    services.thermald.enable = true;
    powerManagement = {
      cpuFreqGovernor = "performance";
      powertop.enable = true;
    };

    # AMD GPU optimizations
    services.xserver.videoDrivers = mkIf cfg.gpu.enable ["amdgpu"];
    hardware.graphics = mkIf cfg.gpu.enable {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # AMD GPU drivers and libraries
        amdvlk
        rocmPackages.clr.icd
        # OpenGL and Vulkan support
        mesa.drivers
        # Video acceleration
        libvdpau-va-gl
        vaapiVdpau
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        amdvlk
        mesa.drivers
      ];
    };
  };
}
