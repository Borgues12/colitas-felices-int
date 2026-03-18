<%@ WebHandler Language="C#" Class="FotosMascotaHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using capa_negocio.Mascotas;
using capa_DTO.DTO.Crud;
using capa_dto;

public class FotosMascotaHandler : IHttpHandler, IRequiresSessionState
{
    private readonly CN_MascotaFoto _cn = new CN_MascotaFoto();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string accion = context.Request["accion"];

        switch (accion)
        {
            case "obtener":   Obtener(context);   break;
            case "eliminar":  Eliminar(context);  break;
            case "principal": Principal(context); break;
            case "subir":     Subir(context);     break;
            default:
                context.Response.Write("{\"ok\":false,\"msg\":\"Acción desconocida.\"}");
                break;
        }
    }

    // ── 1. Obtener fotos ─────────────────────────────────
    private void Obtener(HttpContext ctx)
    {
        if (!int.TryParse(ctx.Request["mascotaID"], out int mascotaID))
        { Error(ctx, "MascotaID inválido."); return; }

        var fotos = _cn.ObtenerPorMascota(mascotaID);

        // Construir JSON manualmente — sin dependencias externas
        var sb = new System.Text.StringBuilder();
        sb.Append("{\"ok\":true,\"fotos\":[");

        for (int i = 0; i < fotos.Count; i++)
        {
            var f = fotos[i];
            if (i > 0) sb.Append(",");
            sb.Append("{");
            sb.Append("\"FotoID\":"      + f.FotoID + ",");
            sb.Append("\"BlobUrl\":\""   + f.BlobUrl + "\",");
            sb.Append("\"EsPrincipal\":" + (f.EsPrincipal ? "true" : "false") + ",");
            sb.Append("\"Orden\":"       + f.Orden);
            sb.Append("}");
        }

        sb.Append("]}");
        ctx.Response.Write(sb.ToString());
    }

    // ── 2. Eliminar foto ─────────────────────────────────
    private void Eliminar(HttpContext ctx)
    {
        if (!int.TryParse(ctx.Request["fotoID"],    out int fotoID))    { Error(ctx, "FotoID inválido.");    return; }
        if (!int.TryParse(ctx.Request["mascotaID"], out int mascotaID)) { Error(ctx, "MascotaID inválido."); return; }

        var r = _cn.Eliminar(fotoID, mascotaID);
        Responder(ctx, r);
    }

    // ── 3. Cambiar principal ─────────────────────────────
    private void Principal(HttpContext ctx)
    {
        if (!int.TryParse(ctx.Request["fotoID"],    out int fotoID))    { Error(ctx, "FotoID inválido.");    return; }
        if (!int.TryParse(ctx.Request["mascotaID"], out int mascotaID)) { Error(ctx, "MascotaID inválido."); return; }

        var r = _cn.MarcarPrincipal(mascotaID, fotoID);
        Responder(ctx, r);
    }

    // ── 4. Subir fotos nuevas ────────────────────────────
    private void Subir(HttpContext ctx)
    {
        if (!int.TryParse(ctx.Request["mascotaID"], out int mascotaID)) { Error(ctx, "MascotaID inválido."); return; }
        int subidoPor = ctx.Session["CuentaID"] != null ? (int)ctx.Session["CuentaID"] : 1;

        var fotos = new List<MascotasFotoStreamDto>();
        for (int i = 0; i < ctx.Request.Files.Count; i++)
        {
            var f = ctx.Request.Files[i];
            if (f != null && f.ContentLength > 0)
                fotos.Add(new MascotasFotoStreamDto
                {
                    Stream        = f.InputStream,
                    ContentType   = f.ContentType,
                    NombreArchivo = f.FileName
                });
        }

        if (fotos.Count == 0) { Error(ctx, "No se recibieron archivos."); return; }

        var r = _cn.AgregarFotos(mascotaID, fotos, subidoPor);
        Responder(ctx, r);
    }

    // ── Helpers ──────────────────────────────────────────
    private void Responder(HttpContext ctx, notifyDTO r) =>
        ctx.Response.Write(
            "{\"ok\":"  + (r.resultado ? "true" : "false") +
            ",\"msg\":\"" + r.mensajeSalida + "\"}");

    private void Error(HttpContext ctx, string msg) =>
        ctx.Response.Write("{\"ok\":false,\"msg\":\"" + msg + "\"}");

    public bool IsReusable => false;
}
