using capa_dto;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;

namespace capa_datos
{
    public class CD_Perfil
    {
        private ColitasFelicesDataContext cf = new ColitasFelicesDataContext();


        // Select - Listar todos los perfiles
        public List<PerfilDTO> ListarPerfiles(int? estadoFiltro = null)
        {
            try
            {
                IQueryable<PerfilDTO> queryBase =
                    from p in cf.Perfil
                    join c in cf.Cuenta on p.CuentaID equals c.CuentaID into cuentas
                    from c in cuentas.DefaultIfEmpty()
                    select new PerfilDTO
                    {
                        // CUENTA
                        CuentaID = c != null ? c.CuentaID : 0,
                        Email = c != null ? c.Email : null,
                        Rol = c != null ? c.Rol : (byte)0,
                        Estado = c != null ? c.Estado : (byte)0,

                        // PERFIL
                        PerfilID = p.PerfilID,
                        Cedula = p.Cedula,
                        Nombres = p.Nombres,
                        Apellidos = p.Apellidos,
                        Telefono = p.Telefono,
                        Direccion = p.Direccion,
                        FotoPerfil = p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null,
                        PerfilCompleto = p.PerfilCompleto
                    };

                // Filtro por perfil completo / incompleto
                if (estadoFiltro.HasValue)
                {
                    queryBase = queryBase
                        .Where(p => p.PerfilCompleto == estadoFiltro.Value);
                }

                return queryBase
                    .OrderByDescending(p => p.PerfilID)
                    .ToList();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los perfiles: " + ex.Message);
            }
        }

        // =============== OBTENER PERFIL POR ID ===============
        public PerfilDTO ObtenerPerfilPorID(int perfilID)
        {
            try
            {
                var detallesPerfil = (from p in cf.Perfil
                                      join c in cf.Cuenta on p.CuentaID equals c.CuentaID into cuentas
                                      from c in cuentas.DefaultIfEmpty()
                                      where p.PerfilID == perfilID
                                      select new PerfilDTO
                                      {
                                          // CUENTA
                                          CuentaID = c != null ? c.CuentaID : 0,
                                          Email = c != null ? c.Email : null,
                                          Rol = c != null ? c.Rol : (byte)0,
                                          Estado = c != null ? c.Estado : (byte)0,

                                          // PERFIL
                                          PerfilID = p.PerfilID,
                                          Cedula = p.Cedula,
                                          Nombres = p.Nombres,
                                          Apellidos = p.Apellidos,
                                          Telefono = p.Telefono,
                                          Direccion = p.Direccion,
                                          FotoPerfil = p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null,
                                          PerfilCompleto = p.PerfilCompleto
                                      }).FirstOrDefault();

                return detallesPerfil;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener perfil por ID: " + ex.Message);
            }
        }

        public notifyDTO ActualizarPerfil(int perfilID, string cedula, string nombres,
            string apellidos, string telefono, string direccion, byte[] fotoPerfil)
        {
            try
            {
                bool? exitoso = null;
                string mensaje = null;

                cf.SP_ActualizarPerfil(
                    perfilID,
                    cedula,
                    nombres,
                    apellidos,
                    telefono,
                    direccion,
                    fotoPerfil,
                    ref exitoso,
                    ref mensaje
                );

                return new notifyDTO
                {
                    resultado = exitoso ?? false,
                    mensajeSalida = mensaje ?? ""
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al actualizar CD:{ex.Message}");
                return new notifyDTO
                {
                    resultado = false,
                    mensajeSalida = "Error al actualizar perfil: " + ex.Message
                };
            }
        }
    }
}
    
           