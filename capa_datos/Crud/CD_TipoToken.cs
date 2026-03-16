using System;
using System.Linq;
using System.Diagnostics;

namespace capa_datos.Crud
{
    public class CD_TokenTipo
    {
        public int ObtenerDuracion(byte tipoId)
        {
            try
            {
                using (var db = new ColitasFelicesDataContext())
                {
                    var tipo = db.Token_tipo.FirstOrDefault(t => t.TipoID == tipoId);
                    return tipo?.DuracionMin ?? 15;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("[CD_TokenTipo] Error en ObtenerDuracion: " + ex.Message);
                return 15;
            }
        }
    }
}