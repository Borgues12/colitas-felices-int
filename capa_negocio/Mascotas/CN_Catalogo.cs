using capa_datos.Crud;
using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace capa_negocio.Mascotas
{
    public class CN_Catalogo
    {
        private readonly CD_Catalogo _cdCatalogo = new CD_Catalogo();

        public List<DTO_Especie> ObtenerEspecies()
        {
            try { return _cdCatalogo.ObtenerEspecies(); }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Catalogo] Error en ObtenerEspecies: " + ex.Message);
                return new List<DTO_Especie>();
            }
        }

        public List<DTO_Raza> ObtenerRazas()
        {
            try { return _cdCatalogo.ObtenerRazas(); }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Catalogo] Error en ObtenerRazas: " + ex.Message);
                return new List<DTO_Raza>();
            }
        }

        public List<DTO_EstadoMascota> ObtenerEstadosMascota()
        {
            try { return _cdCatalogo.ObtenerEstadosMascota(); }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Catalogo] Error en ObtenerEstadosMascota: " + ex.Message);
                return new List<DTO_EstadoMascota>();
            }
        }

        public List<DTO_CondicionEspecial> ObtenerCondiciones()
        {
            try { return _cdCatalogo.ObtenerCondiciones(); }
            catch (Exception ex)
            {
                Debug.WriteLine("[CN_Catalogo] Error en ObtenerCondiciones: " + ex.Message);
                return new List<DTO_CondicionEspecial>();
            }
        }
    }
}