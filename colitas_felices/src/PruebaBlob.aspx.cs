//using System;
//using capa_negocio;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace colitas_felices.src
//{
//    public partial class PruebaBlob : System.Web.UI.Page
//    {
//        protected void btnSubir_Click(object sender, EventArgs e)
//        {
//            if (!fileUploadFoto.HasFile)
//            {
//                lblMensaje.Text = "Selecciona una foto primero.";
//                lblMensaje.ForeColor = System.Drawing.Color.Red;
//                return;
//            }

//            try
//            {
//                var cn = new CN_BlobStorage();

//                // RegisterAsyncTask permite ejecutar código async en WebForms
//                RegisterAsyncTask(new PageAsyncTask(async () =>
//                {
//                    string url = await cn.SubirFotoMascota(
//                        fileUploadFoto.FileName,
//                        fileUploadFoto.PostedFile.InputStream,
//                        fileUploadFoto.PostedFile.ContentType,
//                        fileUploadFoto.PostedFile.ContentLength
//                    );

//                    imgPreview.ImageUrl = url;
//                    imgPreview.Visible = true;
//                    lblMensaje.Text = "¡Foto subida exitosamente!";
//                    lblMensaje.ForeColor = System.Drawing.Color.Green;
//                }));
//            }
//            catch (InvalidOperationException ex)
//            {
//                lblMensaje.Text = ex.Message;
//                lblMensaje.ForeColor = System.Drawing.Color.Red;
//            }
//        }

//        protected void btnListar_Click(object sender, EventArgs e)
//        {
//            try
//            {
//                var cn = new CN_BlobStorage();
//                var fotos = cn.ObtenerFotos();
//                rptFotos.DataSource = fotos;
//                rptFotos.DataBind();
//            }
//            catch (Exception ex)
//            {
//                lblMensaje.Text = "Error al listar: " + ex.Message;
//                lblMensaje.ForeColor = System.Drawing.Color.Red;
//            }
//        }
//    }
//}