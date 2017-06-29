require "formula"

class Tulip < Formula
  homepage "http://tulip.labri.fr/"
  url "http://downloads.sourceforge.net/project/auber/tulip/tulip-4.6.0/tulip-4.6.0_src.tar.gz"
  sha256 "6012dab496883b4e835bf7b4d7c2b7f4df7f5e05c00a2345f8a0d93d5c2eacd7"

  bottle do
    root_url "https://github.com/glehmann/homebrew-extras-bottle/blob/master/tulip-4.6.0.mavericks.bottle.tar.gz?raw=true"
    sha256 "cd777bc4f017a965fa57d0cddc13285ce6c66aea51a780417925bd4f9f937c00" => :mavericks
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
