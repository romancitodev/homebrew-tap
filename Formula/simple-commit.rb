class SimpleCommit < Formula
  desc "A little CLI written in rust to improve your dirty commits into conventional ones. "
  homepage "https://github.com/romancitodev/simple-commits"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/romancitodev/simple-commits/releases/download/v1.0.2/simple-commit-aarch64-apple-darwin.tar.xz"
      sha256 "d9a9668e631a39f1804992150b544007e98270c2fb92cdbd740d99cc9f9b04f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/romancitodev/simple-commits/releases/download/v1.0.2/simple-commit-x86_64-apple-darwin.tar.xz"
      sha256 "a9ae32b62e4c30906dde1ca9605694408d13015c73483715e56172fdaf322333"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/romancitodev/simple-commits/releases/download/v1.0.2/simple-commit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6956326d26cc953ed8faea5553457f687155849d10e42b3e092ef08bbb41db87"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sc"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sc"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
