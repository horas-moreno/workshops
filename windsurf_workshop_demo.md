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
2. Selecciona el bug → `Cmd+L` → escribe "Explain and fix".
3. Muestra cómo Cascade lo arregla; luego pregunta **"Continue"** para ver siguiente error sin repetir contexto.

**Ejemplo avanzado con múltiples archivos:**
```
@AuthService.ts @UserModel.ts
¿Cómo puedo optimizar esta función para manejar autenticación de forma más segura?
```

**Manejo de contexto implícito:**
- Cascade detecta automáticamente archivos relacionados
- Muestra el contexto cargado en la vista previa
- Permite ajustar el contexto antes de enviar

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

**Pro tip:** comando `/generate-windsurf-rule` para que la IA proponga la regla basada en tus últimos commits.

**Verificación de reglas activas:**
- `Cmd+Shift+P` → "Windsurf: Show Active Rules"
- Muestra qué reglas están aplicándose al archivo actual
- Permite habilitar/deshabilitar temporalmente reglas

**Creación de memorias manuales:**
```
/memory add "El proyecto usa TypeScript con estricto null checking"
/memory add "El prefijo para componentes es 'App'"
```

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

**Ejemplo de workflow con parámetros:**
```markdown
# code-review.workflow.md
## steps
1. Revisa los cambios en {{file}}
2. Verifica que sigan las guías de estilo
3. Sugiere mejoras de rendimiento
```

**Pasaje de parámetros:**
```
/workflow code-review file=src/components/Button.tsx
```

> **Script Bash**: el mismo `cursor_task_manager.sh` funciona (solo cambia rutas al directorio).

**🎬 Demo Workflows**

1. Ejecuta `/jwt-setup` → observa pasos.
2. Pide que Cascade actualice `status.md` con casillas `[x]`.
3. Encadena workflows con salida como entrada:
   ```
   /workflow generate-tests | /workflow optimize-tests
   ```

---

## 4. **Web & Docs Search**

Activa en **Settings → Features → Web & Docs**.

| Uso                     | Ejemplo                                   |
| ----------------------- | ----------------------------------------- |
| Búsqueda web automática | “¿Qué significa error 42 en Postgres?”    |
| `@web` forzado          | `@web Mejor puntuación de bcrypt`         |
| `-site:example.com`     | Excluir dominios de la búsqueda           |
| `filetype:md`           | Buscar solo en archivos Markdown          |
| Indexar doc interna     | `@docs https://intra.company.com/libX.md` |
| Búsqueda avanzada      | `@web "error handling" site:github.com`  |

**🎬 Demo Docs**

Indexa `https://docs.example.com/api` y pregunta `@docs/api ¿Cómo inicializo el cliente?`.

---

## 5. **Multi‑workspace & microservicios**

- **Nueva ventana**: `File → New Window` para aislar contextos.
- **Multi‑root**: `File → Add Folder to Workspace…` (indexa ambos).
- **Configuración compartida**: Crea un archivo `.windsurf/shared_config.json`
  ```json
  {
    "rules": ["common-rules/*.md"],
    "mcpServers": ["filesystem", "memory"]
  }
  ```
- **Manejo de dependencias**:
  ```
  /add-dependency frontend/package.json backend/package.json
  ```
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

Permite ejecutar pruebas, levantar contenedores o publicar previews directamente desde el chat. Actívalo en **Settings → Tools → MCP** y referencia comandos shell en tu prompt:

**Ejemplos de MCP:**
```
/// Run `npm test` and explain failures.
///

/// Start development server and open browser
/// @mcp run:dev
///

/// Deploy to staging
/// @mcp deploy --env=staging
///
```

**Creación de atajos personalizados:**
1. `Cmd+,` → Keyboard Shortcuts
2. Busca "windsurf.commands"
3. Asigna atajos a comandos frecuentes

**Combinación de herramientas:**
```
/mode refactor --tools=terminal,search --model=gpt-4
```

**🎬 Demo Modes**

1. Cambia a “Debug Mode”, selecciona test roto → pide explicación.
2. Cambia a “Refactor Mode” y solicita limpieza de la función.

---

## Conclusión

## Resumen de Atajos Útiles

| Comando                     | Acción                                 |
|-----------------------------|---------------------------------------|
| `Cmd+L`                     | Abrir Cascade con selección actual    |
| `Cmd+Shift+P`               | Paleta de comandos                   |
| `Cmd+K Cmd+R`               | Mostar reglas activas                |
| `Cmd+Shift+F`               | Búsqueda en todo el workspace        |
| `Cmd+P`                     | Búsqueda rápida de archivos          |
| `Cmd+Shift+E`               | Explorador de archivos               |
| `Cmd+B`                     | Alternar barra lateral               |
| `Cmd+\`                     | Dividir editor                       |

## Recursos Adicionales

- [Documentación oficial de Windsurf](https://docs.windsurf.dev)
- [Guía de migración desde Cursor](https://docs.windsurf.dev/guides/migrating-from-cursor)
- [Foro de la comunidad](https://community.windsurf.dev)

Con **Cascade, Memories & Rules, Workflows, Docs Search y Custom Modes**, Windsurf actúa como un miembro más del equipo, entendiendo tu codebase y acelerando la entrega de código limpio, documentado y testeado.  
Esta demo equipara las ventajas de Cursor, pero sobre la plataforma Windsurf, ofreciendo una experiencia de desarrollo más fluida y personalizable.

#Notas:

- [Presentación del Workshop](https://docs.google.com/presentation/d/1PAYamPT12UCFBL7SFhoUKSDaHj8cAO0kfs0YlR7Dkhk/edit?usp=sharing)
