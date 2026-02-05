using Microsoft.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.Google;
using Owin;
using System;
using System.Threading.Tasks;
using Microsoft.Owin.Logging;

[assembly: OwinStartup(typeof(colitas_felices.Startup))]
namespace colitas_felices
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.SetDefaultSignInAsAuthenticationType("ExternalCookie");
            // Habilitar logging detallado
            app.SetLoggerFactory(new DiagnosticsLoggerFactory());

            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = "ExternalCookie",
                AuthenticationMode = AuthenticationMode.Passive,
                CookieName = ".AspNet.ExternalCookie",
                ExpireTimeSpan = TimeSpan.FromMinutes(5),
                // Agregar estas líneas:
                CookieSecure = CookieSecureOption.SameAsRequest,
                CookieSameSite = SameSiteMode.Lax,
                CookieHttpOnly = true
            });

            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = "ApplicationCookie",
                LoginPath = new PathString("/src/webform/main.aspx"),
                ExpireTimeSpan = TimeSpan.FromMinutes(60),
                CookieName = ".AspNet.ApplicationCookie",
                // Agregar estas líneas:
                CookieSecure = CookieSecureOption.SameAsRequest,
                CookieSameSite = SameSiteMode.Lax
            });

            var googleOptions = new GoogleOAuth2AuthenticationOptions
            {
                ClientId = "777465035348-61rjr5u2h4vt2cssj8nbbigv4phvjfvn.apps.googleusercontent.com",
                ClientSecret = "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",
                CallbackPath = new PathString("/signin-google"),
                SignInAsAuthenticationType = "ExternalCookie",
                Provider = new GoogleOAuth2AuthenticationProvider
                {
                    OnAuthenticated = context =>
                    {
                        System.Diagnostics.Debug.WriteLine("=== OnAuthenticated EJECUTADO ===");
                        System.Diagnostics.Debug.WriteLine($"Google ID: {context.Id}");
                        System.Diagnostics.Debug.WriteLine($"Email: {context.Email}");
                        return Task.FromResult(0);
                    },
                    OnReturnEndpoint = context =>
                    {
                        System.Diagnostics.Debug.WriteLine("=== OnReturnEndpoint ===");
                        System.Diagnostics.Debug.WriteLine($"Identity null: {context.Identity == null}");

                        // Capturar errores de la respuesta
                        var query = context.Request.Query;
                        System.Diagnostics.Debug.WriteLine($"Query 'error': {query.Get("error")}");
                        System.Diagnostics.Debug.WriteLine($"Query 'code': {(string.IsNullOrEmpty(query.Get("code")) ? "NO HAY CODE" : "CODE PRESENTE")}");

                        return Task.FromResult(0);
                    },
                    OnApplyRedirect = context =>
                    {
                        System.Diagnostics.Debug.WriteLine("=== OnApplyRedirect ===");
                        System.Diagnostics.Debug.WriteLine($"Redirect URI: {context.RedirectUri}");
                        context.Response.Redirect(context.RedirectUri);
                    }
                },
                // Agregar BackchannelHttpHandler para debug
                BackchannelTimeout = TimeSpan.FromSeconds(60)
            };

            // Asegurar que los scopes estén correctos
            googleOptions.Scope.Clear();
            googleOptions.Scope.Add("openid");
            googleOptions.Scope.Add("email");
            googleOptions.Scope.Add("profile");

            app.UseGoogleAuthentication(googleOptions);
        }
    }

    // Logger para ver errores internos de OWIN
    public class DiagnosticsLoggerFactory : ILoggerFactory
    {
        public ILogger Create(string name)
        {
            return new DiagnosticsLogger(name);
        }
    }

    public class DiagnosticsLogger : ILogger
    {
        private readonly string _name;
        public DiagnosticsLogger(string name) { _name = name; }

        public bool WriteCore(System.Diagnostics.TraceEventType eventType, int eventId, object state, Exception exception, Func<object, Exception, string> formatter)
        {
            if (state != null || exception != null)
            {
                string message = formatter != null ? formatter(state, exception) : state?.ToString();
                System.Diagnostics.Debug.WriteLine($"[OWIN {_name}] {eventType}: {message}");
                if (exception != null)
                {
                    System.Diagnostics.Debug.WriteLine($"[OWIN EXCEPTION] {exception.Message}");
                    System.Diagnostics.Debug.WriteLine($"[OWIN STACK] {exception.StackTrace}");
                }
            }
            return true;
        }
    }
}