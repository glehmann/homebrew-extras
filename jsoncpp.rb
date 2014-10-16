require "formula"

class Jsoncpp < Formula
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/svn-release-0.6.0-rc2.tar.gz"
  sha1 "6cc51ed1f31e742637a512201b585e0bc4e06980"

  depends_on "scons" => :build

  def patches
    # use the usual environment variables for the compilation flags
    DATA
  end

  def install
    gccversion = `g++ -dumpversion`.strip
    libs = buildpath/"libs/linux-gcc-#{gccversion}/"

    scons "platform=linux-gcc"
    system "install_name_tool", "-id", lib/"libjsoncpp.dylib", libs/"libjson_linux-gcc-#{gccversion}_libmt.dylib"

    lib.install libs/"libjson_linux-gcc-#{gccversion}_libmt.dylib" => "libjsoncpp.dylib"
    lib.install libs/"libjson_linux-gcc-#{gccversion}_libmt.a" =>"libjsoncpp.a"
    (include/"jsoncpp").install buildpath/"include/json"

    (lib/"pkgconfig/jsoncpp.pc").write <<-EOS.undent
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=#{lib}
      includedir=#{include}

      Name: jsoncpp
      Description: API for manipulating JSON
      Version: #{version}
      URL: https://github.com/open-source-parsers/jsoncpp
      Libs: -L${libdir} -ljsoncpp
      Cflags: -I${includedir}/jsoncpp/
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <json/json.h>
      int main() {
        Json::Value root;
        Json::Reader reader;
        return reader.parse("[1, 2, 3]", root) ? 0: 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 23225cb..d240a6b 100644
--- a/SConstruct
+++ b/SConstruct
@@ -119,7 +119,7 @@ elif platform == 'mingw':
     env.Append( CPPDEFINES=[ "WIN32", "NDEBUG", "_MT" ] )
 elif platform.startswith('linux-gcc'):
     env.Tool( 'default' )
-    env.Append( LIBS = ['pthread'], CCFLAGS = "-Wall" )
+    env.Append( LIBS = ['pthread'], CCFLAGS = os.environ["CXXFLAGS"], LINKFLAGS=os.environ["LDFLAGS"] )
     env['SHARED_LIB_ENABLED'] = True
 else:
     print "UNSUPPORTED PLATFORM."
