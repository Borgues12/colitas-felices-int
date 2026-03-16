using colitas_felices.Helpers;
using System;
using System.Threading.Tasks;
using System.Web;
using System.Web.Routing;
using System.Web.UI;

namespace colitas_felices
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            ScriptResourceDefinition definition = new ScriptResourceDefinition();
            definition.Path = "~/scripts/jquery.min.js";
            definition.DebugPath = "~/scripts/jquery.min.js";
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", definition);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            Task.Run(() => AzureInit.InicializarAsync()).GetAwaiter().GetResult();
        }
    }
}
