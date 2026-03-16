using capa_datos.Crud;
using capa_dto;
using capa_DTO.DTO.Crud;
using capa_negocio.Blob;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio.Mascotas
{
    public class CN_Mascotas
    {
        private readonly CD_Mascota _cdMascota = new CD_Mascota();
        private readonly CD_MascotaFoto _cdFoto = new CD_MascotaFoto();
        private readonly CN_BlobStorage _blob = new CN_BlobStorage();

        
        /// <summary>
        /// Retorna el listado paginado de mascotas aplicando filtros opcionales.
        /// Si el filtro es null se usan valores por defecto (página 1, 20 registros).
        /// </summary>
        public List<MascotaDto> Listar(DTO_MascotaFiltro filtro = null)
        {
            try
            {
                // Si no mandan filtro, creamos uno con valores por defecto
                if (filtro == null)
                    filtro = new DTO_MascotaFiltro();

                // Página nunca menor a 1
                if (filtro.Pagina < 1)
                    filtro.Pagina = 1;

                // Registros por página entre 1 y 100
                if (filtro.RegistrosPorPagina < 1 || filtro.RegistrosPorPagina > 100)
                    filtro.RegistrosPorPagina = 20;
     
                return _cdMascota.Listar(filtro);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Mascota] Error en Listar: " + ex.Message);
                return new List<MascotaDto>();
            }
        }
        public notifyVarDTO Insertar(MascotaDto dto, IList<MascotasFotoStreamDto> fotos = null)
        {
            try
            {
                // ---- Validaciones ----
                if (string.IsNullOrWhiteSpace(dto.Nombre))
                    return notifyVarDTO.Error("El nombre es obligatorio.");

                if (dto.EspecieID == 0)
                    return notifyVarDTO.Error("Debe seleccionar una especie.");

                if (dto.RazaID == 0)
                    return notifyVarDTO.Error("Debe seleccionar una raza.");

                if (dto.Sexo == 0)
                    return notifyVarDTO.Error("Debe seleccionar el sexo.");

                if (dto.Tamanio == 0)
                    return notifyVarDTO.Error("Debe seleccionar el tamaño.");

                if (string.IsNullOrWhiteSpace(dto.Color))
                    return notifyVarDTO.Error("El color es obligatorio.");

                if (dto.EstadoMascotaID == 0)
                    return notifyVarDTO.Error("Debe seleccionar un estado.");

                if (dto.Esterilizado && !dto.FechaEsterilizacion.HasValue)
                    return notifyVarDTO.Error("Si está esterilizado, ingrese la fecha.");

                // ---- Insertar mascota en BD ----
                int mascotaID = _cdMascota.Insertar(dto);
                if (mascotaID == -1)
                    return notifyVarDTO.Error("No se pudo guardar la mascota. Intente nuevamente.");

                // ---- Subir fotos al blob ----
                if (fotos != null && fotos.Count > 0)
                {
                    bool algunaSubio = false;
                    bool esPrincipal = true;
                    byte orden = 1;

                    foreach (var foto in fotos)
                    {
                        if (foto == null || foto.Stream == null) continue;

                        string url = _blob.SubirFotoMascota(
                            foto.Stream,
                            foto.ContentType,
                            foto.NombreArchivo,
                            mascotaID);

                        if (url == null) continue;

                        _cdFoto.Insertar(new MascotasFotoDto
                        {
                            MascotaID = mascotaID,
                            NombreArchivo = foto.NombreArchivo,
                            BlobUrl = url,
                            EsPrincipal = esPrincipal,
                            Orden = orden,
                            SubidoPor = dto.RegistradoPor
                        });

                        esPrincipal = false;
                        algunaSubio = true;
                        orden++;
                    }

                    if (!algunaSubio)
                        return notifyVarDTO.ExitoConCodigo(
                            "Mascota guardada, pero no se pudieron subir las fotos.",
                            mascotaID);
                }

                return notifyVarDTO.ExitoConCodigo("Mascota registrada correctamente.", mascotaID);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Mascotas] Error en Insertar: " + ex.Message);
                return notifyVarDTO.Error("Error inesperado al guardar la mascota.");
            }
        }

    }
}