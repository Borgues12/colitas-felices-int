using capa_datos.Crud;
using capa_dto;
using capa_DTO.DTO.Crud;
using capa_negocio.Blob;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace capa_negocio.Mascotas
{
    public class CN_MascotaFoto
    {
        private readonly CD_MascotaFoto _cd = new CD_MascotaFoto();
        private readonly CN_BlobStorage _blob = new CN_BlobStorage();

        // ── Obtener fotos (para el modal) ────────────────────────
        public List<MascotasFotoDto> ObtenerPorMascota(int mascotaID)
        {
            return _cd.ObtenerPorMascota(mascotaID);
        }

        // ── Marcar principal ─────────────────────────────────────
        public notifyDTO MarcarPrincipal(int mascotaID, int fotoID)
        {
            try
            {
                bool ok = _cd.MarcarPrincipal(mascotaID, fotoID);
                return ok
                    ? notifyDTO.Exito("Foto principal actualizada.")
                    : notifyDTO.Error("No se encontró la foto indicada.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_MascotaFoto] Error en MarcarPrincipal: " + ex.Message);
                return notifyDTO.Error("Error inesperado al cambiar la foto principal.");
            }
        }

        // ── Eliminar foto ────────────────────────────────────────
        public notifyDTO Eliminar(int fotoID, int mascotaID)
        {
            try
            {
                // Validación: debe quedar al menos 1 foto
                var fotos = _cd.ObtenerPorMascota(mascotaID);
                if (fotos.Count <= 1)
                    return notifyDTO.Error("La mascota debe tener al menos una foto.");

                //Pasa de la lista a consultar solo la que se va a eliminar
                var foto = fotos.FirstOrDefault(f => f.FotoID == fotoID);
                //Eliminar la registro de la base de datos
                bool okBD = _cd.Eliminar(fotoID);
                if (!okBD)
                    return notifyDTO.Error("No se pudo eliminar la foto.");

                //Eliminar registro de la base en azurite
                bool okBlob = _blob.EliminarFotoMascota(foto.BlobUrl);
                if (!okBlob)
                    Debug.WriteLine("[CN_MascotaFoto] Advertencia: no se eliminó del Blob: " + foto.BlobUrl);

                return notifyDTO.Exito("Foto eliminada correctamente.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_MascotaFoto] Error en Eliminar: " + ex.Message);
                return notifyDTO.Error("Error inesperado al eliminar la foto.");
            }
        }

        // ── Subir fotos nuevas ───────────────────────────────────
        public notifyDTO AgregarFotos(int mascotaID,
                                         IList<MascotasFotoStreamDto> fotos,
                                         int subidoPor)
        {
            try
            {
                // Validación: no superar el límite de 5
                byte ordenActual = _cd.ObtenerUltimoOrden(mascotaID);
                int espacioLibre = 5 - ordenActual;

                if (espacioLibre <= 0)
                    return notifyDTO.Error("Esta mascota ya tiene el máximo de 5 fotos.");

                bool algunaSubio = false;

                foreach (var foto in fotos)
                {
                    if (foto?.Stream == null) continue;
                    if (ordenActual >= 5) break;

                    string url = _blob.SubirFotoMascota(
                        foto.Stream,
                        foto.ContentType,
                        foto.NombreArchivo,
                        mascotaID);

                    if (url == null)
                    {
                        Debug.WriteLine("[CN_MascotaFoto] Falló subida: " + foto.NombreArchivo);
                        continue;
                    }

                    ordenActual++;

                    _cd.Insertar(new MascotasFotoDto
                    {
                        MascotaID = mascotaID,
                        NombreArchivo = foto.NombreArchivo,
                        BlobUrl = url,
                        EsPrincipal = false,   // la principal ya existe
                        Orden = ordenActual,
                        SubidoPor = subidoPor
                    });

                    algunaSubio = true;
                }

                return algunaSubio
                    ? notifyDTO.Exito("Fotos agregadas correctamente.")
                    : notifyDTO.Error("No se pudieron subir las fotos. Intente nuevamente.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_MascotaFoto] Error en AgregarFotos: " + ex.Message);
                return notifyDTO.Error("Error inesperado al subir las fotos.");
            }
        }
    }
}