class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/omarchy"
  version "0.2.6"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.6/ted-Darwin-arm64.tar.gz"
      sha256 "fc7140bdff0d4f8bb5511f7c4efb97ea740a2185224fe2ad990f7aebcb8b2583"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.6/ted-Darwin-x86_64.tar.gz"
      sha256 "b568e3dbad6302a7323c9f734af3ca85b2c26cb2db46c179f3c6832e13fa70ec"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.6/ted-Linux-x86_64.tar.gz"
      sha256 "9dacdff28eb5d932a852a73611dac3e0291fcdf1b8f1993d5114a8ad2e472278"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "glib"
    depends_on "patchelf" => :build
    depends_on "wayland"
  end

  def install
    if OS.mac?
      # Homebrew may strip the single top-level archive directory.
      bundle = prefix/"ted.app"
      if File.directory?("ted.app")
        prefix.install "ted.app"
      else
        bundle.install "Contents"
      end
      bin.mkpath
      cp bundle/"Contents/MacOS/ted", bin/"ted"
    else
      bin.install "ted"
      system "patchelf", "--set-rpath", HOMEBREW_PREFIX/"lib", bin/"ted"
      (share/"icons/hicolor/256x256/apps").install "ted.png"
      inreplace "ted.desktop", "@BIN@", (opt_bin/"ted").to_s
      (share/"applications").install "ted.desktop"
    end
  end

  test do
    assert_equal "ted #{version}", shell_output("#{bin}/ted --version").strip
  end
end
