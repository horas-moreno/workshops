# Guía de Demo: Uso Avanzado de Cursor para Desarrollo Asistido por IA

Esta guía paso a paso servirá como guion para una demo práctica mostrando cómo aprovechar funcionalidades avanzadas de Cursor para potenciar el flujo de desarrollo.

**En esta sesión cubriremos**:

1. **Contexto adecuado** – Cómo preparar el contexto para trabajar con flujos de desarrollo asistidos por IA.
2. **Reglas (Rules)** – Cómo crear y usar reglas personalizadas en Cursor para guiar a la IA.
3. **Gestión de tareas** – Cómo dividir el trabajo en tareas claras, gestionar su estado y mantener a la IA enfocada.
4. **Documentación interna** – Cómo agregar documentación de librerías o módulos internos del proyecto para que la IA las use.
5. **Múltiples workspaces** – Cómo manejar varios proyectos o repos a la vez en Cursor.
6. **Perfiles y modelos** – Cómo definir modos personalizados según el tipo de tarea (debugging, documentación, refactorización), usando los modelos disponibles en Cursor.

Cada sección incluye **ejemplos prácticos, comandos específicos** y casos de uso recomendados para demostrar en vivo. ¡Comencemos!

---

## 1. Preparando el contexto para flujos de desarrollo IA

Un buen resultado con IA depende en gran medida de proporcionar **contexto relevante**. Cursor puede indexar tu código y encontrar automáticamente partes pertinentes, pero siempre es recomendable **alimentar manualmente la información clave** al modelo. Recuerda: la IA es como un desarrollador junior muy literal; no esperes que _"adivine"_ requisitos que no le has dado.

### ¿Qué incluye el contexto?

- **Estado actual**: código, errores, logs, etc.
- **Intención o requerimiento**: lo que se quiere lograr.

Si das muy poco contexto, el modelo intentará rellenar huecos por su cuenta, lo que suele causar alucinaciones o soluciones desorientadas.

### Buenas prácticas en Cursor

- **Documentación de arquitectura y requisitos** (`architecture.mermaid`, `technical.md`).
- **Referencias directas (@)** para adjuntar archivos/fragmentos en el prompt.
- **Modo _Codebase Q&A_** para explorar la base de código (`Ctrl+Enter`).

**🎬 Demo**

```
@{docs/architecture.mermaid} @{tasks/tasks.md}
Necesito agregar autenticación JWT según la tarea USER-001 descrita en tasks.md. ¿Qué pasos debo seguir?
```

**Prompts genéricos para documentar arquitectura y requisitos**

Puedes usar los siguientes prompts en Cursor para crear o enriquecer la documentación de arquitectura y requisitos en los archivos `architecture.mermaid` y `technical.md`:

- _Para crear un diagrama base de arquitectura:_
  ```
  Quiero documentar la arquitectura de este proyecto usando Mermaid. ¿Podrías generar un diagrama de alto nivel que muestre los principales módulos, servicios y cómo se comunican entre sí? El resultado debe estar en formato Mermaid.
  ```
- _Para detallar un flujo específico:_
  ```
  Necesito un diagrama Mermaid que describa el flujo de autenticación de usuarios en el sistema, desde el frontend hasta la base de datos. Incluye los componentes involucrados y las interacciones principales.
  ```
- _Para generar requisitos funcionales:_
  ```
  Por favor, genera una sección de requisitos funcionales para este proyecto. Enumera las funcionalidades principales que debe cumplir el sistema, usando viñetas y descripciones claras.
  ```
- _Para requisitos no funcionales:_
  ```
  ¿Podrías listar los requisitos no funcionales relevantes para este proyecto? Incluye aspectos como seguridad, rendimiento, escalabilidad y mantenibilidad.
  ```
- _Para describir decisiones técnicas:_
  ```
  Necesito documentar las principales decisiones técnicas tomadas en el proyecto, como la elección de frameworks, bases de datos y patrones de arquitectura. ¿Podrías generar una tabla o lista con cada decisión y su justificación?
  ```
- _Para checklist de criterios de aceptación:_
  ```
  Por favor, crea un checklist de criterios de aceptación para la funcionalidad de registro de usuarios, siguiendo el formato Markdown.
  ```

---

## 2. Uso avanzado de Reglas (Rules)

Las **Reglas** permiten definir instrucciones persistentes que guían a la IA en todo momento.

### Tipos

- **Reglas de Proyecto** (`.cursor/rules/*.mdc`).
- **Reglas de Usuario** (globales).

### Pasos para crear una regla

1. `Cmd+Shift+P` → "File: New Cursor Rule".
2. Completar `Description` y `Globs`.
3. Escribir instrucciones bajo el separador `---`.
4. Guardar y probar.

### ¿Qué es el "Rule Type" y cómo se usa?

Al crear una regla en Cursor, puedes elegir el **Rule Type** desde un desplegable en la parte superior del editor de reglas. Los tipos más comunes son:

- **Always:** La regla se aplica a todas las interacciones (chat y comandos).
- **Only in chat:** Solo afecta las respuestas de la IA en el chat.
- **Only in command+K:** Solo afecta las acciones rápidas o comandos.
- **Never:** La regla está desactivada.

**Recomendación:**
Para reglas críticas de flujo de trabajo (como la gestión de tareas y estado), usa "Always". Para reglas de estilo o sugerencias, puedes usar "Only in chat".

**🎬 Demo**  
Creación de `estilo-frontend.mdc` (`**/*.tsx`) con la instrucción "Usa clases de Tailwind CSS en JSX" y ver cómo la IA adopta el estilo.
Pro tip usar el comando /Generate Cursor Rules para que cursor cree sus propias reglas basado en el contexto

---

## 3. Gestión de tareas y estados

- **`tasks.md`**: historias con requisitos y criterios de aceptación.
- **`status.md`**: checklist de progreso (`[x]`).

Itera tarea por tarea, reinyectando contexto con `@` y pidiendo a la IA actualizar `status.md`.

**🎬 Demo**  
Implementar `USER-001`, marcar subtareas completas, ciclo plan–código–estado.

**Ejemplo de script Bash para autogestión de tareas y estado**

Puedes usar un script como este para que Cursor (o cualquier desarrollador) gestione y actualice automáticamente los archivos `tasks.md` y `status.md`:

**Ejemplo de uso del script**

1. Guarda el script anterior como `workshop/cursor_task_manager.sh` en la carpeta `workshop`.
2. Crea los archivos iniciales `workshop/tasks.md` y `workshop/status.md` con el siguiente contenido:

   **workshop/tasks.md**

   ```markdown
   # Tareas del Proyecto

   - [ ] USER-001: Implementar autenticación JWT
   - [x] USER-002: Configurar CI/CD
   - [ ] USER-003: Crear página de perfil de usuario
   ```

   **workshop/status.md**

   ```markdown
   # Estado del Proyecto

   ## Tarea actual

   USER-001: Implementar autenticación JWT

   ## Progreso

   - USER-002 completada
   - USER-001 en curso

   ## Bloqueos

   - Falta definir endpoint de login con backend

   ## Próximos pasos

   - Terminar integración JWT
   - Escribir tests de autenticación
   ```

3. Dale permisos de ejecución:
   ```bash
   chmod +x workshop/cursor_task_manager.sh
   ```
4. Ejecuta el script:
   ```bash
   ./workshop/cursor_task_manager.sh
   ```
5. Usa el menú interactivo para agregar, completar tareas o registrar bloqueos. Por ejemplo:
   - Agrega una tarea: `USER-004: Mejorar documentación`
   - Márcala como completada desde el menú.
   - Consulta el estado y bloqueos registrados.

Esto permite que el equipo y la IA mantengan un seguimiento claro y actualizado del progreso del proyecto en la carpeta `workshop`.

---

## 4. Documentación de librerías internas

1. _Settings → Features → Docs → Add new doc_.
2. Pegar URL de documentación (Markdown/HTML/gist).
3. Usar en chat con `@NombreDoc`.

**🎬 Demo**  
Añadir `https://docs.cursor.com` como `CursorDocs` y consultarlo.

---

## 5. Múltiples workspaces

- **Varias ventanas**: `Shift+Cmd+N`.
- **Multi-root workspace**: _File → Add Folder to Workspace..._.
- **Guardar Workspace**: Debemos guardar el workspace en algun folder para tener la referencia del mismo.
- **Reglas específicas por proyecto** en carpetas `.cursor/rules`.

**🎬 Demo**  
Workspace con `backend/` y `frontend/`; referenciar archivos de ambas carpetas y mostrar reglas diferenciales.

---

## 6. Perfiles personalizados (Custom Modes)

Permiten ajustar herramientas, modelo y tono según la tarea.

### Crear un modo

1. En chat → menú de modo → "+ Add custom mode".
2. Nombrar, seleccionar icono y atajo.
3. Elegir herramientas permitidas.
4. Añadir instrucciones persistentes.
5. Guardar.

### Ejemplos útiles

- **Debug Mode**: explicación detallada, terminal habilitada.
- **Refactor Mode**: solo editar, sin añadir features.
- **Documentation Mode**: generar doc en Markdown, sin tocar código.
- **YOLO Mode**: todas las herramientas y auto‑apply (solo para tests).

**🎬 Demo**  
Crear "Modo Explicativo" (solo lectura, respuestas detalladas) y "Modo Refactor" (respuesta concisa con código refactorizado). Comparar resultados en la misma función.

---

## Conclusión

Con estas prácticas (contexto, reglas, backlog, docs, multi‑workspace y perfiles) **Cursor se convierte en un compañero de equipo** que entiende tu proyecto, obedece convenciones y acelera la entrega de código limpio. ¡Listo para el workshop!

## Notas:

- [Presentación del Workshop](https://docs.google.com/presentation/d/1PAYamPT12UCFBL7SFhoUKSDaHj8cAO0kfs0YlR7Dkhk/edit?usp=sharing)
