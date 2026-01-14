using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_dto
{
    public class PerfilDTO
    {
        // CUENTA
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte Rol { get; set; }       // tinyint
        public byte Estado { get; set; }    // tinyint

        // PERFIL
        public int? PerfilID { get; set; }  // nullable por LEFT JOIN
        public string Cedula { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public byte[] FotoPerfil { get; set; }
        public int? PerfilCompleto { get; set; } // nullable por LEFT JOIN

        // CONSTRUCTOR VACÍO
        public PerfilDTO() { }
    }
}
