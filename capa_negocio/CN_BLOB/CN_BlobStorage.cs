using capa_datos;
using capa_dto;
using capa_DTO.DTO.DTO_BLOB;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_BlobStorage
    {
        private readonly BlobStorageDAL _dal;

        // Reglas del chef
        private readonly string[] _extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".webp" };
        private const long TAMANIO_MAXIMO = 5 * 1024 * 1024; // 5 MB

        public CN_BlobStorage()
        {
            _dal = new BlobStorageDAL();
        }

        // SUBIR foto con validaciones
        public async Task<string> SubirFotoMascota(string modulo, string nombreOriginal, Stream archivo, string tipoContenido, long tamanio)
        {
            //Regla 0 : ¿Se indicó el módulo?
            if (string.IsNullOrWhiteSpace(modulo))
                throw new InvalidOperationException("Debe indicar el módulo.");

            // Regla 1: ¿Es un formato permitido?
            string extension = Path.GetExtension(nombreOriginal).ToLower();
            if (Array.IndexOf(_extensionesPermitidas, extension) < 0)
                throw new InvalidOperationException("Solo se permiten imágenes JPG, PNG o WEBP.");

            // Regla 2: ¿No es muy pesada?
            if (tamanio > TAMANIO_MAXIMO)
                throw new InvalidOperationException("La imagen no puede superar los 5 MB.");

            // Regla 3: Generar nombre único para no sobreescribir
            string nombreUnico = $"{modulo.ToLower()}/{Guid.NewGuid()}{extension}";

            // Llamar al empleado del almacén
            return await _dal.SubirArchivoAsync(nombreUnico, archivo, tipoContenido);
        }

        // ELIMINAR foto (RUTA COMPLETA)
        public async Task<bool> EliminarFoto(string nombreArchivo)
        {
            if (string.IsNullOrEmpty(nombreArchivo))
                throw new InvalidOperationException("Debe indicar el nombre del archivo.");

            return await _dal.EliminarArchivoAsync(nombreArchivo);
        }

        // LISTAR fotos
        public List<BlobItemDTO> ObtenerFotosPorModulo(string modulo)
        {
            if (string.IsNullOrWhiteSpace(modulo))
                throw new InvalidOperationException("Debe indicar el módulo.");

            var archivos = _dal.ListarArchivos($"{modulo.ToLower()}/");
            var resultado = new List<BlobItemDTO>();

            foreach (var archivo in archivos)
            {
                resultado.Add(new BlobItemDTO
                {
                    Nombre = archivo.Nombre,
                    Url = archivo.Url,
                    Tamanio = archivo.Tamanio
                });
            }

            return resultado;
        }
    }
}