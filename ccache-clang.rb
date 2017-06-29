require 'formula'

class CcacheClang < Formula
  homepage 'http://ccache.samba.org/'
  url 'http://samba.org/ftp/ccache/ccache-3.1.9.tar.bz2'
  sha256 "04d3e2e438ac8d4cc4b110b68cdd61bd59226c6588739a4a386869467f5ced7c"

  head do
    url 'https://github.com/jrosdahl/ccache.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      # see http://petereisentraut.blogspot.fr/2011/05/ccache-and-clang.html
      # and http://petereisentraut.blogspot.fr/2011/09/ccache-and-clang-part-2.html
      CCACHE_CPP2=yes exec ccache #{target} -Qunused-arguments `test -t 2 && echo -fcolor-diagnostics` "$@"
    EOS
  end

  def install
    system './autogen.sh' if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"

    libexec.mkpath

    %w[
      gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      c++3 c++-3.3 c++-4.0 c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      g++2 g++3 g++-3.3 g++-4.0 g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
    ].each do |prog|
      ln_s bin+"ccache", libexec + prog
    end

    %w[clang++ c++ g++].each do |prog|
      (libexec + prog).write shim_script("/usr/bin/clang++")
      (libexec + prog).chmod(0755)
    end

    %w[clang cc gcc].each do |prog|
      (libexec + prog).write shim_script("/usr/bin/clang")
      (libexec + prog).chmod(0755)
    end
  end

  def caveats; <<-EOS.undent
    To install symlinks for compilers that will automatically use
    ccache, prepend this directory to your PATH:
      #{opt_prefix}/libexec

    If this is an upgrade and you have previously added the symlinks to
    your PATH, you may need to modify it to the path specified above so
    it points to the current version.

    NOTE: ccache can prevent some software from compiling.
    ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end
end
