{ lib
, buildPythonPackage
, fetchFromGitHub

# # Propogated build inputs
# , pytorch
# , requests

# # Check inputs
# , pytestCheckHook
# , expecttest
# , fsspec
# , numpy
# , rarfile
# , torchaudio
# , torchtext
# # , iopath

# FIXME: unstable version overrides
, python39
}:

with (python39.override {
  packageOverrides = python-self: python-super: {
    pytorch =
      python-super.pytorch.overridePythonAttrs (oldAttrs: rec {
        version = "1.11.0-rc2";
        src = fetchFromGitHub {
          owner = "pytorch";
          repo = "pytorch";
          rev = "v${version}";
          fetchSubmodules = true;
          sha256 = "sha256:0c50jvzdb6g9428in7b2rc1h8h7qx80r5rjzki2aa0wbxarp612z";
        };
      });
  };
}).pkgs;


buildPythonPackage rec {
  pname = "torchdata";
  version = "0.3.0a1-e86cedc";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "data";
    # rev = "v${version}";
    rev = "e86cedc5ffd024ea293f541fc77e8a3b4856c8c9"; # git branch release/0.3.0
    sha256 = "sha256:06gk7pqk2dbkxmaskycvvwyzhapbl5dr2r1v2vswdi6yx5iqzcwa";
  };

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
    "test_gdrive_iterdatapipe"
    "test_online_iterdatapipe"
    "test_http_reader_iterdatapipe"
    "test_on_disk_cache_holder_iterdatapipe"
  ];

  disabledTestPaths = [
    # FIXME: This test relies on a newer (unstable) version of torchtext
    "test/test_text_examples.py"
  ];

  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
    broken = true; # FIXME: relies on an unstable version of pytorch
  };
}
