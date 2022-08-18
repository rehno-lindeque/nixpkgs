# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.12.1" = {
    x86_64-linux-37 = {
      name = "torch-1.12.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.12.1%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-2HR9fYrdYiE62yzPDhQ6qTZNHhbH5LzfReMCvIRAQ2g=";
    };
    x86_64-linux-38 = {
      name = "torch-1.12.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.12.1%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-St9IOsLQR1NKfQI/ACK9hpTYdicGitbd3xhssyc7v6I=";
    };
    x86_64-linux-39 = {
      name = "torch-1.12.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.12.1%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-AYVIBpc4QL3z/A78hIEVOcs3EBr9ZJjvJKfX8a88sBA=";
    };
    x86_64-linux-310 = {
      name = "torch-1.12.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.12.1%2Bcu113-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-vmgu+U43zT8HaLjOYQZwVBAYnfLDZdZde8G+uzAthM0=";
    };
    x86_64-darwin-37 = {
      name = "torch-1.12.1-cp37-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp37-none-macosx_10_9_x86_64.whl";
      hash = "sha256-ijSi+7qgfJIeGyA/WdPW4A7TefKzhERXc70U4yiltsg=";
    };
    x86_64-darwin-38 = {
      name = "torch-1.12.1-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-qDILqa2H6AylpqAW5GraTRugxUYm4TXZmyEppFQcUJ0=";
    };
    x86_64-darwin-39 = {
      name = "torch-1.12.1-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-v+woQ9qmVPBP2iO6gjrwPntvdlCoc823JnUtDjcY2to=";
    };
    x86_64-darwin-310 = {
      name = "torch-1.12.1-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-l2w/mXzqOO6RoN08OkIyJ4VBR0jRdh75JreJ36l8YTQ=";
    };
    aarch64-darwin-38 = {
      name = "torch-1.12.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-A+McN3Edss0gHgLeWCbeh1Up5FpVYx0xeq3OLx7UWqg=";
    };
    aarch64-darwin-39 = {
      name = "torch-1.12.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-af4srnw5zK3WWhI3k9MODbiB8cGSeUVRnFwXMjExQ34=";
    };
    aarch64-darwin-310 = {
      name = "torch-1.12.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.12.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-aBBORxWlXEuymoXGqNV9gg4HV9o2O+G6aA+ozFvhe1I=";
    };
  };
}
