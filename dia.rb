require 'formula'

class Dia < Formula
  homepage 'http://live.gnome.org/Dia'
  url 'http://ftp.gnome.org/pub/gnome/sources/dia/0.97/dia-0.97.3.tar.xz'
  sha256 '22914e48ef48f894bb5143c5efc3d01ab96e0a0cde80de11058d3b4301377d34'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'libtiff'
  depends_on 'gtk+'
  depends_on :x11
  depends_on 'freetype'

  def install
    # fix for Leopard, potentially others with isspecial defined elswhere
    inreplace 'objects/GRAFCET/boolequation.c', 'isspecial', 'char_isspecial'
    system "./configure", "--enable-debug=no",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm_rf share+"applications"
  end
end
