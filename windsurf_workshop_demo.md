# Guía de Demo: Uso Avanzado de **Windsurf / Cascade** para Desarrollo Asistido por IA

Esta guía paso a paso sirve como **guion (60 min)** para una demo práctica equivalente a la de Cursor, pero usando **Windsurf** (ex‑Codeium). Está pensada para desarrolladores **backend, frontend y managers**.

**Temas que cubriremos**:

1. **Contexto con Cascade** – cómo alimentar y reutilizar contexto de forma efectiva.
2. **Memories & Rules** – persistir conocimiento de dominio y estilo.
3. **Workflows + Gestión de tareas** – definir pasos repetibles y mantener estado.
4. **Web & Docs Search** – añadir documentación interna o externa.
5. **Múltiples workspaces / microservicios** – trabajo con varios repos en paralelo.
6. **Custom Modes, Modelo y MCP** – perfiles a medida según la tarea.

Cada apartado trae **ejemplos, comandos y demos** para pantalla compartida.

> **Nota:** La estructura y ejemplos reflejan la guía de Cursor provista fileciteturn0file0  
> ajustados al ecosistema Windsurf.

---

## 1. Preparando el contexto con **Cascade**

Cascade es el motor de IA de Windsurf. Al invocarlo (`Cmd/Ctrl + L` o botón _Cascade_), envía:

1. **Selección actual** (código, log, diff).
2. **Contexto implícito** detectado (archivos relacionados).
3. **Historial reciente** de la conversación.

### Buenas prácticas

| Acción                                | Efecto                                                  |
| ------------------------------------- | ------------------------------------------------------- |
| **@‑mention** un archivo/carpeta      | Adjunta su contenido completo.                          |
| **Shift + Enter** tras pegar un error | Enmarca el _stack trace_ para que Cascade lo vea.       |
| **“Continue”** como prompt            | Reutiliza su contexto anterior si no añades nada nuevo. |

### Prompts para documentar arquitectura y requisitos

Los mismos prompts sugeridos para Cursor funcionan aquí; basta lanzarlos en Cascade:

_Generar diagrama base (Mermaid):_

```
Quiero documentar la arquitectura del proyecto en formato Mermaid...
```

_Checklist de aceptación, decisiones técnicas, etc._

**🎬 Demo Contexto**

1. Abre `docs/architecture.mermaid` y un bug en `AuthService.ts`.
2. Selecciona el bug → `Cmd+L` → escribe “Explain and fix”.
3. Muestra cómo Cascade lo arregla; luego pregunta **“Continue”** para ver siguiente error sin repetir contexto.

---

## 2. **Memories & Rules**

Windsurf ofrece:

| Tipo                | Ubicación              | Uso                                  |
| ------------------- | ---------------------- | ------------------------------------ |
| **Global Rules**    | `global_rules.md`      | Convenciones de empresa.             |
| **Workspace Rules** | `.windsurf/rules/*.md` | Específicas del proyecto.            |
| **Memories**        | Auto/manual            | Hechos aprendidos durante la sesión. |

### Crear una Rule

1. `Customizations → Rules → + Add`.
2. Completa **Description**, **Globs** y **Rule Type**: _Always_, _Only chat_, _Only Command +K_, _Disabled_.
3. Escribe contenido (bullet points, fragmentos de código).
4. Guarda — aparece en el Rules Panel.

**Pro tip:** comando `/generate-windsurf-rule` para que la IA proponga la regla basada en tus últimos commits.

**🎬 Demo Rules**

_Crear_ `tailwind-ui.mdrule` con glob `**/*.tsx` y la instrucción **“Usa clases Tailwind, evita inline styles.”**  
Solicita un botón; verifica que usa Tailwind.

---

## 3. **Workflows & Gestión de tareas**

### Workflows

Se guardan en `.windsurf/workflows/*.md`. Cada _step_ es un prompt. Invócalos con `/workflow-name`.

_Ejemplo `jwt-setup.workflow.md`:_

```markdown
# JWT Setup

## steps

1. Generar modelos bcrypt.
2. Crear endpoints login/register.
3. Añadir tests.
```

### Estado de proyecto

Puedes seguir usando `tasks.md` y `status.md` como en Cursor; Cascade lee Markdown igual de bien.

> **Script Bash**: el mismo `cursor_task_manager.sh` funciona (solo cambia rutas al directorio).

**🎬 Demo Workflows**

1. Ejecuta `/jwt-setup` → observa pasos.
2. Pide que Cascade actualice `status.md` con casillas `[x]`.

---

## 4. **Web & Docs Search**

Activa en **Settings → Features → Web & Docs**.

| Uso                     | Ejemplo                                   |
| ----------------------- | ----------------------------------------- |
| Búsqueda web automática | “¿Qué significa error 42 en Postgres?”    |
| `@web` forzado          | `@web Mejor puntuación de bcrypt`         |
| Indexar doc interna     | `@docs https://intra.company.com/libX.md` |

**🎬 Demo Docs**

Indexa `https://docs.example.com/api` y pregunta `@docs/api ¿Cómo inicializo el cliente?`.

---

## 5. **Multi‑workspace & microservicios**

- **Nueva ventana**: `File → New Window` para aislar contextos.
- **Multi‑root**: `File → Add Folder to Workspace…` (indexa ambos).
- Rules aplican por carpeta mediante globs.

**🎬 Demo**

Backend + Frontend: pide a Cascade alinear URLs REST; muestra reglas distintas por carpeta.

---

## 6. **Custom Modes, Modelo y MCP**

- Menú bajo el input → elegir **LLM** (GPT‑4o, Claude 3, Mistral, etc.).
- `Customizations → Modes → +` para crear un **Modo**:

| Campo        | Ejemplo (“Debug Mode”)                       |
| ------------ | -------------------------------------------- |
| Icono        | 🐞                                           |
| Atajo        | `Ctrl+Shift+D`                               |
| Herramientas | Terminal, Search, No auto‑apply              |
| Instrucción  | “Explica paso a paso antes de tocar código.” |

### MCP (Macro Command Processor)

Permite ejecutar pruebas, levantar contenedores o publicar previews directamente desde el chat. Actívalo en **Settings → Tools → MCP** y referencia comandos shell en tu prompt:

```
/// Run `npm test` and explain failures.
///
```

**🎬 Demo Modes**

1. Cambia a “Debug Mode”, selecciona test roto → pide explicación.
2. Cambia a “Refactor Mode” y solicita limpieza de la función.

---

## Conclusión

Con **Cascade, Memories & Rules, Workflows, Docs Search y Custom Modes**, Windsurf actúa como un miembro más del equipo, entendiendo tu codebase y acelerando la entrega de código limpio, documentado y testeado.  
Esta demo equipara las ventajas de Cursor, pero sobre la plataforma Windsurf.

#Notas:

- [Presentación del Workshop](https://docs.google.com/presentation/d/1PAYamPT12UCFBL7SFhoUKSDaHj8cAO0kfs0YlR7Dkhk/edit?usp=sharing)
