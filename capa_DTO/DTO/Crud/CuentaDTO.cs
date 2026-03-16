using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_DTO.DTO.Crud
{
    public class DTO_CuentaPerfil
    {
        // Cuenta
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte RolID { get; set; }
        public byte Estado { get; set; }

        // Perfil
        public string PrimerNombre { get; set; }
        public string SegundoNombre { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public string TelefonoPrincipal { get; set; }

        // Calculado
        public string NombreCompleto =>
            $"{PrimerNombre} {PrimerApellido}".Trim();
    }
}
