# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Colitas Felices** — An ASP.NET Web Forms application for a pet adoption NGO. It manages pets, user accounts, adoptions, and volunteers. Deployed to Azure Web Apps via GitHub Actions.

**Target Framework**: .NET Framework 4.8.1 (no .NET Core/5+)  
**No solution (.sln) file** — projects are opened/built individually.

## Build & Run

Build via Visual Studio 2022 (open `colitas_felices/colitas_felices.csproj`) or MSBuild:

```bash
# Restore NuGet packages
nuget restore colitas_felices/colitas_felices.csproj

# Build
msbuild colitas_felices/colitas_felices.csproj /p:Configuration=Debug
```

Run locally through IIS Express from Visual Studio (SSL on port 44360).

**Required before first run:**
- SQL Server LocalDB with database `DB_ColitasFelices` (schema in `SQL DE LA BASE DE DATOS/BASE DE DATOS CENTRAL.sql`)
- `AppSecrets.config` in `colitas_felices/` (git-ignored) with Gmail OAuth, Google OAuth, and Azure Blob Storage credentials

## Architecture

Strict 3-layer separation. Each layer is its own `.csproj`:

| Project | Role |
|---------|------|
| `capa_DTO/` | DTOs shared across all layers; no logic |
| `capa_datos/` | Data access via LINQ to SQL (`ColitasFelices.dbml`) |
| `capa_negocio/` | Business logic and validations |
| `colitas_felices/` | ASP.NET Web Forms presentation layer |

Dependencies flow one way: `colitas_felices` → `capa_negocio` → `capa_datos` → `capa_DTO`

### Naming Conventions

- `CD_*` classes live in `capa_datos/` — raw LINQ queries, one class per domain
- `CN_*` classes live in `capa_negocio/` — validations + orchestration, delegate to `CD_*`
- `*DTO` classes live in `capa_DTO/` — plain data carriers

### Standard Response Pattern

All inter-layer calls return `notifyDTO` or `notifyVarDTO`:

```csharp
notifyDTO      { bool resultado; string mensajeSalida; }
notifyVarDTO   { int codigo; object datos; }  // inherits notifyDTO
```

Never throw exceptions across layer boundaries — always return a `notifyDTO`.

### Data Access

LINQ to SQL on `ColitasFelicesDataContext` (generated from `capa_datos/ColitasFelices.dbml`). Do not use raw ADO.NET or stored procedures for new features. To change the schema, update the `.dbml` designer and re-run code generation.

### AJAX / HTTP Handlers

Async operations use `.ashx` HTTP handlers in `colitas_felices/Handlers/`. They implement `IHttpHandler` + `IRequiresSessionState` and return JSON: `{"ok": true, "msg": "..."}`.

### Authentication

Session-based: `Session["CuentaID"]` and `Session["RolID"]`. Pages requiring auth inherit from `NotifyLogic` (in `Helpers/`) which checks session on `Page_Load`. Google OAuth is handled via `Helpers/GoogleAuth.ashx`.

Account lockout escalation: 15 min → 1 hr → 1 day, managed in `CN_Login`.

### Routing

All routes registered in `colitas_felices/App_Start/RouteConfig.cs` using `MapPageRoute`. Key routes:

| Friendly URL | Physical Page |
|---|---|
| `/` or `/principal` | `frontend/start.aspx` |
| `/iniciar_sesion` | `login/login_registro.aspx` |
| `/Adopta` | `frontend/adopciones.aspx` |
| `/Mascotas` | `frontend/mascota_detalle.aspx` |
| `/Admin` | `admin/ad_main.aspx` |
| `/MascotasAdmin` | `admin/Mascotas/view_mascotas.aspx` |
| `/MascotasAdmin/Form` | `admin/Mascotas/mascotasForm.aspx` |
| `/CuentasAdmin` | `admin/Cuentas/view_cuentas.aspx` |

### External Services

- **Azure Blob Storage**: Pet photos and email assets. Containers initialized at startup in `Helpers/AzureInit.cs`. In DEBUG, uses Azurite (local emulator).
- **Gmail API**: Email sending via `capa_negocio/Email/CN_Email.cs` (not SMTP). Credentials come from `AppSecrets.config`.
- **Google OAuth**: Login via Google, callback handled by `Helpers/GoogleAuth.ashx`.

## CI/CD

`.github/workflows/master_colitasfelices.yml` builds and deploys on push to `master`:
1. MSBuild → publish to `/published/`
2. Deploy artifact to Azure Web App `colitasfelices` (Production slot)

The publish profile is stored in GitHub Secrets (`AZUREAPPSERVICE_PUBLISHPROFILE_*`).
