require 'formula'

class Qwt5 < Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/5.2.1/qwt-5.2.1.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  sha1 '89de7a90b7eddad2989470627baa19d59e348df1'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      s.gsub! /\/usr\/local\/qwt-5\.2\.1/, prefix
    end

    system "qmake -config release"
    system "make install"
  end
end
