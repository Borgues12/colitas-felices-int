//using System;
//using System.Linq;
//using capa_dto;

//namespace capa_datos
//{
//    public class CD_Cuenta
//    {
//        private ColitasFelicesDataContext db = new ColitasFelicesDataContext();


//        /// Verifica si un email ya está registrado
//        public CuentaInfoDTO ObtenerPorEmail(string email)
//        {
//            try
//            {
//                email = email.Trim().ToLower();

//                return (from c in db.Cuenta
//                        where c.Email == email
//                        select new CuentaInfoDTO
//                        {
//                            CuentaID = c.CuentaID,
//                            Estado = c.Estado,
//                            GoogleID = c.GoogleID
//                        }).FirstOrDefault();
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CD_Cuenta.Insertar: " + ex.Message);
//                return null;
//            }
//        }

//        // Obtener datos para verificación de cuenta
//        public CuentaDetailsDTO ObtenerParaVerificacion(int cuentaId)
//        {
//            return (from c in db.Cuenta
//                    join p in db.Perfil on c.CuentaID equals p.CuentaID
//                    where c.CuentaID == cuentaId
//                    select new CuentaDetailsDTO
//                    {
//                        CuentaID = c.CuentaID,
//                        Email = c.Email,
//                        Estado = c.Estado,
//                        TokenVerificacion = c.TokenVerificacion,
//                        TokenExpiracion = c.TokenExpiracion,
//                        ReenviosVerificacion = c.ReenviosVerificacion ?? 0,
//                        UltimoReenvioVerificacion = c.UltimoReenvioVerificacion
//                    }).FirstOrDefault();
//        }

//        //SP para registrar nueva cuenta
//        public int Insertar(string email, string passwordHash, string primerNombre, string primerApellido, string cedula, string telefono, string token)
//        {
//            try
//            {
//                int? cuentaID = null;

//                db.SEG_Cuenta_Insertar(
//                    email,
//                    passwordHash,
//                    primerNombre,
//                    primerApellido,
//                    cedula,
//                    telefono,
//                    token,
//                    ref cuentaID
//                );

//                return cuentaID ?? 0;
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CD_Cuenta.Insertar: " + ex.Message);
//                return 0;
//            }
//        }

//        public bool Verificar(int cuentaId)
//        {
//            try
//            {
//                var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
//                if (cuenta == null) return false;

//                cuenta.Estado = 1;
//                cuenta.TokenVerificacion = null;
//                cuenta.TokenExpiracion = null;

//                db.SubmitChanges();
//                return true;
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en Verificar: " + ex.Message);
//                return false;
//            }
//        }

//        public bool ActualizarToken(int cuentaId, string token)
//        {
//            try
//            {
//                var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
//                if (cuenta == null) return false;

//                cuenta.TokenVerificacion = token;
//                cuenta.TokenExpiracion = DateTime.Now.AddMinutes(15);
//                cuenta.ReenviosVerificacion = (byte)((cuenta.ReenviosVerificacion ?? 0) + 1);
//                cuenta.UltimoReenvioVerificacion = DateTime.Now;

//                db.SubmitChanges();
//                return true;
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en ActualizarToken: " + ex.Message);
//                return false;
//            }
//        }

//        public bool ExisteEmail(string email)
//        {
//            email = email.Trim().ToLower();
//            return db.Cuenta.Any(c => c.Email == email);
//        }

//        public bool CambiarEmail(int cuentaId, string nuevoEmail, string token)
//        {
//            try
//            {
//                var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
//                if (cuenta == null) return false;

//                cuenta.Email = nuevoEmail.Trim().ToLower();
//                cuenta.TokenVerificacion = token;
//                cuenta.TokenExpiracion = DateTime.Now.AddMinutes(15);
//                cuenta.ReenviosVerificacion = (byte)((cuenta.ReenviosVerificacion ?? 0) + 1);
//                cuenta.UltimoReenvioVerificacion = DateTime.Now;

//                db.SubmitChanges();
//                return true;
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CambiarEmail: " + ex.Message);
//                return false;
//            }
//        }
//    }
//}

////using System;
////using System.Collections.Generic;
////using System.Linq;
////using System.Data.Linq;
////using System.Text;
////using System.Threading.Tasks;
////using System.Data;
////using capa_dto;

////namespace capa_datos
////{
////    public class CD_Cuenta
////    {
////        private ColitasFelicesDataContext cf = new ColitasFelicesDataContext();

////        // Constantes para mapear valores byte
////        public const byte ROL_ADMIN = 1;
////        public const byte ROL_USUARIO = 2;
////        public const byte ESTADO_ACTIVO = 1;
////        public const byte ESTADO_BLOQUEADO = 2;
////        public const byte ESTADO_PENDIENTE = 3;


////        // SELECT - Listar todas las cuentas
////        public List<UsuarioCuentaDTO> ListarCuentas(byte? estadoFiltro = null)
////        {
////            try
////            {
////                IQueryable<UsuarioCuentaDTO> queryBase = from c in cf.Cuenta
////                                                         join p in cf.Perfil on c.CuentaID equals p.CuentaID into perfiles
////                                                         from p in perfiles.DefaultIfEmpty()
////                                                         select new UsuarioCuentaDTO
////                                                         {
////                                                             CuentaID = c.CuentaID,
////                                                             Email = c.Email,
////                                                             Rol = c.Rol,
////                                                             Estado = c.Estado,
////                                                             UltimoAcceso = c.UltimoAcceso,
////                                                             Nombres = p != null ? p.Nombres : "Sin Nombre",
////                                                             Apellidos = p != null ? p.Apellidos : "",
////                                                             FotoPerfil = p != null && p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null
////                                                         };

////                // Filtrar por estado si se desea
////                if (estadoFiltro.HasValue)
////                {
////                    queryBase = queryBase.Where(c => c.Estado == estadoFiltro.Value);
////                }

////                var query = queryBase.OrderByDescending(c => c.UltimoAcceso);
////                return query.ToList();
////            }
////            catch (Exception ex)
////            {
////                throw new Exception("Error al listar las cuentas: " + ex.Message);
////            }
////        }

////        // Buscar cuentas por término
////        public List<UsuarioCuentaDTO> BuscarCuentas(string termino)
////        {
////            try
////            {
////                IQueryable<UsuarioCuentaDTO> queryBase = from c in cf.Cuenta
////                                                         join p in cf.Perfil on c.CuentaID equals p.CuentaID into perfiles
////                                                         from p in perfiles.DefaultIfEmpty()
////                                                         select new UsuarioCuentaDTO
////                                                         {
////                                                             CuentaID = c.CuentaID,
////                                                             Email = c.Email,
////                                                             Rol = c.Rol,
////                                                             Estado = c.Estado,
////                                                             UltimoAcceso = c.UltimoAcceso,
////                                                             Nombres = p != null ? p.Nombres : "Sin Nombre",
////                                                             Apellidos = p != null ? p.Apellidos : "",
////                                                             Cedula = p != null ? p.Cedula : "",
////                                                             FotoPerfil = p != null && p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null
////                                                         };

////                // Si hay término de búsqueda, filtrar
////                if (!string.IsNullOrWhiteSpace(termino))
////                {
////                    termino = termino.Trim().ToLower();

////                    queryBase = queryBase.Where(u =>
////                        u.Email.ToLower().Contains(termino) ||
////                        u.Nombres.ToLower().Contains(termino) ||
////                        u.Apellidos.ToLower().Contains(termino) ||
////                        (u.Nombres + " " + u.Apellidos).ToLower().Contains(termino) ||
////                        u.Cedula.Contains(termino) ||
////                        // Búsqueda por rol
////                        (termino.Contains("admin") && u.Rol == 1) ||
////                        (termino.Contains("voluntario") && u.Rol == 2) ||
////                        (termino.Contains("adoptante") && u.Rol == 3)
////                    );
////                }

////                return queryBase.OrderByDescending(c => c.UltimoAcceso).ToList();
////            }
////            catch (Exception ex)
////            {
////                throw new Exception("Error al buscar cuentas: " + ex.Message);
////            }
////        }

////        // Update - Cambiar estado de una cuenta
////        public notifyVarDTO CambiarEstadoCuenta(int cuentaID, byte nuevoEstado)
////        {
////            try
////            {
////                bool? resultado = null;      // ✅ Ahora es bool
////                byte? codigo = null;
////                string mensaje = null;

////                cf.SP_CambiarEstadoCuenta(
////                    cuentaID,
////                    nuevoEstado,
////                    ref resultado,
////                    ref codigo,
////                    ref mensaje
////                );

////                return new notifyVarDTO
////                {
////                    resultado2 = resultado ?? false,  // true/false directamente
////                    codigo = codigo ?? 0,
////                    mensajeSalida2 = mensaje ?? ""
////                };
////            }
////            catch (Exception ex)
////            {
////                System.Diagnostics.Debug.WriteLine($"Error al cambiar estado: {ex.Message}");
////                return new notifyVarDTO
////                {
////                    resultado2 = false,
////                    codigo = 0,
////                    mensajeSalida2 = "Error al cambiar el estado de la cuenta"
////                };
////            }
////        }

////        // ========== METODO PARA CONTAR CUANTOS ADMIN QUEDAN CON ESTADO ACTIVO ==========
////        //esto para validar el cambio de estilo en el front
////        public int ContarAdministradoresActivos()
////        {
////            try
////            {
////                // Usando LINQ para contar admins activos
////                int totalAdmins = (from c in cf.Cuenta
////                                   where c.Rol == 1 && c.Estado == 1
////                                   select c).Count();

////                return totalAdmins;
////            }
////            catch (Exception ex)
////            {
////                System.Diagnostics.Debug.WriteLine($"Error al contar administradores activos: {ex.Message}");
////                return 0; // Por seguridad, retorna 0 si hay error
////            }
////        }


////        // =============== OBTENER POR ID ===============
////        public UsuarioCuentaDTO ObtenerCuentaPorID(int cuentaID)
////        {
////            try
////            {
////                var detallesCuenta = (from c in cf.Cuenta
////                                      join p in cf.Perfil on c.CuentaID equals p.CuentaID into perfiles
////                                      from p in perfiles.DefaultIfEmpty()
////                                      where c.CuentaID == cuentaID
////                                      select new UsuarioCuentaDTO
////                                      {
////                                          CuentaID = cuentaID,
////                                          Email = c.Email,
////                                          Rol = c.Rol,
////                                          Estado = c.Estado,
////                                          Cedula = p != null ? p.Cedula : "",
////                                          Nombres = p != null ? p.Nombres : "Sin Nombre",
////                                          Apellidos = p != null ? p.Apellidos : "",
////                                          Telefono = p != null ? p.Telefono : "",
////                                          Direccion = p != null ? p.Direccion : "",
////                                          FotoPerfil = p != null && p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null
////                                      }).FirstOrDefault();
////                return detallesCuenta;
////            }
////            catch (Exception ex)
////            {
////                throw new Exception("Error al obtener cuenta por ID: " + ex.Message);
////            }
////        }

////        // ================== CREAR CUENTA =============
////        public notifyDTO CrearCuenta(CrearCuentaDTO nuevaCuenta)
////        {
////            try
////            {
////                // Variables para los parámetros OUTPUT
////                int? cuentaID = null;
////                int? perfilID = null;
////                bool? exitoso = null;
////                string mensaje = null;

////                // Convertir byte[] a Binary para LINQ to SQL (si hay foto)
////                Binary fotoBinaria = nuevaCuenta.FotoPerfil != null
////                    ? new Binary(nuevaCuenta.FotoPerfil)
////                    : null;

////                // Llamar al Stored Procedure
////                int returnValue = cf.SP_CrearUsuario_Admin(
////                    nuevaCuenta.Email,
////                    nuevaCuenta.Password,
////                    nuevaCuenta.Rol,
////                    nuevaCuenta.Cedula,
////                    nuevaCuenta.Nombres,
////                    nuevaCuenta.Apellidos,
////                    nuevaCuenta.Telefono,
////                    nuevaCuenta.Direccion,
////                    fotoBinaria,
////                    ref cuentaID,
////                    ref perfilID,
////                    ref exitoso,
////                    ref mensaje
////                );

////                return new notifyDTO
////                {
////                    resultado = exitoso ?? false,
////                    mensajeSalida = mensaje ?? "Operación completada"
////                };
////            }
////            catch (Exception ex)
////            {
////                System.Diagnostics.Debug.WriteLine($"Error al crear cuenta: {ex.Message}");
////                return new notifyDTO
////                {
////                    resultado = false,
////                    mensajeSalida = $"Error al crear cuenta: {ex.Message}"
////                };
////            }
////        }



////        //=========CAMBIAR ROL ===========
////        public notifyDTO CambiarRol(int cuentaID, byte nuevoRol)
////        {
////            try
////            {
////                bool? exitoso = null;
////                string mensaje = null;

////                cf.SP_CambiarRol(cuentaID, nuevoRol, ref exitoso, ref mensaje);

////                return new notifyDTO
////                {
////                    resultado = exitoso ?? false,
////                    mensajeSalida = mensaje ?? ""
////                };
////            }
////            catch (Exception ex)
////            {
////                System.Diagnostics.Debug.WriteLine($"Error al cambiar rol: {ex.Message}");
////                return new notifyDTO
////                {
////                    resultado = false,
////                    mensajeSalida = "Error al cambiar rol"
////                };
////            }
////        }



////        // ============= ELIMINAR ==============
////        public notifyDTO EliminarCuenta(int cuentaID)
////        {
////            try
////            {
////                bool? exitoso = null;
////                string mensaje = null;

////                int returnValue = cf.SP_EliminarCuenta(
////                    cuentaID,
////                    ref exitoso,
////                    ref mensaje
////                );

////                return new notifyDTO
////                {
////                    resultado = exitoso ?? false,
////                    mensajeSalida = mensaje ?? "Operación completada sin mensaje"
////                };
////            }
////            catch (Exception ex)
////            {
////                System.Diagnostics.Debug.WriteLine($"Error al eliminar cuenta: {ex.Message}");
////                return new notifyDTO
////                {
////                    resultado = false,
////                    mensajeSalida = $"Error al eliminar cuenta: {ex.Message}"
////                };
////            }
////        }

////        // Métodos auxiliares para convertir valores
////        public string ObtenerNombreRol(byte rol)
////        {
////            switch (rol)
////            {
////                case ROL_ADMIN:
////                    return "Administrador";
////                case ROL_USUARIO:
////                    return "Usuario";
////                default:
////                    return "Desconocido";
////            }
////        }

////        public string ObtenerNombreEstado(byte estado)
////        {
////            switch (estado)
////            {
////                case ESTADO_ACTIVO:
////                    return "Activo";
////                case ESTADO_BLOQUEADO:
////                    return "Bloqueado";
////                case ESTADO_PENDIENTE:
////                    return "Pendiente";
////                default:
////                    return "Desconocido";
////            }
////        }
////    }
////}