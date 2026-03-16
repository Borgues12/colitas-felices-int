using capa_DTO.DTO.Seguridad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace capa_datos.Seguridad
{
    public class CD_LoginGoogle
    {
        private ColitasFelicesDataContext db = new ColitasFelicesDataContext();

        /// <summary>
        /// Busca cuenta por GoogleID
        /// </summary>
        public Cuenta ObtenerCuentaPorGoogleID(string googleId)
        {
            try
            {
                return db.Cuenta.FirstOrDefault(c => c.GoogleID == googleId && c.Estado == 1);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error ObtenerCuentaPorGoogleID: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Busca cuenta por Email
        /// </summary>
        public Cuenta ObtenerCuentaPorEmail(string email)
        {
            try
            {
                return db.Cuenta.FirstOrDefault(c => c.Email == email && c.Estado == 1);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error ObtenerCuentaPorEmail: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Vincula GoogleID a cuenta existente
        /// </summary>
        public bool VincularGoogleID(int cuentaId, string googleId)
        {
            try
            {
                var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
                if (cuenta == null) return false;

                cuenta.GoogleID = googleId;
                db.SubmitChanges();
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error VincularGoogleID: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Crea cuenta nueva desde Google y descarga foto
        /// </summary>
        public async Task<int> CrearCuentaGoogle(GoogleUserDTO googleUser)
        {
            try
            {
                // Descargar foto si existe
                byte[] foto = null;
                if (!string.IsNullOrEmpty(googleUser.FotoURL))
                {
                    using (var http = new HttpClient())
                    {
                        foto = await http.GetByteArrayAsync(googleUser.FotoURL);
                    }
                }

                // Crear cuenta
                var nuevaCuenta = new Cuenta
                {
                    Email = googleUser.Email.Trim().ToLower(),
                    PasswordHash = null, // no tiene password, entró con Google
                    GoogleID = googleUser.GoogleID,
                    RolID = 1,
                    Estado = 1,
                    FechaRegistro = DateTime.Now
                };

                db.Cuenta.InsertOnSubmit(nuevaCuenta);
                db.SubmitChanges();

                // Crear perfil
                var nuevoPerfil = new Perfil
                {
                    CuentaID = nuevaCuenta.CuentaID,
                    PrimerNombre = googleUser.PrimerNombre ?? "Usuario",
                    SegundoNombre = null,
                    PrimerApellido = googleUser.PrimerApellido ?? "",
                    SegundoApellido = null,
                    TelefonoPrincipal = null,
                    Foto = foto,
                    FechaRegistro = DateTime.Now
                };

                db.Perfil.InsertOnSubmit(nuevoPerfil);
                db.SubmitChanges();

                return nuevaCuenta.CuentaID;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CrearCuentaGoogle: " + ex.Message);
                return 0;
            }
        }


    }
}
