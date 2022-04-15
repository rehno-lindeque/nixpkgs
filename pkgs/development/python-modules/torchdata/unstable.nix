{ lib
, buildPythonPackage
, fetchFromGitHub

# Propogated build inputs
, pytorch-unstable
, requests

# Check inputs
, pytestCheckHook
# , expecttest
, fsspec
, numpy
, rarfile
# , torchaudio
# , torchtext
# , iopath
}:


buildPythonPackage rec {
  pname = "torchdata-unstable";
  version = "unstable-2022-04-11";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "data";
    rev = "fd942eec986db373f76f521528570bfef2f1d22f";
    sha256 = "sha256:1r7199krybnxxai7cc0hvx5hn4v3sghjfgvcqzscq9rw8hbgz37f";
  };

  propagatedBuildInputs = [
    pytorch-unstable
    requests
  ];

  checkInputs = [
    pytestCheckHook
    # expecttest
    fsspec
    numpy
    rarfile
    # torchaudio
    # torchtext
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
    # FIXME: This test relies on a newer (unstable) version of torchtext
    # "test/test_text_examples.py"
  ];

  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
