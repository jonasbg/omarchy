class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/omarchy"
  version "0.2.5"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.5/ted-Darwin-arm64.tar.gz"
      sha256 "ea35c344cd94db4115f8bbd181efb0e9811b8190bece21998fe08ca0ed13c753"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.5/ted-Darwin-x86_64.tar.gz"
      sha256 "84be40cf73de9a2626c356ca2d5ef7cb7df090b68b7c032265d8b2cdd5ff55fd"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.5/ted-Linux-x86_64.tar.gz"
      sha256 "1865007b02a1b1e21865ae5d9eeab827e6db292ee61020ae9021d4717c3b7701"
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
