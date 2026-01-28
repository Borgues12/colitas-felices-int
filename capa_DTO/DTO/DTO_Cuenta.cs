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
        // Cuenta
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte Rol { get; set; }
        public byte Estado { get; set; }
        public bool TieneGoogle { get; set; }
        public DateTime? BloqueadoHasta { get; set; }
        public DateTime? FechaRegistro { get; set; }
        public DateTime? UltimoAcceso { get; set; }

        // Perfil
        public string PrimerNombre { get; set; }
        public string PrimerApellido { get; set; }
        public string Cedula { get; set; }
        public string Telefono { get; set; }
        public byte[] FotoPerfil { get; set; }

        // Propiedades calculadas
        public string NombreCompleto
        {
            get
            {
                if (string.IsNullOrEmpty(PrimerNombre) && string.IsNullOrEmpty(PrimerApellido))
                    return "Sin Nombre";
                return (PrimerNombre + " " + PrimerApellido).Trim();
            }
        }

        public string NombreRol
        {
            get
            {
                switch (Rol)
                {
                    case 1: return "Usuario";
                    case 2: return "Voluntario";
                    case 3: return "Encargado";
                    case 4: return "Administrador";
                    default: return "Desconocido";
                }
            }
        }

        public string NombreEstado
        {
            get
            {
                switch (Estado)
                {
                    case 0: return "Pendiente";
                    case 1: return "Activo";
                    case 2: return "Inactivo";
                    case 3: return "Bloqueado";
                    default: return "Desconocido";
                }
            }
        }

        public bool EstaBloqueadoTemporal
        {
            get { return BloqueadoHasta.HasValue && BloqueadoHasta.Value > DateTime.Now; }
        }
    }
}
