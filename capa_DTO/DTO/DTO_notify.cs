using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_dto
{
    // DTO para notificaciones de acciones
    public class notifyDTO
    {
        public bool resultado { get; set; }
        public string mensajeSalida { get; set; }
    }

    //DTO variable para notificaciones
    public class notifyVarDTO
    {
        public bool resultado2 { get; set; }

        public int codigo { get; set; }
        public string mensajeSalida2 { get; set; }
    }
}
