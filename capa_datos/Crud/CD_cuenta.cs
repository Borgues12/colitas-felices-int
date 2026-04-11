using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using capa_dto.DTO.Crud;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos.Crud
{
    public class CD_cuenta
    {
        /// <summary>
        /// Lista cuentas con datos básicos del perfil y rol.
        /// Soporta búsqueda por nombre, email o cédula y filtro por rol/estado.
        /// </summary>
        public List<CuentaAdminDTO> Listar(CuentaFiltroDTO filtro)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var query = db.Cuenta
                        .Join(db.Perfil,
                            c => c.CuentaID,
                            p => p.CuentaID,
                            (c, p) => new { c, p })
                        .Join(db.Rol,
                            cp => cp.c.RolID,
                            r => r.RolID,
                            (cp, r) => new { cp.c, cp.p, r });

                    // Filtro por rol
                    if (filtro.RolID.HasValue)
                        query = query.Where(x => x.c.RolID == filtro.RolID.Value);

                    // Filtro por estado
                    //Maneja el receptar numeros o el estado Activo, Bloqueado o Inactivo
                    if (!string.IsNullOrEmpty(filtro.Estado))
                    {
                        if (Enum.TryParse<EstadoEnum>(filtro.Estado, true, out EstadoEnum estadoEnum))
                        {
                            query = query.Where(x => x.c.Estado == (byte)estadoEnum);
                        }
                        else if (byte.TryParse(filtro.Estado, out byte estadoByte))
                        {
                            query = query.Where(x => x.c.Estado == estadoByte);
                        }
                    }

                    // Búsqueda libre: nombre, email o cédula
                    if (!string.IsNullOrEmpty(filtro.Busqueda))
                    {
                        string busq = filtro.Busqueda.Trim().ToLower();
                        query = query.Where(x =>
                            x.p.PrimerNombre.ToLower().Contains(busq) ||
                            x.p.PrimerApellido.ToLower().Contains(busq) ||
                            x.c.Email.ToLower().Contains(busq) ||
                            x.p.NumeroIdentificacion.Contains(busq));
                    }

                    return query
                        .OrderByDescending(x => x.c.FechaRegistro)
                        .Select(x => new CuentaAdminDTO
                        {
                            CuentaID = x.c.CuentaID,
                            Email = x.c.Email,
                            RolID = (byte)x.c.RolID,
                            RolNombre = x.r.Nombre,
                            Estado = ((EstadoEnum)x.c.Estado),
                            FechaRegistro = x.c.FechaRegistro,
                            UltimoAcceso = x.c.UltimoAcceso,
                            PrimerNombre = x.p.PrimerNombre,
                            PrimerApellido = x.p.PrimerApellido,
                            NumeroIdentificacion = x.p.NumeroIdentificacion,
                            TelefonoPrincipal = x.p.TelefonoPrincipal
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_CuentaAdmin] Error en Listar: " + ex.Message);
                return new List<CuentaAdminDTO>();
            }
        }

        /// <summary>
        /// Cambia el rol de una cuenta. Retorna true si se actualizó correctamente.
        /// </summary>
        public bool CambiarRol(int cuentaId, byte nuevoRolId)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
                    if (cuenta == null) return false;

                    cuenta.RolID = nuevoRolId;
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_CuentaAdmin] Error en CambiarRol: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Busca una cuenta por email — retorna null si no existe
        /// </summary>
        public DTO_CuentaPerfil ObtenerPorEmail(string email)
        {
            try
            {
                email = email.Trim().ToLower();
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Cuenta
                        .Where(c => c.Email == email)
                        .Join(db.Perfil,
                            c => c.CuentaID,
                            p => p.CuentaID,
                            (c, p) => new DTO_CuentaPerfil
                            {
                                CuentaID = c.CuentaID,
                                Email = c.Email,
                                RolID = c.RolID,
                                Estado = c.Estado,
                                PrimerNombre = p.PrimerNombre,
                                SegundoNombre = p.SegundoNombre,
                                PrimerApellido = p.PrimerApellido,
                                SegundoApellido = p.SegundoApellido,
                                TelefonoPrincipal = p.TelefonoPrincipal
                            })
                        .FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Cuenta] Error en ObtenerPorEmail: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Reemplaza el hash de contraseña — solo se llama tras validar el token
        /// </summary>
        public bool ActualizarPassword(int cuentaId, string nuevoHash)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
                    if (cuenta == null) return false;

                    cuenta.PasswordHash = nuevoHash;
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Cuenta]Error en ActualizarPassword: " + ex.Message);
                return false;
            }
        }
    }
}