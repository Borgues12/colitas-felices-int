using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Threading.Tasks;
using capa_DTO.DTO.DTO_BLOB;
namespace capa_datos
{
    public class BlobStorageDAL
    {
        //Redonnly es para definirlas solo aqui y en ningun otro lado, es como una constante pero con objetos   
        private readonly BlobServiceClient _blobServiceClient;
        private readonly string _containerName;

        public BlobStorageDAL()
        {
            // Lee la dirección del "congelador" (almacen) desde el app.config
            string connectionString = ConfigurationManager.AppSettings["AzureBlobConnection"];
            _containerName = ConfigurationManager.AppSettings["AzureBlobContainer"];
            _blobServiceClient = new BlobServiceClient(connectionString);
        }

        // GUARDAR foto en el congelador de prueba
        public async Task<string> SubirArchivoAsync(string nombreArchivo, Stream archivo, string tipoContenido)
        {
            //Abre o crea el "congelador" (almacen) y le da permiso de lectura a cualquiera
            var containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
            await containerClient.CreateIfNotExistsAsync(PublicAccessType.Blob);

            // Crea un "archivo" (blob) dentro del "congelador" y lo sube con su tipo de contenido
            var blobClient = containerClient.GetBlobClient(nombreArchivo);
            //Etiqueta el archivo con su tipo de contenido para que se muestre correctamente al abrirlo
            var headers = new BlobHttpHeaders { ContentType = tipoContenido };

            //Lo subimos fisicamente al "congelador" con su etiqueta
            await blobClient.UploadAsync(archivo, new BlobUploadOptions { HttpHeaders = headers });

            //devolver la dirección del "archivo" (blob) para que se pueda acceder a él desde la aplicación
            return blobClient.Uri.ToString();
        }

        // ELIMINAR foto del congelador
        public async Task<bool> EliminarArchivoAsync(string nombreArchivo)
        {
            var containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
            var blobClient = containerClient.GetBlobClient(nombreArchivo);
            var response = await blobClient.DeleteIfExistsAsync();
            //devolver respuesta
            return response.Value;
        }

        // VER todo lo que hay en el congelador
        public List<BlobItemDTO> ListarArchivos(string prefijo)
        {
            var containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);

            var archivos = new List<BlobItemDTO>();
            foreach (BlobItem blob in containerClient.GetBlobs(BlobTraits.None,
                BlobStates.None,
                prefijo,
                default))
            {
                archivos.Add(new BlobItemDTO
                {
                    Nombre = blob.Name,
                    Url = $"{containerClient.Uri}/{blob.Name}",
                    Tamanio = blob.Properties.ContentLength ?? 0
                });
            }
            return archivos;
        }
    }
}
