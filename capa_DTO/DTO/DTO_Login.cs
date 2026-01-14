using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_dto
{
    // DTO para login
    public class CuentaDTO
    {
        // PROPIEDADES
        public bool LoginExitoso { get; set; }
        public int CuentaID { get; set; }
        public byte Rol { get; set; }          // tinyint
        public string Mensaje { get; set; }

        // CONSTRUCTOR VACÍO
        public CuentaDTO() { }
    }

    // DTO para login con Google
    public class GoogleLoginDTO
    {
        // Parámetros de entrada
        public string GoogleID { get; set; }
        public string Email { get; set; }
        public string Nombre { get; set; }

        // Parámetros de salida
        public int CuentaID { get; set; }
        public byte Rol { get; set; }
        public bool RequiereCompletarPerfil { get; set; }
        public bool EsNuevoUsuario { get; set; }
        public bool Exitoso { get; set; }
        public string Mensaje { get; set; }

        // Constructor vacío
        public GoogleLoginDTO() { }
    }

}
