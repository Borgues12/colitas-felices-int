using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using Google.Apis.Services;
using MimeKit;
using capa_negocio.Email;
using System;
using System.Configuration;
using System.IO;
using System.Threading.Tasks;

namespace capa_negocio
{
    /// <summary>
    /// Tipos de email - Define el nombre del remitente
    /// </summary>
    public enum TipoEmail
    {
        Autenticacion,  // 🔐 Registro, verificación, reset password
        Pago,           // 💳 Donaciones, apadrinamientos
        Notificacion,   // 🐾 Updates, recordatorios
        Adopcion        // 🏠 Proceso de adopción
    }

    /// <summary>
    /// Resultado de operación de email
    /// </summary>
    public class EmailResultado
    {
        public bool Exitoso { get; set; }
        public string Mensaje { get; set; }
    }

    public class CN_Email
    {
        // ═══════════════════════════════════════════════════════════════
        // CONFIGURACIÓN
        // ═══════════════════════════════════════════════════════════════
        private static string ClientId => ConfigurationManager.AppSettings["Gmail_ClientId"];
        private static string ClientSecret => ConfigurationManager.AppSettings["Gmail_ClientSecret"];
        private static string RefreshToken => ConfigurationManager.AppSettings["Gmail_RefreshToken"];
        private static string EmailFrom => ConfigurationManager.AppSettings["Gmail_EmailFrom"];

        // ═══════════════════════════════════════════════════════════════
        // MÉTODO PRINCIPAL - USA ESTE PARA TODO
        // ═══════════════════════════════════════════════════════════════

        /// <summary>
        /// Método general para enviar emails.
        /// Llámalo desde cualquier parte del sistema.
        /// </summary>
        public static async Task<EmailResultado> Enviar(
            string destinatario,
            string nombre,
            string asunto,
            string titulo,
            string contenido,
            TipoEmail tipo = TipoEmail.Notificacion)
        {
            if (string.IsNullOrWhiteSpace(destinatario))
                return new EmailResultado { Exitoso = false, Mensaje = "Email destinatario requerido" };

            try
            {
                string nombreRemitente;
                string emoji;

                switch (tipo)
                {
                    case TipoEmail.Autenticacion:
                        nombreRemitente = "🔐 Colitas Felices - Cuenta";
                        emoji = "🔐";
                        break;
                    case TipoEmail.Pago:
                        nombreRemitente = "💳 Colitas Felices - Pagos";
                        emoji = "💳";
                        break;
                    case TipoEmail.Adopcion:
                        nombreRemitente = "🏠 Colitas Felices - Adopciones";
                        emoji = "🏠";
                        break;
                    default:
                        nombreRemitente = "🐾 Colitas Felices";
                        emoji = "🐾";
                        break;
                }

                string htmlCompleto = GenerarPlantilla(titulo, contenido, emoji);
                bool enviado = await EnviarInterno(destinatario, nombre, asunto, htmlCompleto, nombreRemitente);

                return new EmailResultado
                {
                    Exitoso = enviado,
                    Mensaje = enviado ? "Email enviado correctamente" : "Error al enviar email"
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ CN_Email.Enviar: {ex.Message}");
                return new EmailResultado { Exitoso = false, Mensaje = ex.Message };
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // MÉTODOS DE CONVENIENCIA (llaman a Enviar internamente)
        // ═══════════════════════════════════════════════════════════════

        public static async Task<EmailResultado> Verificacion(string email, string nombre, string codigo)
        {
            string html = PlantillaCorreo.Verificacion(nombre, codigo);
            bool enviado = await EnviarInterno(email, nombre,
                "Verifica tu cuenta - Colitas Felices", html,
                "Colitas Felices - Cuenta");

            return new EmailResultado
            {
                Exitoso = enviado,
                Mensaje = enviado ? "Correo enviado correctamente" : "Error al enviar correo"
            };
        }


        public static async Task<EmailResultado> Recuperacion(string email, string nombre, string codigo)
        {
            string html = PlantillaCorreo.Recuperacion(nombre, codigo);
            bool enviado = await EnviarInterno(email, nombre,
                "Recupera tu contrasena - Colitas Felices", html,
                "Colitas Felices - Cuenta");

            return new EmailResultado
            {
                Exitoso = enviado,
                Mensaje = enviado ? "Correo enviado correctamente" : "Error al enviar correo"
            };
        }

        public static async Task<EmailResultado> Bienvenida(string email, string nombre)
        {
            string html = PlantillaCorreo.Bienvenida(nombre);
            bool enviado = await EnviarInterno(email, nombre,
                "Bienvenido a Colitas Felices", html,
                "Colitas Felices");

            return new EmailResultado
            {
                Exitoso = enviado,
                Mensaje = enviado ? "Correo enviado correctamente" : "Error al enviar correo"
            };
        }

        // ═══════════════════════════════════════════════════════════════
        // MÉTODOS PRIVADOS
        // ═══════════════════════════════════════════════════════════════

        private static async Task<GmailService> GetGmailService()
        {
            var flow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
            {
                ClientSecrets = new ClientSecrets
                {
                    ClientId = ClientId,
                    ClientSecret = ClientSecret
                },
                Scopes = new[] { GmailService.Scope.GmailSend }
            });

            var token = new Google.Apis.Auth.OAuth2.Responses.TokenResponse { RefreshToken = RefreshToken };
            var credential = new UserCredential(flow, "user", token);

            await credential.RefreshTokenAsync(System.Threading.CancellationToken.None);


            return new GmailService(new BaseClientService.Initializer
            {
                HttpClientInitializer = credential,
                ApplicationName = "Colitas Felices"
            });
        }

        private static async Task<bool> EnviarInterno(string destinatario, string nombreDestinatario, string asunto, string cuerpoHtml, string nombreRemitente)
        {
            try
            {
                var service = await GetGmailService();
                var mensaje = new MimeMessage();
                mensaje.From.Add(new MailboxAddress(nombreRemitente, EmailFrom));
                mensaje.To.Add(new MailboxAddress(nombreDestinatario ?? "", destinatario));
                mensaje.Subject = asunto;

                var constructor = new BodyBuilder { HtmlBody = cuerpoHtml };
                mensaje.Body = constructor.ToMessageBody();

                using (var stream = new MemoryStream())
                {
                    await mensaje.WriteToAsync(stream);
                    var raw = Convert.ToBase64String(stream.ToArray())
                        .Replace('+', '-')
                        .Replace('/', '_')
                        .Replace("=", "");

                    await service.Users.Messages.Send(new Message { Raw = raw }, "me").ExecuteAsync();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ Error enviando email: {ex.Message}");
                return false;
            }
        }

        private static string GenerarPlantilla(string titulo, string contenido, string emoji)
        {
            return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
</head>
<body style='margin:0; padding:0; font-family:Segoe UI, Arial, sans-serif; background:#f5f5f5;'>
    <table width='100%' cellpadding='0' cellspacing='0' style='padding:30px 15px;'>
        <tr>
            <td align='center'>
                <table width='100%' style='max-width:480px; background:#ffffff; border-radius:16px; overflow:hidden;'>
                    
                    <!-- Header -->
                    <tr>
                        <td style='background:#6f42c1; padding:32px 24px; text-align:center;'>
                            <div style='font-size:36px; margin-bottom:8px;'>{emoji}</div>
                            <h1 style='color:#ffffff; margin:0; font-size:22px; font-weight:600;'>{titulo}</h1>
                        </td>
                    </tr>
                    
                    <!-- Contenido -->
                    <tr>
                        <td style='padding:32px 24px; color:#333333; font-size:15px; line-height:1.6;'>
                            {contenido}
                        </td>
                    </tr>
                    
                    <!-- Footer -->
                    <tr>
                        <td style='background:#f8f9fa; padding:20px 24px; text-align:center; border-top:1px solid #eee;'>
                            <p style='margin:0 0 4px 0; color:#6f42c1; font-weight:600; font-size:14px;'>
                                🐾 Colitas Felices
                            </p>
                            <p style='margin:0; color:#999; font-size:12px;'>
                                Refugio de animales • Calderón, Quito
                            </p>
                        </td>
                    </tr>
                    
                </table>
            </td>
        </tr>
    </table>
</body>
</html>";
        }
    }
}