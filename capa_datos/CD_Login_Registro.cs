using capa_dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos
{
    public class CD_Login_Registro
    {
        private ColitasFelicesDataContext cf = new ColitasFelicesDataContext();

        // Método para verificar login
        public CuentaDTO VerificarLogin(string email, string password)
        {
            try
            {
                bool? loginExitoso = null;
                int? cuentaID = null;
                byte? rolUsuario = null;
                string mensaje = null;

                cf.SP_VerificarLogin(
                    email,
                    password,
                    ref loginExitoso,
                    ref cuentaID,
                    ref rolUsuario,
                    ref mensaje
                );

                return new CuentaDTO
                {
                    LoginExitoso = loginExitoso ?? false,
                    CuentaID = cuentaID ?? 0,
                    Rol = rolUsuario ?? 0,
                    Mensaje = mensaje ?? ""
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en VerificarLogin: " + ex.Message);
                return new CuentaDTO
                {
                    LoginExitoso = false,
                    Mensaje = "Error: " + ex.Message
                };

            }
        }
        // Método para registrar nuevo usuario

        //Metodo para cargar datos en MASTER PAGE del usuario logueado

        public PerfilDTO CargarDatosUsuario(int cuentaID)
        {
            try
            {
                var datosUsuario = (from c in cf.Cuenta
                                    join p in cf.Perfil on c.CuentaID equals p.CuentaID into perfiles
                                    from p in perfiles.DefaultIfEmpty()
                                    where c.CuentaID == cuentaID
                                    select new PerfilDTO
                                    {
                                        Email = c.Email,
                                        Rol = c.Rol,
                                        Nombres = p != null ? p.Nombres : null,
                                        Apellidos = p != null ? p.Apellidos : null,
                                        FotoPerfil = p != null && p.FotoPerfil != null ? p.FotoPerfil.ToArray() : null,
                                    }).FirstOrDefault();

                return datosUsuario;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CargarDatosUsuario: " + ex.Message);
                throw new Exception("Error al cargar datos del usuario: " + ex.Message);
            }
        }


        // Método para verificar login con Google
        public GoogleLoginDTO LoginGoogle(string googleID, string email, string nombre)
        {
            try
            {
                int? cuentaID = null;
                byte? rolUsuario = null;
                bool? requiereCompletarPerfil = null;
                bool? esNuevoUsuario = null;
                bool? exitoso = null;
                string mensaje = null;

                cf.SP_LoginGoogle(
                    googleID,
                    email,
                    nombre,
                    ref cuentaID,
                    ref rolUsuario,
                    ref requiereCompletarPerfil,
                    ref esNuevoUsuario,
                    ref exitoso,
                    ref mensaje
                );

                return new GoogleLoginDTO
                {
                    GoogleID = googleID,
                    Email = email,
                    Nombre = nombre,
                    CuentaID = cuentaID ?? 0,
                    Rol = rolUsuario ?? 0,
                    RequiereCompletarPerfil = requiereCompletarPerfil ?? true,
                    EsNuevoUsuario = esNuevoUsuario ?? false,
                    Exitoso = exitoso ?? false,
                    Mensaje = mensaje ?? ""
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en LoginGoogle: " + ex.Message);
                return new GoogleLoginDTO
                {
                    Exitoso = false,
                    Mensaje = "Error: " + ex.Message
                };
            }
        }
    }
}
