using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_DTO.DTO.Seguridad
{
    public enum TokenTipo
    {
        RecuperarPassword = 1,
        RecordarSesion = 2
    }

    public class RecuperacionPaso2DTO
    {
        public string Email { get; set; }
        public string Codigo { get; set; }
    }

    public class RecuperacionPaso3DTO
    {
        public string Email { get; set; }
        public string Codigo { get; set; }
        public string NuevaPassword { get; set; }
        public string ConfirmarPassword { get; set; }
    }
}
