<%@ WebHandler Language="C#" Class="MascotaEstadoHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using capa_negocio.Mascotas;
using capa_dto;

public class MascotaEstadoHandler : IHttpHandler, IRequiresSessionState
{
    private readonly CN_Mascotas _cn = new CN_Mascotas();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string accion = context.Request["accion"];

        switch (accion)
        {
            case "cambiarEstado": CambiarEstado(context); break;
            default: Error(context, "Acción desconocida."); break;
        }
    }

    private void CambiarEstado(HttpContext ctx)
    {
        if (!int.TryParse(ctx.Request["mascotaID"], out int mascotaID)) { Error(ctx, "MascotaID inválido."); return; }
        if (!byte.TryParse(ctx.Request["estadoID"], out byte estadoID)) { Error(ctx, "EstadoID inválido.");  return; }

        var r = _cn.CambiarEstado(mascotaID, estadoID);
        Responder(ctx, r);
    }

    private void Responder(HttpContext ctx, notifyDTO r) =>
        ctx.Response.Write(
            "{\"ok\":"    + (r.resultado ? "true" : "false") +
            ",\"msg\":\"" + r.mensajeSalida + "\"}");

    private void Error(HttpContext ctx, string msg) =>
        ctx.Response.Write("{\"ok\":false,\"msg\":\"" + msg + "\"}");

    public bool IsReusable => false;
}