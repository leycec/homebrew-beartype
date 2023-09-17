class Beartype < Formula
  include Language::Python::Virtualenv

  desc "Unbearably fast O(1) runtime type-checking in pure Python"
  homepage "https://github.com/beartype/beartype"
  url "https://files.pythonhosted.org/packages/82/e2/bb1da3f5bfb87357ca91dddf03d30a9ca414b9daf244fa0bba40a666c5a1/beartype-0.16.0.tar.gz"
  sha256 "231379a056da2fc1811a2e1324d5c3d0fa2082e305bfa15cb3acb9b7ce9df516"
  license "MIT"
  # Default branch is "main" not "master" (unbearably modern)
  head "https://github.com/beartype/beartype.git", branch: "main"

  bottle do
    root_url "https://github.com/beartype/homebrew-beartype/releases/download/beartype-0.16.0"
    sha256 cellar: :any_skip_relocation, ventura:      "48ac57dc20be069d6a8332c194435f1269e3857c7d2df9339f673abde419e696"
    sha256 cellar: :any_skip_relocation, monterey:     "096706a4a0aabcbb99a14c065bd3773d5f9b772031e86056c574e9a898f71443"
    sha256 cellar: :any_skip_relocation, big_sur:      "6877c54143fba4737410c8308c7956ffcfbc10240886b7ae64fc43bbb4c90953"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64d8aae4a4b2357cad1624c6dfce2d38ac80f33019c7e7b0f21659720c5916bf"
  end

  depends_on "python@3.11"

  def install
    # Based on name-that-hash
    # https://github.com/Homebrew/homebrew-core/blob/9652b75b2bbaf728f70c50b09cce39520c08321d/Formula/name-that-hash.rb
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-beartype.pth").write pth_contents
  end

  test do
    # Simple version number check
    system Formula["python@3.11"].opt_bin/"python3.11", "-c", <<~EOS
      import #{name}
      assert #{name}.__version__ == "#{version}"
    EOS
  end
end
