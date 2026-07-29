class Guma < Formula
  desc "A parallel disk analyser for macOS, for when System Data is 170 GB and About This Mac will not say why"
  homepage "https://github.com/GarroshIcecream/guma"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GarroshIcecream/guma/releases/download/v0.2.0/guma-aarch64-apple-darwin.tar.xz"
      sha256 "1fcbea2bc4c1216b6aeaf533053d5d9b539153db5bb6cb78ac7d865dffb9e5f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GarroshIcecream/guma/releases/download/v0.2.0/guma-x86_64-apple-darwin.tar.xz"
      sha256 "7df8f8b88d0b40c688b1d07108ee60981141682f6de325b7bf2d804f782352c8"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

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
    bin.install "guma" if OS.mac? && Hardware::CPU.arm?
    bin.install "guma" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
