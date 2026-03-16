using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace capa_datos.Crud
{
    /// <summary>
    /// Gestión de fotos vinculadas a mascotas.
    /// Consulta: Mascota_Foto únicamente.
    /// </summary>
    public class CD_MascotaFoto
    {
        /// <summary>
        /// Inserta una foto y guarda su referencia en BD.
        /// Si es la primera foto de la mascota, se marca principal automáticamente.
        /// Si llega con EsPrincipal = true, desmarca la anterior antes de insertar.
        /// Retorna el FotoID generado, o -1 si falla.
        /// </summary>
        public int Insertar(MascotasFotoDto dto)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    bool esPrimera = !db.Mascota_foto.Any(f => f.MascotaID == dto.MascotaID);

                    if (dto.EsPrincipal && !esPrimera)
                    {
                        var anteriorPrincipal = db.Mascota_foto
                            .Where(f => f.MascotaID == dto.MascotaID && f.EsPrincipal)
                            .ToList();
                        foreach (var f in anteriorPrincipal)
                            f.EsPrincipal = false;
                    }

                    var entidad = new Mascota_foto
                    {
                        MascotaID = dto.MascotaID,
                        NombreArchivo = dto.NombreArchivo,
                        BlobUrl = dto.BlobUrl,
                        EsPrincipal = esPrimera || dto.EsPrincipal,
                        Orden = dto.Orden,
                        FechaSubida = DateTime.Now,
                        SubidoPor = dto.SubidoPor
                    };

                    db.Mascota_foto.InsertOnSubmit(entidad);
                    db.SubmitChanges();
                    return entidad.FotoID;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_MascotaFoto] Error en Insertar: " + ex.Message);
                return -1;
            }
        }

        /// <summary>
        /// Marca una foto como principal y desmarca automáticamente la anterior.
        /// Retorna false si el FotoID no pertenece a la mascota indicada.
        /// </summary>
        public bool MarcarPrincipal(int mascotaID, int fotoID)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var fotos = db.Mascota_foto
                        .Where(f => f.MascotaID == mascotaID)
                        .ToList();

                    if (!fotos.Any(f => f.FotoID == fotoID)) return false;

                    foreach (var f in fotos)
                        f.EsPrincipal = (f.FotoID == fotoID);

                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_MascotaFoto] Error en MarcarPrincipal: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Elimina una foto por su ID.
        /// Si era la principal, promueve la siguiente foto disponible (orden más bajo).
        /// Retorna false si no existe.
        /// </summary>
        public bool Eliminar(int fotoID)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var foto = db.Mascota_foto.FirstOrDefault(f => f.FotoID == fotoID);
                    if (foto == null) return false;

                    bool eraPrincipal = foto.EsPrincipal;
                    int mascotaID = foto.MascotaID;

                    db.Mascota_foto.DeleteOnSubmit(foto);
                    db.SubmitChanges();

                    if (eraPrincipal)
                    {
                        var siguiente = db.Mascota_foto
                            .Where(f => f.MascotaID == mascotaID)
                            .OrderBy(f => f.Orden)
                            .FirstOrDefault();

                        if (siguiente != null)
                        {
                            siguiente.EsPrincipal = true;
                            db.SubmitChanges();
                        }
                    }

                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_MascotaFoto] Error en Eliminar: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Retorna todas las fotos de una mascota ordenadas: principal primero, luego por Orden.
        /// </summary>
        public List<MascotasFotoDto> ObtenerPorMascota(int mascotaID)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Mascota_foto
                        .Where(f => f.MascotaID == mascotaID)
                        .OrderByDescending(f => f.EsPrincipal)
                        .ThenBy(f => f.Orden)
                        .Select(f => new MascotasFotoDto
                        {
                            FotoID = f.FotoID,
                            MascotaID = f.MascotaID,
                            NombreArchivo = f.NombreArchivo,
                            BlobUrl = f.BlobUrl,
                            EsPrincipal = f.EsPrincipal,
                            Orden = f.Orden,
                            FechaSubida = f.FechaSubida,
                            SubidoPor = f.SubidoPor
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_MascotaFoto] Error en ObtenerPorMascota: " + ex.Message);
                return new List<MascotasFotoDto>();
            }
        }
    }
}