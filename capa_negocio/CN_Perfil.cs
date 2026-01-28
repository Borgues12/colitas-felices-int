//using capa_datos;
//using capa_dto;
//using System;
//using System.Collections.Generic;

//namespace capa_negocio
//{
//    public class CN_Perfil
//    {
//        private CD_Perfil objCD = new CD_Perfil();

//        // Obtener todos los perfiles
//        public List<PerfilDTO> ObtenerPerfiles(string filtro = null)
//        {
//            try
//            {
//                int? perfilCompletoFiltro = null;

//                if (!string.IsNullOrEmpty(filtro))
//                {
//                    switch (filtro.ToLower())
//                    {
//                        case "completos":
//                            perfilCompletoFiltro = 1;
//                            break;

//                        case "incompletos":
//                            perfilCompletoFiltro = 0;
//                            break;
//                    }
//                }
//                return objCD.ListarPerfiles(perfilCompletoFiltro);
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CN_Perfil.ObtenerPerfiles: " + ex.Message);
//                return new List<PerfilDTO>();
//            }
//        }

//        // Obtener perfil por ID
//        public PerfilDTO ObtenerPerfilPorID(int cuentaID)
//        {
//            try
//            {
//                return objCD.ObtenerPerfilPorID(cuentaID);
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CN_Perfil.ObtenerPerfilPorID: " + ex.Message);
//                return null;
//            }
//        }

//        // Actualizar perfil
//        public notifyDTO ActualizarPerfil(int cuentaID, string cedula, string nombres,
//            string apellidos, string telefono, string direccion, byte[] fotoPerfil)
//        {
//            try
//            {
//                return objCD.ActualizarPerfil(cuentaID, cedula, nombres, apellidos, telefono, direccion, fotoPerfil);
//            }
//            catch (Exception ex)
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "Error: " + ex.Message
//                };
//            }
//        }
//    }
//}