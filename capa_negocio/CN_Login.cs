using capa_datos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_dto;

namespace capa_negocio
{
    public class CN_Login
    {
        private CD_Login_Registro objCD = new CD_Login_Registro();

        //Meoto para validar usuario
        public CuentaDTO ValidarUsuario(string email, string password)
        {
            try
            {
                return objCD.VerificarLogin(email, password);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CN_Login.ValidarUsuario: " + ex.Message);
                return new CuentaDTO
                {
                    LoginExitoso = false,
                    Mensaje = "Error: " + ex.Message
                };
            }
        }

        //Cargar datos de la cuenta
        public PerfilDTO CargarDatosUsuario(int cuentaID)
        {
            try
            {
                return objCD.CargarDatosUsuario(cuentaID);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CN_Login.CargarDatosUsuario: " + ex.Message);
                return null;
            }
        }

        //Metodo para login/registro con google
        public GoogleLoginDTO LoginGoogle(string googleID, string email, string nombre)
        {
            try
            {
                return objCD.LoginGoogle(googleID, email, nombre);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CN_Login.LoginGoogle: " + ex.Message);
                return new GoogleLoginDTO
                {
                    Exitoso = false,
                    Mensaje = "Error: " + ex.Message
                };
            }
        }
    }
}