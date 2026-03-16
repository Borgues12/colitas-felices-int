using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos.Crud
{
    public class CD_cuenta
    {
        private ColitasFelicesDataContext db = new ColitasFelicesDataContext();

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
                var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == cuentaId);
                if (cuenta == null) return false;

                cuenta.PasswordHash = nuevoHash;
                db.SubmitChanges();
                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_Cuenta]Error en ActualizarPassword: " + ex.Message);
                return false;
            }
        }
    }
}