using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace capa_datos.Crud
{
    public class CD_Mascota
    {
        /// <summary>
        /// Listado paginado con filtros opcionales.
        /// Trae solo la foto principal por mascota para no sobrecargar la grilla.
        /// SoloVisibles = true filtra por estados con EsVisible = true (para la landing).
        /// </summary>
        public List<MascotaDto> Listar(DTO_MascotaFiltro filtro)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var q = from m in db.Mascota
                            join e in db.Especie on m.EspecieID equals e.EspecieID
                            join r in db.Raza on m.RazaID equals r.RazaID
                            join em in db.Estado_mascota on m.EstadoMascotaID equals em.EstadoMascotaID
                            select new { m, e, r, em };

                    if (filtro.EspecieID.HasValue)
                        q = q.Where(x => x.m.EspecieID == filtro.EspecieID.Value);

                    if (filtro.EstadoMascotaID.HasValue)
                        q = q.Where(x => x.m.EstadoMascotaID == filtro.EstadoMascotaID.Value);

                    if (filtro.EsAdoptable.HasValue)
                        q = q.Where(x => x.m.EsAdoptable == filtro.EsAdoptable.Value);

                    if (filtro.SoloVisibles == true)
                        q = q.Where(x => x.em.EsVisible);

                    if (!string.IsNullOrWhiteSpace(filtro.NombreBusqueda))
                        q = q.Where(x => x.m.Nombre.Contains(filtro.NombreBusqueda.Trim()));

                    int skip = (filtro.Pagina - 1) * filtro.RegistrosPorPagina;

                    var lista = q
                        .OrderByDescending(x => x.m.FechaRegistro)
                        .Skip(skip)
                        .Take(filtro.RegistrosPorPagina)
                        .ToList()
                        .Select(x => new MascotaDto
                        {
                            MascotaID = x.m.MascotaID,
                            Nombre = x.m.Nombre,
                            EspecieID = x.m.EspecieID,
                            EspecieNombre = x.e.Nombre,
                            RazaID = x.m.RazaID,
                            RazaNombre = x.r.Nombre,
                            Sexo = x.m.Sexo,
                            Tamanio = x.m.Tamanio,
                            Color = x.m.Color,
                            FechaNacimientoAprox = x.m.FechaNacimientoAprox,
                            EstadoMascotaID = x.m.EstadoMascotaID,
                            EstadoNombre = x.em.Nombre,
                            EsVisible = x.em.EsVisible,
                            EsAdoptable = x.m.EsAdoptable,
                            Esterilizado = x.m.Esterilizado,
                            FechaRegistro = x.m.FechaRegistro
                        })
                        .ToList();

                    // Foto principal por cada mascota en la lista
                    if (lista.Count > 0)
                    {
                        var ids = lista.Select(m => m.MascotaID).ToList();
                        var fotos = db.Mascota_foto
                            .Where(f => ids.Contains(f.MascotaID) && f.EsPrincipal)
                            .Select(f => new MascotasFotoDto
                            {
                                FotoID = f.FotoID,
                                MascotaID = f.MascotaID,
                                NombreArchivo = f.NombreArchivo,
                                BlobUrl = f.BlobUrl,
                                EsPrincipal = f.EsPrincipal
                            })
                            .ToList();

                        foreach (var m in lista)
                        {
                            var foto = fotos.FirstOrDefault(f => f.MascotaID == m.MascotaID);
                            if (foto != null) m.Fotos.Add(foto);
                        }
                    }

                    return lista;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Mascota] Error en Listar: " + ex.Message);
                return new List<MascotaDto>();
            }
        }

        /// <summary>
        /// Retorna todos los datos de una mascota incluyendo fotos y condiciones.
        /// Retorna null si no existe.
        /// </summary>
        public MascotaDto ObtenerPorId(int mascotaID)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var dato = (from m in db.Mascota
                                join e in db.Especie on m.EspecieID equals e.EspecieID
                                join r in db.Raza on m.RazaID equals r.RazaID
                                join em in db.Estado_mascota on m.EstadoMascotaID equals em.EstadoMascotaID
                                where m.MascotaID == mascotaID
                                select new { m, e, r, em })
                               .FirstOrDefault();

                    if (dato == null) return null;

                    var dto = new MascotaDto
                    {
                        MascotaID = dato.m.MascotaID,
                        Nombre = dato.m.Nombre,
                        EspecieID = dato.m.EspecieID,
                        EspecieNombre = dato.e.Nombre,
                        RazaID = dato.m.RazaID,
                        RazaNombre = dato.r.Nombre,
                        Sexo = dato.m.Sexo,
                        Tamanio = dato.m.Tamanio,
                        Color = dato.m.Color,
                        FechaNacimientoAprox = dato.m.FechaNacimientoAprox,
                        Descripcion = dato.m.Descripcion,
                        EstadoMascotaID = dato.m.EstadoMascotaID,
                        EstadoNombre = dato.em.Nombre,
                        EsVisible = dato.em.EsVisible,
                        EsAdoptable = dato.m.EsAdoptable,
                        Esterilizado = dato.m.Esterilizado,
                        FechaEsterilizacion = dato.m.FechaEsterilizacion,
                        NumeroMicrochip = dato.m.NumeroMicrochip,
                        FechaRegistro = dato.m.FechaRegistro,
                        FechaActualizacion = dato.m.FechaActualizacion,
                        RegistradoPor = dato.m.RegistradoPor
                    };

                    // Fotos — principal primero, luego por Orden
                    dto.Fotos = db.Mascota_foto
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

                    // Condiciones asociadas
                    dto.Condiciones = (from mc in db.Mascota_condicion
                                       join c in db.Condicion_especial on mc.CondicionID equals c.CondicionID
                                       where mc.MascotaID == mascotaID
                                       select new DTO_CondicionEspecial
                                       {
                                           CondicionID = c.CondicionID,
                                           Nombre = c.Nombre,
                                           Seleccionada = true
                                       })
                                      .ToList();

                    return dto;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Mascota] Error en ObtenerPorId: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Inserta una nueva mascota con sus condiciones.
        /// Retorna el MascotaID generado, o -1 si falla.
        /// </summary>
        public int Insertar(MascotaDto dto)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var entidad = new Mascota
                    {
                        Nombre = dto.Nombre.Trim(),
                        EspecieID = dto.EspecieID,
                        RazaID = dto.RazaID,
                        Sexo = dto.Sexo,
                        Tamanio = dto.Tamanio,
                        Color = dto.Color.Trim(),
                        FechaNacimientoAprox = dto.FechaNacimientoAprox,
                        Descripcion = dto.Descripcion?.Trim(),
                        EstadoMascotaID = dto.EstadoMascotaID,
                        EsAdoptable = dto.EsAdoptable,
                        Esterilizado = dto.Esterilizado,
                        FechaEsterilizacion = dto.Esterilizado ? dto.FechaEsterilizacion : null,
                        NumeroMicrochip = string.IsNullOrWhiteSpace(dto.NumeroMicrochip)
                                                   ? null : dto.NumeroMicrochip.Trim(),
                        FechaRegistro = DateTime.Now,
                        RegistradoPor = dto.RegistradoPor
                    };

                    db.Mascota.InsertOnSubmit(entidad);
                    db.SubmitChanges();

                    // Condiciones N:N
                    if (dto.CondicionesSeleccionadas != null && dto.CondicionesSeleccionadas.Count > 0)
                    {
                        foreach (var cid in dto.CondicionesSeleccionadas)
                        {
                            db.Mascota_condicion.InsertOnSubmit(new Mascota_condicion
                            {
                                MascotaID = entidad.MascotaID,
                                CondicionID = cid,
                                FechaRegistro = DateTime.Now
                            });
                        }
                        db.SubmitChanges();
                    }

                    return entidad.MascotaID;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Mascota] Error en Insertar: " + ex.Message);
                return -1;
            }
        }

        /// <summary>
        /// Actualiza datos de una mascota y reemplaza sus condiciones (DELETE + INSERT).
        /// Retorna false si la mascota no existe o si ocurre un error.
        /// </summary>
        public bool Actualizar(MascotaDto dto)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var entidad = db.Mascota.FirstOrDefault(m => m.MascotaID == dto.MascotaID);
                    if (entidad == null) return false;

                    entidad.Nombre = dto.Nombre.Trim();
                    entidad.EspecieID = dto.EspecieID;
                    entidad.RazaID = dto.RazaID;
                    entidad.Sexo = dto.Sexo;
                    entidad.Tamanio = dto.Tamanio;
                    entidad.Color = dto.Color.Trim();
                    entidad.FechaNacimientoAprox = dto.FechaNacimientoAprox;
                    entidad.Descripcion = dto.Descripcion?.Trim();
                    entidad.EstadoMascotaID = dto.EstadoMascotaID;
                    entidad.EsAdoptable = dto.EsAdoptable;
                    entidad.Esterilizado = dto.Esterilizado;
                    entidad.FechaEsterilizacion = dto.Esterilizado ? dto.FechaEsterilizacion : null;
                    entidad.NumeroMicrochip = string.IsNullOrWhiteSpace(dto.NumeroMicrochip)
                                                       ? null : dto.NumeroMicrochip.Trim();
                    entidad.FechaActualizacion = DateTime.Now;

                    // Condiciones: DELETE + INSERT
                    var condicionesActuales = db.Mascota_condicion
                        .Where(mc => mc.MascotaID == dto.MascotaID);
                    db.Mascota_condicion.DeleteAllOnSubmit(condicionesActuales);

                    if (dto.CondicionesSeleccionadas != null && dto.CondicionesSeleccionadas.Count > 0)
                    {
                        foreach (var cid in dto.CondicionesSeleccionadas)
                        {
                            db.Mascota_condicion.InsertOnSubmit(new Mascota_condicion
                            {
                                MascotaID = dto.MascotaID,
                                CondicionID = cid,
                                FechaRegistro = DateTime.Now
                            });
                        }
                    }

                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Mascota] Error en Actualizar: " + ex.Message);
                return false;
            }
        }
    }
}
