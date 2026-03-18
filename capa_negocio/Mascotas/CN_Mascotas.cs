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

        //METODO PARA CREAR NUEVAS MASCOTAS
        public notifyDTO Insertar(MascotaDto dto)
        {
            try
            {
                // ---- Validaciones ----
                if (string.IsNullOrWhiteSpace(dto.Nombre))
                    return notifyDTO.Error("El nombre es obligatorio.");

                if (dto.EspecieID == 0)
                    return notifyDTO.Error("Debe seleccionar una especie.");

                if (dto.RazaID == 0)
                    return notifyDTO.Error("Debe seleccionar una raza.");

                if (dto.Sexo == 0)
                    return notifyDTO.Error("Debe seleccionar el sexo.");

                if (dto.Tamanio == 0)
                    return notifyDTO.Error("Debe seleccionar el tamaño.");

                if (string.IsNullOrWhiteSpace(dto.Color))
                    return notifyDTO.Error("El color es obligatorio.");

                if (dto.EstadoMascotaID == 0)
                    return notifyDTO.Error("Debe seleccionar un estado.");

                if (dto.Esterilizado && !dto.FechaEsterilizacion.HasValue)
                    return notifyDTO.Error("Si está esterilizado, ingrese la fecha.");

                // ---- Insertar mascota en BD ----
                int mascotaID = _cdMascota.Insertar(dto);
                if (mascotaID == -1)
                    return notifyDTO.Error("No se pudo guardar la mascota. Intente nuevamente.");

                return notifyDTO.Exito("Mascota registrada correctamente.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Mascotas] Error en Insertar: " + ex.Message);
                return notifyDTO.Error("Error inesperado al guardar la mascota.");
            }
        }

        //METODO PARA CONSULTAR DATOS DE UNA MASCOTA
        public MascotaDto ObtenerPorId(int mascotaID)
        {
            return _cdMascota.ObtenerPorId(mascotaID);
        }

        //METODO PARA ACTUALIZAR UNA MASCOTA
        public notifyDTO Actualizar(MascotaDto dto)
        {
            try
            {
                // ---- Validaciones (mismas que Insertar) ----
                if (string.IsNullOrWhiteSpace(dto.Nombre))
                    return notifyDTO.Error("El nombre es obligatorio.");

                if (dto.EspecieID == 0)
                    return notifyDTO.Error("Debe seleccionar una especie.");

                if (dto.RazaID == 0)
                    return notifyDTO.Error("Debe seleccionar una raza.");

                if (dto.Sexo == 0)
                    return notifyDTO.Error("Debe seleccionar el sexo.");

                if (dto.Tamanio == 0)
                    return notifyDTO.Error("Debe seleccionar el tamaño.");

                if (string.IsNullOrWhiteSpace(dto.Color))
                    return notifyDTO.Error("El color es obligatorio.");

                if (dto.EstadoMascotaID == 0)
                    return notifyDTO.Error("Debe seleccionar un estado.");

                if (dto.Esterilizado && !dto.FechaEsterilizacion.HasValue)
                    return notifyDTO.Error("Si está esterilizado, ingrese la fecha.");

                // ---- Actualizar datos en BD ----
                bool ok = _cdMascota.Actualizar(dto);
                if (!ok)
                    return notifyDTO.Error("No se pudo actualizar la mascota. Intente nuevamente.");

                return notifyDTO.Exito("Mascota actualizada correctamente.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Mascotas] Error en Actualizar: " + ex.Message);
                return notifyDTO.Error("Error inesperado al actualizar la mascota.");
            }
        }

        //METODO - CAMBIAR ESTADO
        public notifyDTO CambiarEstado(int mascotaID, byte estadoID)
        {
            try
            {
                bool ok = _cdMascota.CambiarEstado(mascotaID, estadoID);
                return ok
                    ? notifyDTO.Exito("Estado actualizado.")
                    : notifyDTO.Error("No se encontró la mascota.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Mascotas] Error en CambiarEstado: " + ex.Message);
                return notifyVarDTO.Error("Error inesperado al cambiar el estado.");
            }
        }
    }
}