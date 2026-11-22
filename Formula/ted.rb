class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/omarchy"
  version "0.2.2"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.2/ted-Darwin-arm64.tar.gz"
      sha256 "392910bce1e6ade203b74aa37df18a2fa89fa3c6f1829a206be95d13ee28090a"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.2/ted-Darwin-x86_64.tar.gz"
      sha256 "7e7f06d47b11b2862be90e4afbaf16797819bb4b03a8f3e892b755eac1356dcf"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.2/ted-Linux-x86_64.tar.gz"
      sha256 "24937bbb84934aa7c3b5a5487f0afaaaa5bf0bebb08523cbad6a3bbe372a426f"
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
