class Guma < Formula
  desc "A parallel disk analyser for macOS, for when System Data is 170 GB and About This Mac will not say why"
  homepage "https://github.com/GarroshIcecream/guma"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GarroshIcecream/guma/releases/download/v0.1.1/guma-aarch64-apple-darwin.tar.xz"
      sha256 "b1f563083b2084ffabb461de1bb681fabb0ac2eeedfba515686fe033232847a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GarroshIcecream/guma/releases/download/v0.1.1/guma-x86_64-apple-darwin.tar.xz"
      sha256 "557225ac68aa709674b04171bc181935d0b5b448976eef3fed1ce4f678eb2ae9"
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
