using capa_dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace colitas_felices
{
    public class NotifyLogic : Page
    {
            /// Muestra mensaje usando Notyf
            protected void MostrarMensaje(string mensaje, string tipo)
            {
                string notyfCall;
                switch (tipo.ToLower())
                {
                    case "success":
                        notyfCall = $"notyf.success('{EscaparJS(mensaje)}');";
                        break;
                    case "warning":
                        notyfCall = $"notyf.open({{ type: 'warning', message: '{EscaparJS(mensaje)}' }});";
                        break;
                    case "error":
                    default:
                        notyfCall = $"notyf.error('{EscaparJS(mensaje)}');";
                        break;
                }

                string script = $@"
                if (typeof notyf !== 'undefined') {{
                    {notyfCall}
                }} else {{
                    window.addEventListener('load', function() {{
                        {notyfCall}
                    }});
                }}";

                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
                    "NotyfMessage_" + Guid.NewGuid().ToString("N"),
                    script,
                    true
                );
            }

            /// Muestra mensaje con tipo personalizado basado en notifyVarDTO
            protected void MostrarResultado(notifyVarDTO resultado, string tipoExito = "success")
            {
                string tipo = resultado.resultado ? tipoExito : "error";
                MostrarMensaje(resultado.mensajeSalida, tipo);
            }

            private string EscaparJS(string texto)
            {
                if (string.IsNullOrEmpty(texto))
                    return "";

                return texto
                    .Replace("\\", "\\\\")
                    .Replace("'", "\\'")
                    .Replace("\"", "\\\"")
                    .Replace("\n", "\\n")
                    .Replace("\r", "");
            }

        }
    }