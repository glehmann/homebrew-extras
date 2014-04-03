require "formula"

class Xslthl < Formula
  homepage ""
  url "https://downloads.sourceforge.net/project/xslthl/xslthl/2.1.0/xslthl-2.1.0-dist.tar.gz"
  sha1 "77877cc7fa74589a0e24c8151a8cd907378f5307"

  def install
    (libexec/"lib").install Dir["*.jar"]
    (share/"xslthl").install "highlighters"
  end
end
