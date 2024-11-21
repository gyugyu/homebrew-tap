class Hugoenv < Formula
  desc "Manage multiple Hugo versions"
  homepage "https://github.com/gyugyu/hugoenv"
  license "MIT"
  head "https://github.com/gyugyu/hugoenv.git", branch: "main"

  depends_on "hugo-build"

  def install
    inreplace "libexec/hugoenv" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
    end

    %w[--version hooks versions].each do |cmd|
      inreplace "libexec/hugoenv-#{cmd}", "${BASH_SOURCE%/*}", libexec
    end

    # Compile bash extension
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `nodenv --version` output
      inreplace "libexec/hugoenv---version", /^(version=.+)/,
                                           "\\1--g#{Utils.git_short_head}"
    end

    prefix.install "bin", "completions", "libexec"
  end

  test do
    shell_output("eval \"$(#{bin}/hugoenv init -)\" && hugoenv --version")
  end
end
