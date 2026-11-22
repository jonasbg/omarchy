class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/omarchy"
  version "0.2.1"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.1/ted-Darwin-arm64.tar.gz"
      sha256 "7d432c5701cdce396acdd217c76e929cf7490c155987f1df0a29bc2c9af240cc"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.1/ted-Darwin-x86_64.tar.gz"
      sha256 "b5befe6f2d015f75d87b6debbfa0580dec201197349c4537504df5c8b62e401a"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.1/ted-Linux-x86_64.tar.gz"
      sha256 "a621e2c0b70fd5a758141dd88bdf6481da62e6671a361bab6d5c7a991fcb8b6d"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
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
    end
  end

  test do
    assert_equal "ted #{version}", shell_output("#{bin}/ted --version").strip
  end
end
