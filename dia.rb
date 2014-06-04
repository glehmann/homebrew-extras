require 'formula'

class Dia < Formula
  homepage 'http://live.gnome.org/Dia'
  url 'http://ftp.gnome.org/pub/gnome/sources/dia/0.97/dia-0.97.2.tar.xz'
  sha256 'a761478fb98697f71b00d3041d7c267f3db4b94fe33ac07c689cb89c4fe5eae1'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'libtiff'
  depends_on 'gtk+'
  depends_on :x11
  depends_on 'freetype'

  def patches
    # fixes compilation with glib 2.31+
    # see https://bugzilla.gnome.org/show_bug.cgi?id=665335
    # fixed in master branch, should be removable in next release
    DATA
  end

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

__END__
diff --git a/app/render_gdk.c b/app/render_gdk.c
index f6692dd..23e4226 100644
--- a/app/render_gdk.c
+++ b/app/render_gdk.c
@@ -63,7 +63,21 @@ static void draw_object_highlighted (DiaRenderer *renderer,
                                      DiaObject *object,
                                      DiaHighlightType type);
 
-static void dia_gdk_renderer_iface_init (DiaInteractiveRendererInterface* iface)
+typedef struct _DiaGdkInteractiveRenderer DiaGdkInteractiveRenderer;
+struct _DiaGdkInteractiveRenderer
+{
+  DiaGdkRenderer parent_instance; /*!< inheritance in object oriented C */
+};
+typedef struct _DiaGdkInteractiveRendererClass DiaGdkInteractiveRendererClass;
+struct _DiaGdkInteractiveRendererClass
+{
+  DiaGdkRendererClass parent_class; /*!< the base class */
+};
+#define DIA_TYPE_GDK_INTERACTIVE_RENDERER           (dia_gdk_interactive_renderer_get_type ())
+#define DIA_GDK_INTERACTIVE_RENDERER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_GDK_INTERACTIVE_RENDERER, DiaGdkInteractiveRenderer))
+
+static void
+dia_gdk_renderer_iface_init (DiaInteractiveRendererInterface* iface)
 {
   iface->clip_region_clear = clip_region_clear;
   iface->clip_region_add_rect = clip_region_add_rect;
@@ -75,35 +89,35 @@ static void dia_gdk_renderer_iface_init (DiaInteractiveRendererInterface* iface)
   iface->draw_object_highlighted = draw_object_highlighted;
 }
 
+G_DEFINE_TYPE_WITH_CODE (DiaGdkInteractiveRenderer, dia_gdk_interactive_renderer, DIA_TYPE_GDK_RENDERER,
+			 G_IMPLEMENT_INTERFACE (DIA_TYPE_INTERACTIVE_RENDERER_INTERFACE, dia_gdk_renderer_iface_init));
+
+static void
+dia_gdk_interactive_renderer_class_init(DiaGdkInteractiveRendererClass *klass)
+{
+}
+static void
+dia_gdk_interactive_renderer_init(DiaGdkInteractiveRenderer *object)
+{
+  DiaGdkInteractiveRenderer *ia_renderer = DIA_GDK_INTERACTIVE_RENDERER (object);
+  DiaGdkRenderer *renderer = DIA_GDK_RENDERER(object);
+  DiaRenderer *dia_renderer = DIA_RENDERER(object);
+  
+  dia_renderer->is_interactive = 1;
+
+  renderer->gc = NULL;
+  renderer->pixmap = NULL;
+  renderer->clip_region = NULL;
+}
+
 DiaRenderer *
 new_gdk_renderer(DDisplay *ddisp)
 {
   DiaGdkRenderer *renderer;
   GType renderer_type = 0;
 
-  renderer = g_object_new (DIA_TYPE_GDK_RENDERER, NULL);
+  renderer = g_object_new (DIA_TYPE_GDK_INTERACTIVE_RENDERER, NULL);
   renderer->transform = dia_transform_new (&ddisp->visible, &ddisp->zoom_factor);
-  if (!DIA_GET_INTERACTIVE_RENDERER_INTERFACE (renderer))
-    {
-      static const GInterfaceInfo irenderer_iface_info = 
-      {
-        (GInterfaceInitFunc) dia_gdk_renderer_iface_init,
-        NULL,           /* iface_finalize */
-        NULL            /* iface_data     */
-      };
-
-      renderer_type = DIA_TYPE_GDK_RENDERER;
-      /* register the interactive renderer interface */
-      g_type_add_interface_static (renderer_type,
-                                   DIA_TYPE_INTERACTIVE_RENDERER_INTERFACE,
-                                   &irenderer_iface_info);
-
-    }
-  renderer->parent_instance.is_interactive = 1;
-  renderer->gc = NULL;
-
-  renderer->pixmap = NULL;
-  renderer->clip_region = NULL;
 
   return DIA_RENDERER(renderer);
 }
