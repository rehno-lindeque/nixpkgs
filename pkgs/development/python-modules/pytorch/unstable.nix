{fetchFromGitHub, pytorch, cudaSupport}:

(pytorch.override { inherit cudaSupport; }).overridePythonAttrs {
  pname = "pytorch-version";
  version = "unstable-2022-04-13";
  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "4afe2db641c526800fb8b33532a920be625f3cf4";
    fetchSubmodules = true;
    sha256 = "sha256-CEu63tdRBAF8CTchO3Qu8gUNObQylX6U08yDTI4/c/0=";
  };
}
