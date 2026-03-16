using capa_negocio.Blob;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;

namespace colitas_felices.Helpers
{
    public class AzureInit
    {// Contenedores que existen hoy — se agregan más cuando lleguen los módulos
        private static readonly string[] CONTENEDORES =
        {
            ConfigurationManager.AppSettings["EmailAssetsContainer"],
            ConfigurationManager.AppSettings["GeneralAssetsContainer"]
        };

        // Imágenes estáticas de correos
        // (rutaLocal, nombreEnBlob, tipoContenido)
        private static readonly (string archivo, string blob, string tipo)[] EMAIL_ASSETS =
        {
            ("logo_p.png",    "logo.png",       "image/png"),
            ("dog_2.png",     "dog.png",        "image/png"),
            ("facebook.png",  "facebook.png",   "image/png"),
            ("twitter.png",   "twitter.png",    "image/png"),
            ("linkedin.png",  "linkedin.png",   "image/png"),
            ("instagram.png", "instagram.png",  "image/png")
        };

        public static async Task InicializarAsync()
        {
        #if DEBUG
            try
            {
                var cn = new CN_BlobStorage();
                string emailContainer = ConfigurationManager.AppSettings["EmailAssetsContainer"];

                // ── 1. Crear todos los contenedores ───────────────────
                // CD_BlobStorage.ObtenerContenedor ya hace CreateIfNotExistsAsync
                // pero aquí lo hacemos explícito para tener el log
                foreach (var contenedor in CONTENEDORES)
                {
                    // Subir un blob vacío no tiene sentido — 
                    // usamos ExisteAsync para forzar la creación del contenedor
                    await cn.ExisteAsync(contenedor, "_init");
                    System.Diagnostics.Debug.WriteLine($"✅ Contenedor listo: {contenedor}");
                }

                // ── 2. Subir imágenes de email si no existen ──────────
                string carpeta = HostingEnvironment.MapPath("~/Assets/EmailAssets/");

                foreach (var (archivo, blobNombre, tipo) in EMAIL_ASSETS)
                {
                    // Si ya existe no sobreescribimos — evita subidas innecesarias
                    if (await cn.ExisteAsync(emailContainer, blobNombre))
                    {
                        System.Diagnostics.Debug.WriteLine($"⏭️ Ya existe: {blobNombre}");
                        continue;
                    }

                    string rutaLocal = System.IO.Path.Combine(carpeta, archivo);

                    if (!System.IO.File.Exists(rutaLocal))
                    {
                        System.Diagnostics.Debug.WriteLine($"⚠ No encontrada: {archivo}");
                        continue;
                    }

                    string url = await cn.SubirDesdeRutaAsync(emailContainer, blobNombre, rutaLocal, tipo);

                    System.Diagnostics.Debug.WriteLine(
                        url != null ? $"✅ Subida: {blobNombre}" : $"❌ Error subiendo: {blobNombre}"
                    );
                }

                System.Diagnostics.Debug.WriteLine("✅ AzuriteInit completado");
            }
            catch (Exception ex)
            {
                // No rompe la app si Azurite no está levantado
                System.Diagnostics.Debug.WriteLine("⚠️ AzuriteInit falló: " + ex.Message);
            }
#endif
        }
    }
}