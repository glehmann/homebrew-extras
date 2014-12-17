require "formula"

class Tulip < Formula
  homepage "http://tulip.labri.fr/"
  url "http://downloads.sourceforge.net/project/auber/tulip/tulip-4.6.0/tulip-4.6.0_src.tar.gz"
  sha1 "8c624ccfd2d361df6479ca5df5e1de984df63ce3"

  bottle do
    root_url "https://raw.githubusercontent.com/glehmann/homebrew-extras-bottle/master"
    sha1 "0e092a8bfdb7d048d9860fd206c0371cf2020af7" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "sip" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "glew"
  depends_on "qt5"
  depends_on :freetype

  def install
    args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Debug", "-DUSE_QT5_IF_INSTALLED:BOOL=ON"]
    mkdir 'build' do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end
