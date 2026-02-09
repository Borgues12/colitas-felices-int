using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_dto
{
    /// <summary>
    /// DTO para recibir datos del formulario de registro
    ///</summary>
    public class RegistroRequestDTO
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmarPassword { get; set; }
        public string PrimerNombre { get; set; }
        public string SegundoNombre { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public string Telefono { get; set; }
    }

    /// <summary>
    /// DTO para insertar en registro_temporal
    /// </summary>
    public class RegistroTemporalDTO
    {
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string PrimerNombre { get; set; }
        public string SegundoNombre { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public string Telefono { get; set; }
        public string CodigoVerificacion { get; set; }
        public System.DateTime CodigoExpiracion { get; set; }
    }
}