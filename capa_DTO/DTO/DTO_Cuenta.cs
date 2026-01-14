using System;
using System.Runtime.InteropServices;

namespace capa_dto
{
    // DTO para crear cuentas
    public class CrearCuentaDTO
    {
        // PROPIEDADES
        public string Email { get; set; }
        public string Password { get; set; }
        public byte Rol { get; set; }           // tinyint
        public byte Estado { get; set; }        // tinyint
        public string Cedula { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public byte[] FotoPerfil { get; set; }

        // CONSTRUCTOR VACÍO
        public CrearCuentaDTO() { }
    }

    // DTO para editar usuarios y cuentas
    public class UsuarioCuentaDTO
    {
        // PROPIEDADES
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public DateTime? UltimoAcceso { get; set; }
        public byte Rol { get; set; }           // tinyint
        public byte Estado { get; set; }        // tinyint
        public string Cedula { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public byte[] FotoPerfil { get; set; }

        // CONSTRUCTOR VACÍO
        public UsuarioCuentaDTO() { }
    }
}
