using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_dto
{
    /// <summary>
    /// DTO estándar para respuestas de operaciones
    /// </summary>
    public class notifyDTO
    {
        public bool resultado { get; set; }
        public string mensajeSalida { get; set; }

        // ══════════════════════════════════════════
        // Métodos de fábrica
        // ══════════════════════════════════════════

        public static notifyDTO Exito(string mensaje)
        {
            return new notifyDTO
            {
                resultado = true,
                mensajeSalida = mensaje
            };
        }

        public static notifyDTO Error(string mensaje)
        {
            return new notifyDTO
            {
                resultado = false,
                mensajeSalida = mensaje
            };
        }
    }

    /// <summary>
    /// DTO extendido para respuestas que necesitan datos adicionales
    /// </summary>
    public class notifyVarDTO : notifyDTO
    {
        public int codigo { get; set; }
        public object datos { get; set; }

        // ══════════════════════════════════════════
        // Métodos de fábrica
        // ══════════════════════════════════════════

        public static notifyVarDTO ExitoConCodigo(string mensaje, int codigo)
        {
            return new notifyVarDTO
            {
                resultado = true,
                mensajeSalida = mensaje,
                codigo = codigo
            };
        }

        public static notifyVarDTO ExitoConDatos(string mensaje, object datos)
        {
            return new notifyVarDTO
            {
                resultado = true,
                mensajeSalida = mensaje,
                datos = datos
            };
        }

        public static new notifyVarDTO Error(string mensaje)
        {
            return new notifyVarDTO
            {
                resultado = false,
                mensajeSalida = mensaje,
                codigo = 0
            };
        }
    }
}