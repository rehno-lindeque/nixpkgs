{ lib
, buildPythonPackage
, fetchFromGitHub

# Native build inputs
, poetry-core

# Check inputs
, python
, hypothesis
}:

buildPythonPackage rec {
  pname = "expecttest";
  version = "0.1.3";
  format = "pyproject";

  # Pypi doesn't contain the test, so fetch from GitHub
  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "expecttest";
    rev = "4be7413c98b4c6bdb4b26bfc8358c0a909c8d675";
    sha256 = "sha256:051bffhfii5vqhfpgvcl5hkbj7c24p4j93hggmhf5k92rfdcd16i";
  };

  nativeBuildInputs = [ poetry-core ];

  checkInputs = [ hypothesis ];

  checkPhase = "${python.interpreter} test_expecttest.py";

  pythonImportsCheck = [ "expecttest" ];

  meta = with lib; {
    description = ''This library implements expect tests (also known as "golden" tests).'';
    homepage = "github.com/ezyang/expecttest";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
  };
}
