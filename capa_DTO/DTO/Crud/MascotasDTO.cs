using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_DTO.DTO.Crud
{
    // ============================================================
    // DTO principal — viaja entre Datos → Negocio → Front
    // ============================================================
    public class MascotaDto
    {
        public int MascotaID { get; set; }
        public string Nombre { get; set; }

        public byte EspecieID { get; set; }
        public string EspecieNombre { get; set; }

        public short RazaID { get; set; }
        public string RazaNombre { get; set; }

        // Enums quemados en BD
        // Sexo:    1=Macho  2=Hembra  3=Desconocido
        // Tamanio: 1=Pequeño  2=Mediano  3=Grande  4=Gigante
        public byte Sexo { get; set; }
        public byte Tamanio { get; set; }

        public string Color { get; set; }
        public DateTime? FechaNacimientoAprox { get; set; }
        public string Descripcion { get; set; }

        public byte EstadoMascotaID { get; set; }
        public string EstadoNombre { get; set; }
        public bool EsVisible { get; set; } // del catálogo Estado_mascota

        public bool EsAdoptable { get; set; } // false = granja
        public bool Esterilizado { get; set; }
        public DateTime? FechaEsterilizacion { get; set; }
        public string NumeroMicrochip { get; set; }

        public DateTime FechaRegistro { get; set; }
        public DateTime? FechaActualizacion { get; set; }
        public int RegistradoPor { get; set; }

        // Se cargan según necesidad (listado solo trae foto principal)
        public List<MascotasFotoDto> Fotos { get; set; } = new List<MascotasFotoDto>();
        public List<DTO_CondicionEspecial> Condiciones { get; set; } = new List<DTO_CondicionEspecial>();

        // IDs de los checkboxes marcados al guardar
        public List<short> CondicionesSeleccionadas { get; set; } = new List<short>();

        // ---- Helpers de presentación (sin lógica de negocio) ----
        public string SexoTexto
        {
            get
            {
                switch (Sexo)
                {
                    case 1: return "Macho";
                    case 2: return "Hembra";
                    default: return "Desconocido";
                }
            }
        }

        public string TamanioTexto
        {
            get
            {
                switch (Tamanio)
                {
                    case 1: return "Pequeño";
                    case 2: return "Mediano";
                    case 3: return "Grande";
                    case 4: return "Gigante";
                    default: return "-";
                }
            }
        }

        public string EdadAproximada
        {
            get
            {
                if (!FechaNacimientoAprox.HasValue) return "Desconocida";
                int meses = ((DateTime.Today.Year - FechaNacimientoAprox.Value.Year) * 12)
                           + DateTime.Today.Month - FechaNacimientoAprox.Value.Month;
                if (meses < 1) return "Recién llegado";
                if (meses < 12) return meses + (meses == 1 ? " mes" : " meses");
                int anios = meses / 12;
                return anios + (anios == 1 ? " año" : " años");
            }
        }

        public string FotoPrincipalUrl
        {
            get
            {
                foreach (var f in Fotos)
                    if (f.EsPrincipal) return f.BlobUrl;
                return Fotos.Count > 0 ? Fotos[0].BlobUrl : null;
            }
        }
    }

    // ============================================================
    // Filtros para listado — admin y landing usan el mismo DTO
    // ============================================================
    public class DTO_MascotaFiltro
    {
        public byte? EspecieID { get; set; }
        public byte? EstadoMascotaID { get; set; }
        public bool? EsAdoptable { get; set; } // null = todos
        public bool? SoloVisibles { get; set; } // true para la landing
        public string NombreBusqueda { get; set; }
        public int Pagina { get; set; } = 1;
        public int RegistrosPorPagina { get; set; } = 20;
    }

    // ============================================================
    // Foto — referencia a Blob Storage
    // ============================================================
    public class MascotasFotoDto
    {
        public int FotoID { get; set; }
        public int MascotaID { get; set; }
        public string NombreArchivo { get; set; }
        public string BlobUrl { get; set; }
        public bool EsPrincipal { get; set; }
        public byte Orden { get; set; }
        public DateTime FechaSubida { get; set; }
        public int SubidoPor { get; set; }
    }

    // ============================================================
    // Condición especial — Seleccionada para los checkboxes
    // ============================================================
    public class DTO_CondicionEspecial
    {
        public short CondicionID { get; set; }
        public string Nombre { get; set; }
        public bool Activo { get; set; }
        public bool Seleccionada { get; set; }
    }

    // ============================================================
    // Catálogos para dropdowns
    // ============================================================
    public class DTO_Especie
    {
        public byte EspecieID { get; set; }
        public string Nombre { get; set; }
        public bool Activo { get; set; }
    }

    public class DTO_Raza
    {
        public short RazaID { get; set; }
        public byte EspecieID { get; set; }
        public string Nombre { get; set; }
        public bool Activo { get; set; }
    }

    public class DTO_EstadoMascota
    {
        public byte EstadoMascotaID { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public bool EsVisible { get; set; }
        public bool Activo { get; set; }
    }

    // ============================================================
    // Resultado genérico para operaciones de escritura
    // ============================================================
    public class DTO_ResultadoOperacion
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public int ID { get; set; } // ID del registro afectado

        public static DTO_ResultadoOperacion Ok(string mensaje = "Operación exitosa", int id = 0)
            => new DTO_ResultadoOperacion { Exito = true, Mensaje = mensaje, ID = id };

        public static DTO_ResultadoOperacion Error(string mensaje)
            => new DTO_ResultadoOperacion { Exito = false, Mensaje = mensaje };
    }

    // Para pasar el stream de cada foto desde el front al negocio
    public class MascotasFotoStreamDto
    {
        public Stream Stream { get; set; }
        public string ContentType { get; set; }
        public string NombreArchivo { get; set; }
    }
}