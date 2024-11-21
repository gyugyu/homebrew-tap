class HugoBuild < Formula
  desc "Install Hugo versions"
  homepage "https://github.com/gyugyu/hugo-build"
  license "MIT"
  head "https://github.com/gyugyu/hugo-build.git", branch: "main"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"hugo-build", "--definitions"
  end
end
