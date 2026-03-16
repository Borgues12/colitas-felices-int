using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace capa_datos.Crud
{
    /// <summary>
    /// Catálogos de solo lectura reutilizables por cualquier módulo.
    /// Consulta: Especie, Raza, Estado_Mascota, Condicion_Especial.
    /// </summary>
    public class CD_Catalogo
    {
        /// <summary>
        /// Especies activas — para el dropdown del formulario de mascota.
        /// </summary>
        public List<DTO_Especie> ObtenerEspecies()
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Especie
                        .Where(e => e.Activo)
                        .OrderBy(e => e.Nombre)
                        .Select(e => new DTO_Especie
                        {
                            EspecieID = e.EspecieID,
                            Nombre = e.Nombre,
                            Activo = e.Activo
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Catalogo] Error en ObtenerEspecies: " + ex.Message);
                return new List<DTO_Especie>();
            }
        }

        /// <summary>
        /// Todas las razas activas ordenadas por especie y nombre.
        /// Se precargan en JSON en el front — el JS filtra por EspecieID.
        /// </summary>
        public List<DTO_Raza> ObtenerRazas()
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Raza
                        .Where(r => r.Activo)
                        .OrderBy(r => r.EspecieID)
                        .ThenBy(r => r.Nombre)
                        .Select(r => new DTO_Raza
                        {
                            RazaID = r.RazaID,
                            EspecieID = r.EspecieID,
                            Nombre = r.Nombre,
                            Activo = r.Activo
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Catalogo] Error en ObtenerRazas: " + ex.Message);
                return new List<DTO_Raza>();
            }
        }

        /// <summary>
        /// Estados de mascota activos — para el dropdown del formulario y los filtros.
        /// Incluye EsVisible para que el front pueda indicarlo si necesita.
        /// </summary>
        public List<DTO_EstadoMascota> ObtenerEstadosMascota()
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Estado_mascota
                        .Where(e => e.Activo)
                        .OrderBy(e => e.EstadoMascotaID)
                        .Select(e => new DTO_EstadoMascota
                        {
                            EstadoMascotaID = e.EstadoMascotaID,
                            Nombre = e.Nombre,
                            Descripcion = e.Descripcion,
                            EsVisible = e.EsVisible,
                            Activo = e.Activo
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Catalogo] Error en ObtenerEstadosMascota: " + ex.Message);
                return new List<DTO_EstadoMascota>();
            }
        }

        /// <summary>
        /// Condiciones especiales activas — para los checkboxes del formulario de mascota.
        /// Seleccionada viene en false por defecto; la capa de negocio la activa según la mascota.
        /// </summary>
        public List<DTO_CondicionEspecial> ObtenerCondiciones()
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Condicion_especial
                        .Where(c => c.Activo)
                        .OrderBy(c => c.Nombre)
                        .Select(c => new DTO_CondicionEspecial
                        {
                            CondicionID = c.CondicionID,
                            Nombre = c.Nombre,
                            Activo = c.Activo,
                            Seleccionada = false
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Catalogo] Error en ObtenerCondiciones: " + ex.Message);
                return new List<DTO_CondicionEspecial>();
            }
        }

        /// <summary>
        /// UPSERT de razas recibidas desde la API externa (Dog API / Cat API).
        /// Solo inserta las que no existen por nombre + especie.
        /// Empieza en ID 20 para no pisar el seed inicial (IDs 1-16).
        /// Se llama una sola vez desde el botón del panel admin.
        /// </summary>
        public bool GuardarRazasDesdeApi(List<DTO_Raza> razasNuevas)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    short proximoId = db.Raza.Any()
                        ? (short)(db.Raza.Max(r => (int)r.RazaID) + 1)
                        : (short)20;

                    foreach (var nueva in razasNuevas)
                    {
                        bool existe = db.Raza.Any(r =>
                            r.EspecieID == nueva.EspecieID &&
                            r.Nombre == nueva.Nombre);

                        if (existe) continue;

                        db.Raza.InsertOnSubmit(new Raza
                        {
                            RazaID = proximoId++,
                            EspecieID = nueva.EspecieID,
                            Nombre = nueva.Nombre,
                            Activo = true
                        });
                    }

                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Catalogo] Error en GuardarRazasDesdeApi: " + ex.Message);
                return false;
            }
        }
    }
}