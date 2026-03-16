using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos.Seguridad
{
    public class CD_TokenRecuperacion
    {

        /// <summary>
        /// Invalida todos los tokens vigentes de recuperación para esa cuenta
        /// antes de crear uno nuevo — evita que haya dos códigos válidos al mismo tiempo
        /// </summary>
        public bool InvalidarTokensAnteriores(int cuentaId)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var tokens = db.Cuenta_token_recuperacion
                        .Where(t => t.CuentaID == cuentaId && !t.Usado);

                    foreach (var token in tokens)
                        token.Usado = true;

                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en InvalidarTokensAnteriores: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Crea un nuevo token de recuperación en BD
        /// </summary>
        public bool Crear(int cuentaId, string codigo, int duracionMin)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var token = new Cuenta_token_recuperacion
                    {
                        CuentaID = cuentaId,
                        TipoID = (byte)capa_DTO.DTO.Seguridad.TokenTipo.RecuperarPassword,
                        Codigo = codigo,
                        FechaExpira = DateTime.Now.AddMinutes(duracionMin),
                        Usado = false,
                        FechaCreacion = DateTime.Now
                    };

                    db.Cuenta_token_recuperacion.InsertOnSubmit(token);
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en Crear token recuperacion: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Busca un token válido — no usado y no expirado — para esa cuenta y código
        /// </summary>
        public Cuenta_token_recuperacion ObtenerValido(int cuentaId, string codigo)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())

                {
                    return db.Cuenta_token_recuperacion
                    .FirstOrDefault(t =>
                        t.CuentaID == cuentaId &&
                        t.Codigo == codigo &&
                        !t.Usado &&
                        t.FechaExpira > DateTime.Now);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ObtenerValido: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Marca el token como usado — se llama después de cambiar la contraseña
        /// </summary>
        public bool MarcarUsado(int tokenId)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var token = db.Cuenta_token_recuperacion
                    .FirstOrDefault(t => t.TokenID == tokenId);

                    if (token == null) return false;

                    token.Usado = true;
                    token.FechaUso = DateTime.Now;
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en MarcarUsado: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Verifica si ya existe un token vigente para esa cuenta
        /// — evita spam de correos
        /// </summary>
        public bool TieneTokenVigente(int cuentaId)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    return db.Cuenta_token_recuperacion
                    .Any(t =>
                        t.CuentaID == cuentaId &&
                        !t.Usado &&
                        t.FechaExpira > DateTime.Now);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en TieneTokenVigente: " + ex.Message);
                return false;
            }
        }
    }
}