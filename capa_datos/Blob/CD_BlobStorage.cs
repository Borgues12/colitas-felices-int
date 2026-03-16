// capa_datos/Storage/CD_BlobStorage.cs
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace capa_datos.Blob
{
    public class CD_BlobStorage
    {
        private readonly BlobServiceClient _serviceClient;

        public CD_BlobStorage()
        {
            string connectionString = ConfigurationManager.AppSettings["AzureBlobConnection"];
            _serviceClient = new BlobServiceClient(connectionString);
        }

        // ── SUBIR ────────────────────────────────────────────────────

        /// <summary>
        /// Sube un archivo a un contenedor específico.
        /// Retorna la URL pública del blob o null si falló.
        /// </summary>
        public async Task<string> SubirAsync(
            string contenedor,
            string nombreArchivo,
            Stream archivo,
            string tipoContenido)
        {
            try
            {
                var container = await ObtenerContenedor(contenedor);
                var blobClient = container.GetBlobClient(nombreArchivo);

                await blobClient.UploadAsync(archivo, new BlobUploadOptions
                {
                    HttpHeaders = new BlobHttpHeaders { ContentType = tipoContenido }
                });

                return blobClient.Uri.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en SubirAsync: {ex.Message}");
                return null;
            }
        }

        /// <summary>
        /// Sube un archivo desde una ruta local del servidor.
        /// Usado por AzuriteInit para subir assets estáticos.
        /// </summary>
        public async Task<string> SubirDesdeRutaAsync(
            string contenedor,
            string nombreArchivo,
            string rutaLocal,
            string tipoContenido)
        {
            try
            {
                using (var stream = File.OpenRead(rutaLocal))
                {
                    return await SubirAsync(contenedor, nombreArchivo, stream, tipoContenido);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en SubirDesdeRutaAsync: {ex.Message}");
                return null;
            }
        }

        // ── ELIMINAR ─────────────────────────────────────────────────

        /// <summary>
        /// Elimina un archivo de un contenedor específico.
        /// </summary>
        public async Task<bool> EliminarAsync(string contenedor, string nombreArchivo)
        {
            try
            {
                var container = _serviceClient.GetBlobContainerClient(contenedor);
                var blobClient = container.GetBlobClient(nombreArchivo);
                var response = await blobClient.DeleteIfExistsAsync();
                return response.Value;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en EliminarAsync: {ex.Message}");
                return false;
            }
        }

        // ── VERIFICAR ────────────────────────────────────────────────

        /// <summary>
        /// Verifica si un blob ya existe en el contenedor.
        /// Usado por AzuriteInit para no sobreescribir assets.
        /// </summary>
        public async Task<bool> ExisteAsync(string contenedor, string nombreArchivo)
        {
            try
            {
                var container = _serviceClient.GetBlobContainerClient(contenedor);
                var blobClient = container.GetBlobClient(nombreArchivo);
                var response = await blobClient.ExistsAsync();
                return response.Value;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en ExisteAsync: {ex.Message}");
                return false;
            }
        }

        // ── LISTAR ───────────────────────────────────────────────────

        /// <summary>
        /// Lista archivos en un contenedor con prefijo opcional.
        /// </summary>
        public List<string> Listar(string contenedor, string prefijo = null)
        {
            try
            {
                var container = _serviceClient.GetBlobContainerClient(contenedor);
                var urls = new List<string>();

                foreach (var blob in container.GetBlobs(
                                                           BlobTraits.None,
                                                           BlobStates.None,
                                                           prefix: prefijo,
                                                           CancellationToken.None))
                {
                    urls.Add($"{container.Uri}/{blob.Name}");
                }

                return urls;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en Listar: {ex.Message}");
                return new List<string>();
            }
        }

        // ── PRIVADOS ─────────────────────────────────────────────────

        /// <summary>
        /// Obtiene o crea un contenedor con acceso público a blobs.
        /// </summary>
        private async Task<BlobContainerClient> ObtenerContenedor(string nombre)
        {
            var container = _serviceClient.GetBlobContainerClient(nombre);
            await container.CreateIfNotExistsAsync(PublicAccessType.Blob);
            return container;
        }
    }
}