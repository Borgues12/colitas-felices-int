# Sistema CSS - Colitas Felices

## Estructura
```
src/css/
├── global.css          ← MasterPage (base para TODO)
├── home_style.css      ← Solo layout del home
├── registro_style.css  ← Solo layout de registro
├── login_style.css     ← Solo layout de login
└── [pagina]_style.css  ← Solo layout específico
```

## global.css contiene

| Sección | Clases principales |
|---------|-------------------|
| **Variables** | `--color-primary`, `--color-secondary`, `--spacing-*`, `--radius-*`, `--shadow-*` |
| **Navbar** | `.navbar`, `.nav-menu`, `.nav-link`, `.dropdown`, `.btn-login`, `.user-dropdown` |
| **Footer** | `.footer`, `.footer-container`, `.footer-section`, `.social-links` |
| **Botones** | `.btn`, `.btn-primary`, `.btn-secondary`, `.btn-success`, `.btn-sm`, `.btn-lg`, `.btn-block` |
| **Formularios** | `.input-group`, `.input-field`, `.select-field`, `.textarea-field`, `.password-container` |
| **Mensajes** | `.mensaje-exito`, `.mensaje-error`, `.mensaje-warning`, `.mensaje-info` |
| **Cards** | `.card`, `.card-body`, `.card-title`, `.card-image` |
| **Modales** | `.modal`, `.modal-backdrop`, `.modal-header`, `.modal-body`, `.modal-footer` |
| **Tablas** | `.table` con thead estilizado |
| **Badges** | `.badge-primary`, `.badge-success`, `.badge-warning`, `.badge-error` |
| **Loading** | `.loading-overlay`, `.spinner` |
| **Utilidades** | `.mt-*`, `.mb-*`, `.p-*`, `.d-flex`, `.text-center`, `.gap-*`, `.container` |
| **Animaciones** | `fadeIn`, `fadeInUp`, `shake`, `pulse` |

## Regla de uso

**global.css** → Componentes reutilizables (qué son y cómo se ven)
**[pagina]_style.css** → Layout específico (dónde van en esa página)

```css
/* En página específica, usa variables globales */
.mi-seccion {
    padding: var(--spacing-2xl);
    background: var(--color-surface);
    border-radius: var(--radius-xl);
}
```