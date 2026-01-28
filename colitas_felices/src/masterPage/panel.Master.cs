//using capa_dto.DTO;
//using capa_negocio;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace colitas_felices.src.webform
//{
//    public partial class panel : notificacionesMaster
//    {
//        private CN_Login negocio = new CN_Login();

//        // DTO del perfil del usuario logueado
//        protected PerfilDTO perfilUsuario { get; set; }

//        // Carga de la pagina con los datos del usuario logueado
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!EstaLogueado)
//            {
//                Response.Redirect("~/src/webform/main.aspx", false);
//                Context.ApplicationInstance.CompleteRequest();
//                return;
//            }

//            if (!IsPostBack)
//            {
//                LoadUserData();
//            }
//        }

//        // Cargar datos del usuario
//        protected void LoadUserData()
//        {
//            try
//            {
//                if (Session["CuentaID"] != null)
//                {
//                    int cuentaID = Convert.ToInt32(Session["CuentaID"]);
//                    perfilUsuario = negocio.CargarDatosUsuario(cuentaID);
//                }
//                else
//                {
//                    CerrarSesion();
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error al cargar datos: " + ex.Message);
//                perfilUsuario = null;
//            }
//        }
//        // Método para obtener el nombre completo del usuario (primer nombre + primer apellido)
//        protected string ObtenerNombreNormalizado()
//        {
//            if (perfilUsuario == null)
//                return "Usuario";

//            if (!string.IsNullOrEmpty(perfilUsuario.Nombres) && !string.IsNullOrEmpty(perfilUsuario.Apellidos))
//            {
//                // Obtener solo el primer nombre
//                string primerNombre = perfilUsuario.Nombres.Trim().Split(' ')[0];

//                // Obtener solo el primer apellido
//                string primerApellido = perfilUsuario.Apellidos.Trim().Split(' ')[0];

//                return primerNombre + " " + primerApellido;
//            }

//            return perfilUsuario.Email ?? "Usuario";
//        }

//        // Método para obtener el nombre completo (todos los nombres y apellidos)
//        protected string ObtenerNombreCompleto()
//        {
//            if (perfilUsuario == null)
//                return "Usuario";

//            if (!string.IsNullOrEmpty(perfilUsuario.Nombres) && !string.IsNullOrEmpty(perfilUsuario.Apellidos))
//            {
//                return (perfilUsuario.Nombres + " " + perfilUsuario.Apellidos).Trim();
//            }

//            return perfilUsuario.Email ?? "Usuario";
//        }

//        // Método para obtener la foto del usuario en formato Base64
//        protected string ObtenerFotoUsuario()
//        {
//            if (perfilUsuario?.FotoPerfil != null && perfilUsuario.FotoPerfil.Length > 0)
//            {
//                string base64 = Convert.ToBase64String(perfilUsuario.FotoPerfil);
//                return "data:image/jpeg;base64," + base64;
//            }

//            return ResolveUrl("~/src/assets/images/faces/face1.jpg");
//        }

//        // Método para obtener el nombre del rol
//        protected string ObtenerNombreRol()
//        {
//            if (perfilUsuario == null)
//                return "Usuario";

//            switch (perfilUsuario.Rol)
//            {
//                case 1: return "Administrador";
//                case 2: return "Usuario";
//                default: return "Usuario";
//            }
//        }

//        // Cerrar sesion del usuario
//        protected void Logout_Click(object sender, EventArgs e)
//        {
//            CerrarSesion();
//        }
//    }
//}