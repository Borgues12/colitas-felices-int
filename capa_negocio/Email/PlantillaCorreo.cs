// capa_negocio/Correo/PlantillaCorreo.cs
using System.Configuration;

namespace capa_negocio.Email
{
    public static class PlantillaCorreo
    {
        // ════════════════════════════════════════════════════════════
        // CONFIGURACION
        // ════════════════════════════════════════════════════════════

        private static string SitioUrl =>
            ConfigurationManager.AppSettings["SitioUrl"] ?? "http://localhost";

        private static string AssetsUrl =>
            ConfigurationManager.AppSettings["EmailAssetsUrl"];

        // URLs de imagenes — apuntan a Azurite en desarrollo, Azure en produccion
        private static string UrlLogo => $"{AssetsUrl}/logo.png";
        private static string UrlDog => $"{AssetsUrl}/dog.png";
        private static string UrlFacebook => $"{AssetsUrl}/facebook.png";
        private static string UrlTwitter => $"{AssetsUrl}/twitter.png";
        private static string UrlLinkedin => $"{AssetsUrl}/linkedin.png";
        private static string UrlInstagram => $"{AssetsUrl}/instagram.png";

        // ════════════════════════════════════════════════════════════
        // PLANTILLAS PUBLICAS
        // ════════════════════════════════════════════════════════════

        public static string Verificacion(string nombre, string codigo)
        {
            return Construir(
                badge: "Cuenta - Verificacion",
                titulo: "Verifica tu <span style='color:#E91E63;'>cuenta</span>",
                subtitulo: $"Hola <strong>{nombre}</strong>, ingresa este codigo para activar tu cuenta.",
                codigo: codigo,
                nota: "Expira en 15 minutos. Si no creaste una cuenta, ignora este mensaje.",
                botonTexto: "Ir a mi cuenta &#8250;",
                botonUrl: SitioUrl
            );
        }

        public static string Recuperacion(string nombre, string codigo)
        {
            return Construir(
                badge: "Cuenta - Recuperacion",
                titulo: "Recupera tu <span style='color:#E91E63;'>contrasena</span>",
                subtitulo: $"Hola <strong>{nombre}</strong>, ingresa este codigo para restablecer tu contrasena.",
                codigo: codigo,
                nota: "Expira en 15 minutos. Si no solicitaste este cambio, ignora este mensaje.",
                botonTexto: "Restablecer contrasena &#8250;",
                botonUrl: SitioUrl
            );
        }

        public static string Bienvenida(string nombre)
        {
            return Construir(
                badge: "Cuenta - Bienvenida",
                titulo: "Bienvenido a la <span style='color:#E91E63;'>familia!</span>",
                subtitulo: $"Hola <strong>{nombre}</strong>, tu cuenta ha sido verificada. Ya eres parte de nuestra comunidad y puedes explorar mascotas en adopcion, apadrinar a un peludo, ser voluntario y realizar donaciones.",
                codigo: null,
                nota: null,
                botonTexto: "Ir a mi cuenta &#8250;",
                botonUrl: SitioUrl
            );
        }

        // ════════════════════════════════════════════════════════════
        // CONSTRUCTOR BASE — unica plantilla HTML del sistema
        // ════════════════════════════════════════════════════════════

        private static string Construir(
            string badge,
            string titulo,
            string subtitulo,
            string codigo,
            string nota,
            string botonTexto,
            string botonUrl)
        {
            string bloqueCodigoHtml = string.IsNullOrEmpty(codigo) ? "" : $@"
                <p style='margin:14px 0 0 0;text-align:center;'>
                    <span style='display:inline-block;background:#E91E63;color:#ffffff;
                                 font-size:26px;font-weight:700;letter-spacing:8px;
                                 padding:10px 20px;font-family:Courier New,monospace;'>
                        {codigo}
                    </span>
                </p>";

            string bloqueNotaHtml = string.IsNullOrEmpty(nota) ? "" : $@"
                <p style='margin:10px 0 0 0;font-size:12px;color:#999;'>{nota}</p>";

            return $@"
<!DOCTYPE html>
<html lang='es'>
<head>
  <meta charset='UTF-8'>
  <link href='https://fonts.googleapis.com/css?family=Poppins:400,600,700' rel='stylesheet'>
</head>
<body style='margin:0;padding:20px;background:#F8BBD9;font-family:Poppins,Arial,sans-serif;'>

<table width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td>

  <!-- HEADER: logo -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#E91E63;margin:0 auto;'>
  <tr><td style='padding:5px 0;text-align:center;'>
    <a href='{botonUrl}'>
      <img src='{UrlLogo}' width='158' alt='Colitas Felices'
           style='display:block;height:auto;border:0;margin:0 auto;'>
    </a>
  </td></tr>
  </table>

  <!-- SPACER -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#FFF0F5;margin:0 auto;'>
  <tr><td style='height:5px;'></td></tr>
  </table>

  <!-- HERO -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#FFF0F5;
                background-image:url(https://d1oco4z2z1fhwp.cloudfront.net/templates/default/5421/texture-body4.png);
                background-repeat:no-repeat;margin:0 auto;'>
  <tr>

    <!-- Col izquierda: contenido -->
    <td width='41%' style='vertical-align:top;padding:20px 25px;'>

      <!-- Badge -->
      <div style='margin-bottom:10px;'>
        <span style='border:1px dashed #E91E63;border-radius:50px;color:#997d9c;
                     font-size:10px;padding:0 15px;line-height:20px;display:inline-block;'>
          {badge}
        </span>
      </div>

      <!-- Titulo -->
      <h1 style='margin:0 0 10px 0;color:#9C27B0;font-family:Poppins,Arial,sans-serif;
                 font-size:38px;font-weight:700;line-height:1.2;'>
        {titulo}
      </h1>

      <!-- Subtitulo + codigo + nota -->
      <div style='color:#9C27B0;font-size:14px;line-height:1.5;'>
        <p style='margin:0;'>{subtitulo}</p>
        {bloqueCodigoHtml}
        {bloqueNotaHtml}
      </div>

      <!-- Boton -->
      <div style='margin-top:20px;'>
        <a href='{botonUrl}'
           style='background:#E91E63;color:#ffffff;padding:10px 25px;
                  text-decoration:none;display:inline-block;
                  font-size:16px;line-height:32px;'>
          {botonTexto}
        </a>
      </div>

    </td>

    <!-- Col derecha: imagen perro -->
    <td width='59%' style='vertical-align:top;text-align:right;'>
      <img src='{UrlDog}' width='380' alt='Colitas Felices'
           style='display:block;height:auto;border:0;margin-left:auto;'>
    </td>

  </tr>
  </table>

  <!-- SPACER blanco -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#fff;margin:0 auto;'>
  <tr><td style='height:15px;'></td></tr>
  </table>

  <!-- FOOTER -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#4A0E2B;margin:0 auto;'>
  <tr>

    <!-- Footer col 1: logo + tagline -->
    <td width='41%' style='vertical-align:top;padding:20px 25px;'>
      <a href='{botonUrl}'>
        <img src='{UrlLogo}' width='158' alt='Colitas Felices'
             style='display:block;height:auto;border:0;'>
      </a>
      <p style='color:#fff;font-size:14px;margin:15px 0 0 0;'>
        Porque tu mascota merece lo mejor. Con amor y dedicacion.
      </p>
    </td>

    <!-- Footer col 2: links -->
    <td width='25%' style='vertical-align:top;padding:20px 25px;'>
      <h3 style='color:#F06292;font-size:16px;margin:0 0 10px 0;'>EXPLORAR</h3>
      <p style='margin:5px 0;'>
        <a href='{SitioUrl}' style='color:#fff;text-decoration:none;'>
          &#10095; Quienes somos
        </a>
      </p>
      <p style='margin:5px 0;'>
        <a href='{SitioUrl}' style='color:#fff;text-decoration:none;'>
          &#10095; Mascotas
        </a>
      </p>
      <p style='margin:5px 0;'>
        <a href='{SitioUrl}' style='color:#fff;text-decoration:none;'>
          &#10095; Contactanos
        </a>
      </p>
    </td>

    <!-- Footer col 3: redes sociales -->
    <td width='34%' style='vertical-align:top;padding:20px 15px;'>
      <table border='0' cellpadding='0' cellspacing='5'><tr>
        <td>
          <a href='https://facebook.com'>
            <img src='{UrlFacebook}' width='32' alt='Facebook'
                 style='display:block;border:0;'>
          </a>
        </td>
        <td>
          <a href='https://twitter.com'>
            <img src='{UrlTwitter}' width='32' alt='Twitter'
                 style='display:block;border:0;'>
          </a>
        </td>
        <td>
          <a href='https://linkedin.com'>
            <img src='{UrlLinkedin}' width='32' alt='LinkedIn'
                 style='display:block;border:0;'>
          </a>
        </td>
        <td>
          <a href='https://instagram.com'>
            <img src='{UrlInstagram}' width='32' alt='Instagram'
                 style='display:block;border:0;'>
          </a>
        </td>
      </tr></table>
      <p style='margin:10px 0 0 0;'>
        <a href='{SitioUrl}' style='color:#F06292;text-decoration:none;'>
          &#10095; Cancelar suscripcion
        </a>
      </p>
    </td>

  </tr>
  </table>

  <!-- SPACER final -->
  <table align='center' width='650' border='0' cellpadding='0' cellspacing='0'
         style='background:#4A0E2B;margin:0 auto;'>
  <tr><td style='height:15px;'></td></tr>
  </table>

</td></tr>
</table>
</body>
</html>";
        }
    }
}