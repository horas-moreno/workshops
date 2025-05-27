#!/bin/bash

TASKS_FILE="tasks.md"
STATUS_FILE="status.md"

# Crear archivos si no existen
if [ ! -f "$TASKS_FILE" ]; then
  echo -e "# Tareas del Proyecto\n" > "$TASKS_FILE"
fi
if [ ! -f "$STATUS_FILE" ]; then
  echo -e "# Estado del Proyecto\n\n## Tarea actual\n\n## Progreso\n\n## Bloqueos\n\n## Próximos pasos\n" > "$STATUS_FILE"
fi

function update_status() {
  # Tarea actual: primera pendiente
  current=$(grep "^- \[ \]" "$TASKS_FILE" | head -n1 | sed 's/^- \[ \] //')
  # Progreso: completadas
  progreso=$(grep "^- \[x\]" "$TASKS_FILE" | sed 's/^- \[x\] /- /')
  # Bloqueos: solo líneas que no sean tareas ni próximos pasos
  bloqueos=$(grep "^\- " "$STATUS_FILE" | grep -v completada | grep -v '^#' | grep -v '^##' | grep -v 'WORKSHOP-' | grep -v 'Sin próximos pasos' | sort | uniq)
  # Próximos pasos: tareas pendientes (excepto la actual)
  pendientes=$(grep "^- \[ \]" "$TASKS_FILE" | sed 's/^- \[ \] /- /')
  proximo=$(echo "$pendientes" | tail -n +2 | sort | uniq)

  echo -e "# Estado del Proyecto\n" > "$STATUS_FILE"
  echo -e "## Tarea actual\n" >> "$STATUS_FILE"
  if [ -n "$current" ]; then
    echo "$current" >> "$STATUS_FILE"
  else
    echo "Sin tareas pendientes" >> "$STATUS_FILE"
  fi
  echo -e "\n## Progreso" >> "$STATUS_FILE"
  if [ -n "$progreso" ]; then
    echo "$progreso" >> "$STATUS_FILE"
  else
    echo "- Sin tareas completadas" >> "$STATUS_FILE"
  fi
  echo -e "\n## Bloqueos" >> "$STATUS_FILE"
  if [ -n "$bloqueos" ]; then
    echo "$bloqueos" >> "$STATUS_FILE"
  else
    echo "- Sin bloqueos registrados" >> "$STATUS_FILE"
  fi
  echo -e "\n## Próximos pasos" >> "$STATUS_FILE"
  if [ -n "$proximo" ]; then
    echo "$proximo" >> "$STATUS_FILE"
  else
    echo "- Sin próximos pasos" >> "$STATUS_FILE"
  fi
}

function show_menu() {
  echo "Gestor de Tareas Cursor"
  echo "1. Ver tareas"
  echo "2. Agregar tarea"
  echo "3. Completar tarea"
  echo "4. Registrar bloqueo"
  echo "5. Ver estado"
  echo "6. Salir"
}

function ver_tareas() {
  grep "\- \[.\]" "$TASKS_FILE"
}

function agregar_tarea() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    echo "- [ ] $1: $2" >> "$TASKS_FILE"
    echo "Tarea agregada: $1: $2"
    update_status
    exit 0
  else
    read -p "ID de la tarea (ej: USER-004): " id
    read -p "Descripción: " desc
    echo "- [ ] $id: $desc" >> "$TASKS_FILE"
    echo "Tarea agregada."
    update_status
  fi
}

function completar_tarea() {
  if [ -n "$1" ]; then
    sed -i '' "s/- \[ \] $1/- [x] $1/" "$TASKS_FILE"
    echo "- $1 completada" >> "$STATUS_FILE"
    echo "Tarea marcada como completada: $1"
    update_status
    exit 0
  else
    ver_tareas
    read -p "ID de la tarea a completar: " id
    sed -i '' "s/- \[ \] $id/- [x] $id/" "$TASKS_FILE"
    echo "- $id completada" >> "$STATUS_FILE"
    echo "Tarea marcada como completada."
    update_status
  fi
}

function registrar_bloqueo() {
  if [ -n "$1" ]; then
    echo "- $1" >> "$STATUS_FILE"
    echo "Bloqueo registrado: $1"
    update_status
    exit 0
  else
    read -p "Describe el bloqueo: " bloqueo
    echo "- $bloqueo" >> "$STATUS_FILE"
    echo "Bloqueo registrado."
    update_status
  fi
}

function ver_estado() {
  echo "=== $STATUS_FILE ==="
  cat "$STATUS_FILE"
}

# Modo no interactivo
case "$1" in
  add)
    shift
    agregar_tarea "$1" "$2"
    update_status
    exit 0
    ;;
  complete)
    shift
    completar_tarea "$1"
    update_status
    exit 0
    ;;
  block)
    shift
    registrar_bloqueo "$1"
    update_status
    exit 0
    ;;
  "")
    ;;
  *)
    echo "Uso: $0 [add <ID> <Descripción> | complete <ID> | block <Texto>]"
    exit 1
    ;;
esac

# Modo interactivo
while true; do
  show_menu
  read -p "Selecciona una opción: " opt
  case $opt in
    1) ver_tareas ;;
    2) agregar_tarea ;;
    3) completar_tarea ;;
    4) registrar_bloqueo ;;
    5) ver_estado ;;
    6) exit 0 ;;
    *) echo "Opción inválida" ;;
  esac
  echo ""
done 