require 'formula'

class Qwt5 < Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/5.2.1/qwt-5.2.1.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  sha256 "e2b8bb755404cb3dc99e61f3e2d7262152193488f5fbe88524eb698e11ac569f"

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      s.gsub! /\/usr\/local\/qwt-5\.2\.1/, prefix
    end

    system "qmake -config release"
    system "make install"
  end
end
