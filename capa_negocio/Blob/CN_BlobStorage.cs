using capa_datos.Blob;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio.Blob
{
    public class CN_BlobStorage
    {
        private readonly CD_BlobStorage _cd = new CD_BlobStorage();

        private string ContenedorMascotas => ConfigurationManager.AppSettings["MascotasContainer"] ?? "mascotas";
        private string ContenedorDocumentos => ConfigurationManager.AppSettings["DocumentosContainer"] ?? "documentos";
        private string ContenedorAssets => ConfigurationManager.AppSettings["AssetsContainer"] ?? "assets-generales";

        private static readonly HashSet<string> _extImagen =
            new HashSet<string> { ".jpg", ".jpeg", ".png", ".webp" };

        private static readonly HashSet<string> _extDocumento =
            new HashSet<string> { ".jpg", ".jpeg", ".png", ".pdf" };

        // ============================================================
        // MÉTODOS HEREDADOS — usados por AzuriteInit
        // ============================================================

        public async Task<bool> ExisteAsync(string contenedor, string blob)
        {
            return await _cd.ExisteAsync(contenedor, blob);
        }

        public async Task<string> SubirDesdeRutaAsync(
            string contenedor,
            string nombreArchivo,
            string rutaLocal,
            string tipoContenido)
        {
            return await _cd.SubirDesdeRutaAsync(contenedor, nombreArchivo, rutaLocal, tipoContenido);
        }

        // ============================================================
        // FOTOS DE MASCOTAS
        // Path: mascotas/{mascotaID}/{guid}{ext}
        // Acceso público — URL se usa directo en <img src>
        //
        // Desde el front se llama así:
        //   var f = fuFoto1.PostedFile;
        //   _blob.SubirFotoMascota(f.InputStream, f.ContentType, f.FileName, mascotaID);
        // ============================================================

        public string SubirFotoMascota(Stream stream, string contentType, string nombreOriginal, int mascotaID)
        {
            try
            {
                //DEBUG TEMPORAL
                Debug.WriteLine("=== SubirFotoMascota iniciando: " + nombreOriginal);

                string ext = Path.GetExtension(nombreOriginal).ToLower();

                //DEBUG TEMPORAL
                Debug.WriteLine("Extension: " + ext);

                if (!_extImagen.Contains(ext))
                {
                    Debug.WriteLine("[CN_BlobStorage] Extensión no permitida: " + ext);
                    return null;
                }

                string nombreBlob = mascotaID + "/" + Guid.NewGuid().ToString("N") + ext;

                //DEBUG TEMPORAL
                Debug.WriteLine("NombreBlob: " + nombreBlob);

                stream.Position = 0;

                string url = Task.Run(() =>
                _cd.SubirAsync(ContenedorMascotas, nombreBlob, stream, contentType)).Result;

                //DEBUG TEMPORAL
                Debug.WriteLine("URL resultado: " + (url ?? "NULL"));

                return url;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_BlobStorage] Error en SubirFotoMascota: " + ex.Message);
                if (ex.InnerException != null)
                    Debug.WriteLine("InnerException: " + ex.InnerException.Message);
                return null;
            }
        }

        public bool EliminarFotoMascota(string blobUrl)
        {
            return EliminarPorUrl(blobUrl, ContenedorMascotas);
        }

        // ============================================================
        // DOCUMENTOS (adopciones, seguimientos)
        // Path: documentos/{tipo}/{referenciaID}/{guid}{ext}
        // Acceso privado — el servidor los sirve, no la URL directa
        // tipo: "adopciones" | "seguimientos"
        //
        // Desde el front se llama así:
        //   var f = fuCedula.PostedFile;
        //   _blob.SubirDocumento(f.InputStream, f.ContentType, f.FileName, "adopciones", solicitudID);
        // ============================================================

        public string SubirDocumento(Stream stream, string contentType, string nombreOriginal, string tipo, int referenciaID)
        {
            try
            {
                string ext = Path.GetExtension(nombreOriginal).ToLower();
                if (!_extDocumento.Contains(ext))
                {
                    Debug.WriteLine("[CN_BlobStorage] Extensión no permitida para documento: " + ext);
                    return null;
                }

                string nombreBlob = tipo + "/" + referenciaID + "/" + Guid.NewGuid().ToString("N") + ext;
                stream.Position = 0;
                var task = _cd.SubirAsync(ContenedorDocumentos, nombreBlob, stream, contentType);
                task.Wait();
                return task.Result;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_BlobStorage] Error en SubirDocumento: " + ex.Message);
                return null;
            }
        }

        public bool EliminarDocumento(string blobUrl)
        {
            return EliminarPorUrl(blobUrl, ContenedorDocumentos);
        }

        // ============================================================
        // ASSETS GENERALES (landing, rifas, campañas)
        // Path: assets-generales/{seccion}/{guid}{ext}
        // Acceso público
        // seccion: "landing" | "rifas/{id}" | "campanas/{id}"
        //
        // Desde el front se llama así:
        //   var f = fuBanner.PostedFile;
        //   _blob.SubirAsset(f.InputStream, f.ContentType, f.FileName, "landing");
        // ============================================================

        public string SubirAsset(Stream stream, string contentType, string nombreOriginal, string seccion)
        {
            try
            {
                string ext = Path.GetExtension(nombreOriginal).ToLower();
                if (!_extImagen.Contains(ext))
                {
                    Debug.WriteLine("[CN_BlobStorage] Extensión no permitida para asset: " + ext);
                    return null;
                }

                string nombreBlob = seccion + "/" + Guid.NewGuid().ToString("N") + ext;
                stream.Position = 0;
                var task = _cd.SubirAsync(ContenedorAssets, nombreBlob, stream, contentType);
                task.Wait();
                return task.Result;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_BlobStorage] Error en SubirAsset: " + ex.Message);
                return null;
            }
        }

        public bool EliminarAsset(string blobUrl)
        {
            return EliminarPorUrl(blobUrl, ContenedorAssets);
        }

        // ============================================================
        // PRIVADOS
        // ============================================================

        /// <summary>
        /// Extrae el nombreBlob desde la URL completa y lo elimina.
        /// URL Azurite: http://127.0.0.1:10000/devstoreaccount1/{contenedor}/{nombreBlob}
        /// </summary>
        private bool EliminarPorUrl(string blobUrl, string contenedor)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(blobUrl)) return false;

                var uri = new Uri(blobUrl);
                string prefix = "/devstoreaccount1/" + contenedor + "/";
                string nombreBlob = uri.AbsolutePath.Substring(
                    uri.AbsolutePath.IndexOf(prefix) + prefix.Length);

                return Task.Run(() => _cd.EliminarAsync(contenedor, nombreBlob)).Result;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_BlobStorage] Error en EliminarPorUrl: " + ex.Message);
                return false;
            }
        }
    }
}