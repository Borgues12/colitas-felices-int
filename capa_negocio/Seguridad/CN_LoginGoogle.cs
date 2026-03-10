using capa_datos.Seguridad;
using capa_dto;
using capa_DTO.DTO.Seguridad;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace capa_negocio.Seguridad
{
    public class CN_LoginGoogle
    {
        private CD_LoginGoogle cdLoginGoogle = new CD_LoginGoogle();

            public async Task<notifyVarDTO> LoginORegistrar(string code, string clientId, string clientSecret, string redirectUri)
            {
                var googleUser = await ObtenerUsuarioGoogle(code, clientId, clientSecret, redirectUri);
                if (googleUser == null)
                    return new notifyVarDTO { resultado = false, mensajeSalida = "No se pudo obtener datos de Google" };

                // ¿Ya existe cuenta con este GoogleID?
                var cuenta = cdLoginGoogle.ObtenerCuentaPorGoogleID(googleUser.GoogleID);

                //Si existe la redirije para logearse
                if (cuenta != null)
                {
                    // ── Login directo ──
                    return new notifyVarDTO
                    {
                        resultado = true,
                        mensajeSalida = "Login exitoso",
                        datos = new LoginDTO
                        {
                            CuentaID = cuenta.CuentaID,
                            RolID = cuenta.RolID
                        }
                    };
                }
   
                // ¿Existe cuenta con ese email pero registrada normalmente?
                var cuentaEmail = cdLoginGoogle.ObtenerCuentaPorEmail(googleUser.Email);

                if (cuentaEmail != null)
                {
                    // Vincular GoogleID a la cuenta existente
                    cdLoginGoogle.VincularGoogleID(cuentaEmail.CuentaID, googleUser.GoogleID);

                    return new notifyVarDTO
                    {
                        resultado = true,
                        mensajeSalida = "Login exitoso",
                        datos = new LoginDTO
                        {
                            CuentaID = cuentaEmail.CuentaID,
                            RolID = cuentaEmail.RolID
                        }
                    };
                }

                // ── Cuenta nueva → registrar automáticamente ──
                int cuentaId = await cdLoginGoogle.CrearCuentaGoogle(googleUser);

                if (cuentaId <= 0)
                    return new notifyVarDTO
                    {
                        resultado = false,
                        mensajeSalida = "Error al crear la cuenta. Intenta nuevamente."
                    };

                return new notifyVarDTO
                {
                    resultado = true,
                    mensajeSalida = "Cuenta creada exitosamente",
                    datos = new LoginDTO
                    {
                        CuentaID = cuentaId,
                        RolID = 1 // rol usuario por defecto
                    }
                };
            }

        /// <summary>
        ///   CD_LoginGoogle.cs — agrega este método
        /// </summary
        public async Task<GoogleUserDTO> ObtenerUsuarioGoogle(string code, string clientId, string clientSecret, string redirectUri)
        {
            using (var http = new HttpClient())
            {
                var tokenResponse = await http.PostAsync("https://oauth2.googleapis.com/token",
                    new FormUrlEncodedContent(new Dictionary<string, string>
                    {
                    { "code", code },
                    { "client_id", clientId },
                    { "client_secret", clientSecret },
                    { "redirect_uri", redirectUri },
                    { "grant_type", "authorization_code" }
                    }));

                string tokenJson = await tokenResponse.Content.ReadAsStringAsync();
                dynamic tokenData = JsonConvert.DeserializeObject(tokenJson);

                string accessToken = (string)tokenData.access_token;
                if (string.IsNullOrEmpty(accessToken)) return null;

                http.DefaultRequestHeaders.Add("Authorization", "Bearer " + accessToken);
                string userJson = await http.GetStringAsync("https://www.googleapis.com/oauth2/v2/userinfo");
                dynamic userData = JsonConvert.DeserializeObject(userJson);

                return new GoogleUserDTO
                {
                    GoogleID = (string)userData.id,
                    Email = (string)userData.email,
                    PrimerNombre = (string)userData.given_name ?? "Usuario",
                    PrimerApellido = (string)userData.family_name ?? "",
                    FotoURL = (string)userData.picture ?? null
                };
            }
        }
    }
}