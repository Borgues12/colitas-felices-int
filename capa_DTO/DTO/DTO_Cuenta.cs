using System;
using System.Runtime.InteropServices;

namespace capa_dto
{
    // Info de cuenta para validaciones
    public class CuentaInfoDTO
    {
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte Estado { get; set; }
        public string GoogleID { get; set; }
        public string PrimerNombre { get; set; }

        // Helpers
        public bool EsCuentaGoogle => !string.IsNullOrEmpty(GoogleID);
        public bool EstaPendiente => Estado == 0;
    }

    public class CuentaDetailsDTO
    {
        public int CuentaID { get; set; }
        public string Email { get; set; }
        public byte Estado { get; set; }
        public string TokenVerificacion { get; set; }
        public DateTime? TokenExpiracion { get; set; }
        public byte ReenviosVerificacion { get; set; }
        public DateTime? UltimoReenvioVerificacion { get; set; }
        public string PrimerNombre { get; set; }

        // Helpers
        public bool EstaVerificada => Estado == 1;
        public bool TokenExpirado => TokenExpiracion.HasValue && TokenExpiracion.Value < DateTime.Now;
        public bool EsNuevoDia => !UltimoReenvioVerificacion.HasValue ||
                                   UltimoReenvioVerificacion.Value.Date < DateTime.Today;
    }
}