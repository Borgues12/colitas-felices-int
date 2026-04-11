using capa_datos.Crud;
using capa_dto;
using capa_dto.DTO.Crud;
using System.Collections.Generic;

namespace capa_negocio.Crud
{
    public class CN_CuentaAdmin
    {
        private CD_cuenta datos = new CD_cuenta();

        /// <summary>
        /// Lista cuentas con filtro opcional
        /// </summary>
        public List<CuentaAdminDTO> Listar(CuentaFiltroDTO filtro)
        {
            if (filtro == null)
                filtro = new CuentaFiltroDTO();

            return datos.Listar(filtro);
        }

        /// <summary>
        /// Alterna el rol de una cuenta: si es Usuario (1) pasa a Administrador (2) y viceversa.
        /// Valida que no se pueda cambiar el rol de la propia cuenta del admin logueado.
        /// </summary>
        public notifyDTO CambiarRol(int cuentaId, int cuentaLogueadaId)
        {
            if (cuentaId == cuentaLogueadaId)
                return notifyDTO.Error("No puedes cambiar tu propio rol.");

            // Obtener la cuenta para saber su rol actual
            var filtro = new CuentaFiltroDTO();
            var cuentas = datos.Listar(filtro);
            var cuenta = cuentas.Find(c => c.CuentaID == cuentaId);

            if (cuenta == null)
                return notifyDTO.Error("Cuenta no encontrada.");

            // Alternar: 1 (Usuario) ↔ 2 (Administrador)
            byte nuevoRol = cuenta.RolID == 1 ? (byte)2 : (byte)1;

            bool ok = datos.CambiarRol(cuentaId, nuevoRol);
            if (!ok)
                return notifyDTO.Error("Error al actualizar el rol.");

            string rolTexto = nuevoRol == 1 ? "Usuario" : "Administrador";
            return notifyDTO.Exito(
                $"{cuenta.NombreCompleto} ahora es {rolTexto}.");
        }
    }
}