# fetched and modified from
# https://github.com/Homebrew/homebrew-core/blob/5cb5e4ee6df017d154adba1f739ef4e32620e96c/Formula/f/fish.rb
class FishAT402 < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/#{version}/fish-#{version}.tar.xz"
  sha256 "6e1ecdb164285fc057b2f35acbdc20815c1623099e7bb47bbfc011120adf7e83"
  license "GPL-2.0-only"
  version "4.0.2"

  conflicts_with "fish"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  # The library itself is not needed, but the terminfo database is
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system bin/"fish", "-c", "echo"
  end
end
