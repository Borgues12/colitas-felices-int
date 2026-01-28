using System;
using System.Linq;

namespace capa_dto.DTO
{
    // En capa_dto/SeguridadDTO.cs
    public class RegistroInternoDTO
    {
        public bool Exitoso { get; set; }
        public int CuentaID { get; set; }
        public string Token { get; set; }       // Para enviar email en CN
        public string Email { get; set; }       // Para enviar email en CN
        public string Nombre { get; set; }      // Para personalizar email
        public string Mensaje { get; set; }
    }

    public class VerificacionDTO
    {
        public bool Exitoso { get; set; }
        public string Token { get; set; }
        public string Email { get; set; }
        public string Mensaje { get; set; }
    }
}