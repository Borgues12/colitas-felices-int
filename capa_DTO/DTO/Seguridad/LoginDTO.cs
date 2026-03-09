using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_DTO.DTO.Seguridad
{
    public class LoginDTO
    {
        public int CuentaID { get; set; }
        public byte RolID { get; set; }
        public string Email { get; set; }
    }
}
