//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;
//using capa_datos;
//using capa_dto;

////LOGICA PARA CRUD
//namespace capa_negocio
//{
//    public class CN_Usuario
//    {
//        private CD_Cuenta datos = new CD_Cuenta();

//        //LISTAR TODOS
//        public List<UsuarioCuentaDTO> ListarCuentasCN(string filtro = null)
//        {
//            if (string.IsNullOrEmpty(filtro))
//            {
//                return datos.ListarCuentas();
//            }

//            switch(filtro.ToLower())
//            {
//                case "activos":
//                    return datos.ListarCuentas(1);

//                case "bloqueados":
//                    return datos.ListarCuentas(2);

//                default:
//                    //SI ES NULL TRAE TODOS
//                    return datos.ListarCuentas();

//            }
                
//        }

//        // Buscar cuentas
//        public List<UsuarioCuentaDTO> BuscarCuentasCN(string termino)
//        {
//            return datos.BuscarCuentas(termino);
//        }

//        // =============== OBTENER POR ID ===============

//        public  UsuarioCuentaDTO ObtenerCuentaPorIDCN(int cuentaID)
//        {
//            if (cuentaID==0)
//            {
//               return null;
//            }
//            return datos.ObtenerCuentaPorID(cuentaID);
//        }


//        // =============== CREAR ===============
//        public notifyDTO CrearCuentaCN(CrearCuentaDTO nueva)
//        {
//            // Validación básica: objeto no nulo
//            if (nueva == null)
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "Los datos de la cuenta no pueden estar vacíos"
//                };
//            }

//            // Validaciones básicas antes de enviar al SP
//            if (string.IsNullOrWhiteSpace(nueva.Email))
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "El email es obligatorio"
//                };
//            }

//            if (string.IsNullOrWhiteSpace(nueva.Password))
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "La contraseña es obligatoria"
//                };
//            }

//            if (nueva.Rol == 0 )
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "El rol es obligatorio"
//                };
//            }
//            // Llamar a la capa de datos
//            return datos.CrearCuenta(nueva);
//        }

//        // =============== CAMBIAR ESTADO ===============
//        public notifyVarDTO CambiarEstadoCuentaCN(int cuentaID, byte nuevoEstado)
//        {
//            //Llamar al metodo de datos
//            notifyVarDTO resultadoDatos = datos.CambiarEstadoCuenta(cuentaID, nuevoEstado);

//            return resultadoDatos;
      
//        }

//        // ========== METODO PARA CONTAR CUANTOS ADMIN QUEDAN CON ESTADO ACTIVO ==========
//        // Esto para validar el cambio de estilo en el front
//        public int ContarAdministradoresActivosCN()
//        {
//            return datos.ContarAdministradoresActivos();
//        }



//        // ======= METODO PARA CAMBIAR DE ROL =========
//        public notifyDTO CambiarRol(int cuentaID, byte nuevoRol)
//        {
//            try
//            {
//                return datos.CambiarRol(cuentaID, nuevoRol);
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

//        // =============== ELIMINAR ===============
//        public notifyDTO EliminarCuentaCN(int cuentaID)
//        {
//            // Validar parámetro
//            if (cuentaID <= 0)
//            {
//                return new notifyDTO
//                {
//                    resultado = false,
//                    mensajeSalida = "ID de cuenta inválido"
//                };
//            }

//            // ✅ Llamar UNA SOLA VEZ y retornar directamente
//            return datos.EliminarCuenta(cuentaID);
//        }
//    }
//}
