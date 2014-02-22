require "formula"

class Tulip < Formula
  homepage "http://tulip.labri.fr/"
  url "http://downloads.sourceforge.net/project/auber/tulip/tulip-4.1.0/tulip-4.1.0_src.tar.gz"
  sha1 "91a88e011f441f836c903842b138b2b304794a39"

  depends_on "cmake" => :build
  depends_on "glew"
  depends_on "qt"
  depends_on "sip"

  def patches
    # fixes compilation with glib 2.31+
    # see https://bugzilla.gnome.org/show_bug.cgi?id=665335
    # fixed in master branch, should be removable in next release
    DATA
  end

  def install
    args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Debug"]
    mkdir 'build' do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end

__END__
diff --git a/library/tulip-core/include/tulip/cxx/Array.cxx b/library/tulip-core/include/tulip/cxx/Array.cxx
index 69538da..216f5e0 100644
--- a/library/tulip-core/include/tulip/cxx/Array.cxx
+++ b/library/tulip-core/include/tulip/cxx/Array.cxx
@@ -61,7 +61,7 @@ std::istream & tlp::operator>> (std::istream &is, tlp::Array<Obj,SIZE> & outA) {
   is.clear();
 
   // skip spaces
-  while((is >> c) && isspace(c)) {}
+  while((is >> c) && std::isspace(c)) {}
 
   if(c!='(') {
     is.seekg(pos);
@@ -74,7 +74,7 @@ std::istream & tlp::operator>> (std::istream &is, tlp::Array<Obj,SIZE> & outA) {
 
     if (i>0 ) {
       // skip spaces
-      while((ok = (is >> c)) && isspace(c)) {}
+      while((ok = (is >> c)) && std::isspace(c)) {}
 
       if (!ok || c!=',') {
         is.seekg(pos);
@@ -84,7 +84,7 @@ std::istream & tlp::operator>> (std::istream &is, tlp::Array<Obj,SIZE> & outA) {
     }
 
     // skip spaces
-    while((ok = (is >> c)) && isspace(c)) {}
+    while((ok = (is >> c)) && std::isspace(c)) {}
 
     is.unget();
     bool done = true;
@@ -98,7 +98,7 @@ std::istream & tlp::operator>> (std::istream &is, tlp::Array<Obj,SIZE> & outA) {
   }
 
   // skip spaces
-  while((is >> c) && isspace(c)) {}
+  while((is >> c) && std::isspace(c)) {}
 
   if (c!=')' ) {
     is.seekg(pos);
diff --git a/library/tulip-core/include/tulip/tulipconf.h b/library/tulip-core/include/tulip/tulipconf.h
index 1a198d5..9bf1ec9 100644
--- a/library/tulip-core/include/tulip/tulipconf.h
+++ b/library/tulip-core/include/tulip/tulipconf.h
@@ -21,6 +21,7 @@
 #ifndef TULIPCONF_H
 #define TULIPCONF_H
 #include <QtCore/QDebug>
+#include <ciso646>
 
 /**
  * @brief this file contains various helper macros and functions to have a true cross-platform compilation.
@@ -113,8 +114,11 @@ static float strtof(const char* cptr, char** endptr) {
 //clang does not define __GNUC_MINOR__, thus having a separate clang #elif seems cleaner than adding defined() in the #else
 #elif __clang__
 #  define _DEPRECATED __attribute__ ((deprecated))
-#  define stdext __gnu_cxx
-
+#  if defined(_LIBCPP_VERSION)
+#    define stdext std
+#  else
+#    define stdext __gnu_cxx
+#  endif
 //for GCC 4.X
 #else
 #    define _DEPRECATED __attribute__ ((deprecated))
diff --git a/library/tulip-core/include/tulip/tuliphash.h b/library/tulip-core/include/tulip/tuliphash.h
index 142bc5c..45b8eee 100755
--- a/library/tulip-core/include/tulip/tuliphash.h
+++ b/library/tulip-core/include/tulip/tuliphash.h
@@ -30,8 +30,10 @@
  * TLP_END_HASH_NAMESPACE is definde to close the namespace (only used when using std::tr1)
  */
 
+#include <ciso646>
+
 //VS2010 and later can use C++0x's unordered_map; vs2008 uses boost's tr1 implementation
-#if(defined _MSC_VER && _MSC_VER > 1500)
+#if(defined _MSC_VER && _MSC_VER > 1500) || defined(_LIBCPP_VERSION)
 #  include <unordered_map>
 #  include <unordered_set>
 #  define TLP_HASH_MAP std::unordered_map
@@ -107,4 +109,4 @@ TLP_BEGIN_HASH_NAMESPACE {
 } TLP_END_HASH_NAMESPACE
 
 #endif
-///@endcond
\ No newline at end of file
+///@endcond
