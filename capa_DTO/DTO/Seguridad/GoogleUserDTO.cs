using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_DTO.DTO.Seguridad
{
    //Lo que pediremos a la API de Google para crear o logear a un usuario en nuestro sistema
    public class GoogleUserDTO
    {
        public string GoogleID { get; set; } //siempre
        public string Email { get; set; } //siempre
        public string PrimerNombre { get; set; } //casi siempre
        public string PrimerApellido { get; set; } //posible null
        public string FotoURL { get; set; } //posible null
    }
}
