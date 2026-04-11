using System;

namespace capa_dto.DTO.Crud
{
    // ============================================================
    // DTO para listado de cuentas en el panel admin
    // Join cuenta + perfil — solo datos de identificación
    // ============================================================
    public class CuentaAdminDTO
    {
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte RolID { get; set; }
        public string RolNombre { get; set; }
        public EstadoEnum Estado { get; set; }  // activo, bloqueado, inactivo
        public DateTime FechaRegistro { get; set; }
        public DateTime? UltimoAcceso { get; set; }

        // Datos del perfil (join)
        public string PrimerNombre { get; set; }
        public string PrimerApellido { get; set; }
        public string NumeroIdentificacion { get; set; }
        public string TelefonoPrincipal { get; set; }

        // ---- Helpers de presentación ----
        public string NombreCompleto
        {
            get
            {
                string nombre = (PrimerNombre ?? "").Trim();
                string apellido = (PrimerApellido ?? "").Trim();
                if (string.IsNullOrEmpty(nombre) && string.IsNullOrEmpty(apellido))
                    return Email;
                return (nombre + " " + apellido).Trim();
            }
        }

        public string EstadoTexto
        {
            get
            {
                switch (Estado)
                {
                    case EstadoEnum.Activo:
                        return "Activo";
                    case EstadoEnum.Bloqueado:
                        return "Bloqueado";
                    case EstadoEnum.Inactivo:
                        return "Inactivo";
                    default:
                        return "-";
                }
            }
        }
    }

    //Logica para el estado
    public enum EstadoEnum : byte
    {
        Inactivo = 0,
        Activo = 1,
        Bloqueado = 2
    }

    // ============================================================
    // Filtro para búsqueda en el listado
    // ============================================================
    public class CuentaFiltroDTO
    {
        public string Busqueda { get; set; }      // nombre, email o cédula
        public byte? RolID { get; set; }           // null = todos
        public string Estado { get; set; }          // null = todos
    }
}