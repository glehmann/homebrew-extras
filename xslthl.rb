require "formula"

class Xslthl < Formula
  homepage "http://xslthl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xslthl/xslthl/2.1.0/xslthl-2.1.0-dist.tar.gz"
  sha256 "8a28e3541188c4022228076eb69523ef8b90f7ccb4bece49644a50542b87cc9a"

  def install
    (libexec/"lib").install Dir["*.jar"]
    (share/"xslthl").install "highlighters"
  end
end
