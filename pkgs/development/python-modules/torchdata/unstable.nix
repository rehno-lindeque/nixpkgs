{ lib
, buildPythonPackage
, fetchFromGitHub

# Propogated build inputs
, pytorch
, requests

# Check inputs
, pytestCheckHook
, expecttest
, fsspec
, numpy
, rarfile
, torchaudio
, torchtext
# , iopath

# Native build inputs
, aws-sdk-cpp
, pybind11
, cmake
, ninja

# Flags
, useSystemLibs ? true
}:


let
  version = "0.4.0";
  date = "2022-04-21";
  setBool = v: if v then "1" else "0";
  aws-sdk-cpp-s3-transfer = (aws-sdk-cpp.override {
    apis = ["s3" "transfer"];
    customMemoryManagement = false;
  }).overrideAttrs (oldAttrs: {

    # Fixes downstream issue with dependent CMake configuration
    # See https://github.com/NixOS/nixpkgs/issues/70075#issuecomment-1019328864
    postPatch = oldAttrs.postPatch + ''
      substituteInPlace cmake/AWSSDKConfig.cmake \
        --replace "\''${AWSSDK_DEFAULT_ROOT_DIR}/\''${AWSSDK_INSTALL_INCLUDEDIR}" "\''${AWSSDK_INSTALL_INCLUDEDIR}"
    '';

  });
in
buildPythonPackage {
  pname = "torchdata-unstable";
  version = "${version}-${date}";
  format = "setuptools";

  src = fetchFromGitHub ({
    owner = "pytorch";
    repo = "data";
    rev = "6da391e3d342248a6005c74c61499a3209bda010";
    sha256 = "sha256:0vdq7mqgbj50xs1plwrwypj6b12ij94g3fwccbqnpjkjdj7kz75h";
  } // lib.optionalAttrs (!useSystemLibs) {
    sha256 = "sha256:1ijjm47hpdzr6s8nzw8l9scwwgdfbkicg90vj4gmc6lzm65n6bq5";
    fetchSubmodules = true;
  });

  dontUseCmakeConfigure = true; # Allow setup.py to take care of configure

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    aws-sdk-cpp-s3-transfer
    pybind11
  ];

  # See https://github.com/pytorch/data/tree/main/torchdata/datapipes/iter/load#readme for AWS integration
  BUILD_S3 = setBool true; # This will ship with torchdata releases in future
  USE_SYSTEM_LIBS = setBool useSystemLibs;

  propagatedBuildInputs = [
    pytorch
    requests
  ];

  checkInputs = [
    pytestCheckHook
    expecttest
    fsspec
    numpy
    rarfile
    torchaudio
    torchtext
    # iopath
  ];

  disabledTests = [
    # Tests that require network access
    # "test_gdrive_iterdatapipe"
    # "test_online_iterdatapipe"
    # "test_http_reader_iterdatapipe"
    # "test_on_disk_cache_holder_iterdatapipe"
  ];

  disabledTestPaths = [
  ];

  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
