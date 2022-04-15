{ lib
, stdenv
, fetchFromGitHub
, makeWrapper

# Required
, hwinfo
, dmidecode
, smartmontools
, pciutils
, usbutils
, edid-decode

# Recommended
, withRecommended ? false # Install recommended tools
, mcelog
, hdparm
, systemd
, acpica-tools
, drm_info
, mesa-demos
, memtester
, sysstat
, cpuid
, util-linuxMinimal
, xinput
, libva-utils
, inxi
, vulkan-utils
, i2c-tools
, opensc

# Suggested
, withSuggested ? false # Install (most) suggested tools
, hplip
, sane-backends
, pnputils ? null # pnputils (lspnp) isn't currently in nixpkgs and appears to be poorly maintained
}:

stdenv.mkDerivation rec {
  pname = "hw-probe";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = pname;
    rev = version;
    sha256 = "sha256:028wnhrbn10lfxwmcpzdbz67ygldimv7z1k1bm64ggclykvg5aim";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  makeWrapperArgs =
    let
      requiredPrograms = [
        hwinfo
        dmidecode
        smartmontools
        pciutils
        usbutils
        edid-decode
      ];
      recommendedPrograms = [
        mcelog
        hdparm
        systemd # (systemd-analyze)
        acpica-tools
        drm_info
        mesa-demos
        memtester
        sysstat # (iostat)
        cpuid
        util-linuxMinimal # (rfkill)
        xinput
        libva-utils # (vainfo)
        inxi
        vulkan-utils
        i2c-tools
        opensc
      ];
      suggestedPrograms = [
        hplip # (hp-probe)
        sane-backends # (sane-find-scanner)
        pnputils # (lspnp)
      ];
      programs =
        requiredPrograms
        ++ lib.optionals withRecommended recommendedPrograms
        ++ lib.optionals withSuggested suggestedPrograms;
    in [
      "--prefix" "PATH" ":" "${lib.makeBinPath programs}"
    ];

  postInstall = ''
    wrapProgram $out/bin/hw-probe \
      $makeWrapperArgs
  '';

  meta = with lib; {
    description = "Probe for hardware, check operability and find drivers";
    homepage = "github.com/linuxhw/hw-probe";
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
    license = [ licenses.lgpl21 licenses.bsdOriginal ];
    maintainers = with maintainers; [  ];
  };
}
