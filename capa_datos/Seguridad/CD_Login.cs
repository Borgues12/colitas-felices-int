using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos.Seguridad
{
    public class CD_Login
    {
        //Instancia de la base de datos
        private ColitasFelicesDataContext db = new ColitasFelicesDataContext();

        private readonly int[] TIEMPOS_BLOQUEO = { 1, 2, 3 };
        private const int MAX_INTENTOS = 3;

        #region LOGIN

        /// <summary>
        /// Busca una cuenta activa por email y retorna los datos necesarios para autenticación.
        /// Retorna null si el email no existe o la cuenta está bloqueada/inactiva.
        /// </summary>
        public Cuenta ObtenerCuentaPorEmail(string email)
        {
            email = email.Trim().ToLower();

            return db.Cuenta
                .FirstOrDefault(c => c.Email == email);
        }

        /// <summary>
        /// Incrementa el contador de intentos fallidos.
        /// Si llega a 3, registra la fecha de bloqueo (15 minutos).
        /// </summary>
        public void RegistrarIntentoFallido(int idCuenta)
        {
            var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == idCuenta);
            if (cuenta == null) return;

            cuenta.IntentosFallidos += 1;

            if (cuenta.IntentosFallidos >= MAX_INTENTOS)
            {
                cuenta.VecesBloqueo += 1;

                int indice = cuenta.VecesBloqueo - 1;

                // Si supera el array, usa el último valor (mantiene 60 min en adelante)
                if (indice >= TIEMPOS_BLOQUEO.Length)
                    indice = TIEMPOS_BLOQUEO.Length - 1;

                int minutosBloqueo = TIEMPOS_BLOQUEO[indice];

                cuenta.BloqueadoHasta = DateTime.Now.AddMinutes(minutosBloqueo);

                // Reiniciar intentos después de bloquear
                cuenta.IntentosFallidos = 0;

                cuenta.Estado = 0;
            }

            db.SubmitChanges();
        }

        /// <summary>
        /// Reinicia los intentos fallidos y el bloqueo tras un login exitoso.
        /// </summary>
        public void ReiniciarIntentos(int idCuenta)
        {
            var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == idCuenta);
            if (cuenta == null) return;

            cuenta.IntentosFallidos = 0;
            cuenta.BloqueadoHasta = null;
            cuenta.VecesBloqueo = 0;
            cuenta.UltimoAcceso = DateTime.Now;

            db.SubmitChanges();
        }

        /// <summary>
        /// Verifica si el bloqueo temporal expiró y reactiva la cuenta automáticamente.
        /// Llamar ANTES de validar credenciales.
        /// </summary>
        public void VerificarYDesbloquear(int idCuenta)
        {
            var cuenta = db.Cuenta.FirstOrDefault(c => c.CuentaID == idCuenta);
            if (cuenta == null) return;

            // Si estaba bloqueada y ya pasó el tiempo → reactivar
            if (cuenta.Estado == 0
                && cuenta.BloqueadoHasta.HasValue
                && cuenta.BloqueadoHasta.Value <= DateTime.Now)
            {
                cuenta.Estado = 1;
                cuenta.BloqueadoHasta = null;
                cuenta.IntentosFallidos = 0;
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
