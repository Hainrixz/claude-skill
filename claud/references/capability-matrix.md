# Capability Matrix — single source of truth

Authoritative dataset for the `claud` router. The per-surface `how` lives **only** here
(never duplicate it elsewhere). Every claim is traceable to `sources.md`.

**Schema** (one YAML block per capability):
- `id` — stable key. `capability` — {es,en} canonical name. `keywords` — ES+EN+typos for matching.
- `category` — theme. `surfaces` — map of `chat | code | code-web | cowork | chrome`, each with
  `supported: yes|no|partial`, `how` (terse, copy verbatim into answers), optional `notes`.
- `exclusive_to` — surfaces, or null. `plan_gate` — see `availability.md`, or null.
- `related` — other ids. `confidence` — `stable|recent|volatile`. `last_reviewed` — date.

Surfaces: **chat** = claude.ai (web/desktop/mobile) · **code** = Claude Code CLI/IDE ·
**code-web** = Claude Code on the web (cloud) · **cowork** = Claude Cowork (Desktop) ·
**chrome** = Claude in Chrome. Verdicts as of `last_reviewed`.

---

## Files & code

```yaml
- id: edit-local-files
  capability: { es: "Editar archivos locales", en: "Edit local files" }
  keywords: [editar archivos, modificar codigo, cambiar mi archivo, editar mi proyecto, escribir a disco, edit files, modify code, change my file, edit my repo, write to disk, edit local]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null, notes: "lee uploads y genera contenido descargable, pero no escribe en tu disco" }
    code:     { supported: yes,     how: "ejecuta `claude` en la carpeta del proyecto (o usa la extension de IDE) y pide el cambio; edita con Edit/Write" }
    code-web: { supported: yes,     how: "conecta el repo en claude.ai/code; edita en un sandbox en la nube y abre un PR" }
    cowork:   { supported: partial, how: "lee/escribe archivos locales dentro de su workspace de escritorio", notes: "no es un editor de codigo de proposito general" }
    chrome:   { supported: no,      how: null, notes: "opera en el navegador, no en el filesystem" }
  exclusive_to: null
  plan_gate: null
  related: [run-terminal-commands, open-pr-cloud-coding, claude-md-memory, plan-mode]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: read-analyze-files
  capability: { es: "Leer/analizar archivos que subes (PDF, imagenes, CSV)", en: "Read/analyze uploaded files (PDF, images, CSV)" }
  keywords: [analizar pdf, leer documento, subir archivo, analizar csv, resumir documento, vision, analyze pdf, read document, upload file, analyze csv, summarize document]
  category: files-and-code
  surfaces:
    chat:     { supported: yes,     how: "adjunta el archivo en el chat; hasta 500MB y 20 archivos por chat; PDFs <100pp se analizan con texto+visual" }
    code:     { supported: yes,     how: "Claude lee archivos del repo/carpeta directamente con Read" }
    code-web: { supported: yes,     how: "lee archivos del repo conectado en el sandbox" }
    cowork:   { supported: yes,     how: "lee archivos locales de tu maquina" }
    chrome:   { supported: partial, how: "lee el contenido de la pagina y toma screenshots", notes: "no es upload de archivos arbitrarios" }
  exclusive_to: null
  plan_gate: null
  related: [vision, create-documents]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: run-terminal-commands
  capability: { es: "Ejecutar comandos de terminal/shell", en: "Run terminal/shell commands" }
  keywords: [terminal, comandos, shell, bash, correr comando, ejecutar script, npm, git, run command, execute, run tests]
  category: files-and-code
  surfaces:
    chat:     { supported: partial, how: "solo ejecucion de Python/bash en un sandbox aislado (code execution), no tu terminal real" }
    code:     { supported: yes,     how: "ejecuta cualquier comando con la tool Bash en tu maquina (con permisos)" }
    code-web: { supported: yes,     how: "ejecuta comandos en el sandbox de la nube" }
    cowork:   { supported: partial, how: "ejecuta acciones dentro de su entorno de escritorio para completar la tarea" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [edit-local-files, code-execution, plan-mode]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: open-pr-cloud-coding
  capability: { es: "Abrir un Pull Request / trabajar sobre un repo en la nube", en: "Open a PR / cloud coding workflow" }
  keywords: [pull request, abrir pr, branch, repositorio, codear en la nube, github, open pr, cloud coding, work on a repo, raise a pr]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "con git en tu repo local (el comando `/commit` y `/pr` vienen del plugin commit-commands, no son built-in)" }
    code-web: { supported: yes,     how: "superficie nativa: conecta el repo en claude.ai/code; clona → edita en sandbox → abre PR; branch prefix `claude/` por defecto" }
    cowork:   { supported: no,      how: null }
    chrome:   { supported: no,      how: null }
  exclusive_to: [code, code-web]
  plan_gate: "Claude Code on the web: research preview en planes de pago (Pro/Max/Team/Enterprise premium)"
  related: [edit-local-files, schedule-recurring-task]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: plan-mode
  capability: { es: "Plan mode (planear en solo-lectura antes de ejecutar)", en: "Plan mode (read-only planning before acting)" }
  keywords: [plan mode, modo plan, planear antes, solo lectura, planning mode, propose before editing]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "`/plan` o Shift+Tab para ciclar a plan mode; Claude propone y espera aprobacion" }
    code-web: { supported: yes,     how: "disponible en sesiones de Claude Code on the web" }
    cowork:   { supported: no,      how: null }
    chrome:   { supported: no,      how: null }
  exclusive_to: [code, code-web]
  plan_gate: null
  related: [subagents, run-terminal-commands]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: claude-md-memory
  capability: { es: "Memoria de proyecto (CLAUDE.md) y auto memory", en: "Project memory (CLAUDE.md) and auto memory" }
  keywords: [claude.md, memoria de proyecto, instrucciones del proyecto, recordar entre sesiones, auto memory, project memory, remember]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null, notes: "el chat tiene Memory cross-chat (ver memory-chat-search), que es distinto" }
    code:     { supported: yes,     how: "jerarquia CLAUDE.md (managed → user ~/.claude/CLAUDE.md → project ./CLAUDE.md → local) + auto memory (v2.1.59+); ver/editar con `/memory`" }
    code-web: { supported: partial, how: "usa la config de la sesion en la nube", notes: "el CLAUDE.md del repo aplica" }
    cowork:   { supported: partial, how: "los Projects de Cowork guardan instrucciones y memoria" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [memory-chat-search, custom-skills-commands]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: subagents
  capability: { es: "Subagentes / agentes en paralelo", en: "Subagents / parallel agents" }
  keywords: [subagentes, agentes en paralelo, lanzar agente, agent tool, subagents, parallel agents, spawn agent, background agent]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "la tool `Agent` lanza subagentes con contexto aislado; `/agents` los gestiona; `/background` corre una sesion en segundo plano" }
    code-web: { supported: yes,     how: "subagentes disponibles en las sesiones en la nube" }
    cowork:   { supported: partial, how: "ejecuta tareas multi-paso de forma autonoma", notes: "no expone subagentes nombrados como Code" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [plan-mode, hooks, schedule-recurring-task]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: hooks
  capability: { es: "Hooks (automatizar el harness: Pre/PostToolUse, etc.)", en: "Hooks (automate the harness: Pre/PostToolUse, etc.)" }
  keywords: [hooks, pretooluse, posttooluse, automatizar antes de, bloquear comando, lint automatico, hook, on tool use]
  category: files-and-code
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "define hooks en settings.json (PreToolUse, PostToolUse, SessionStart, UserPromptSubmit, Stop, etc.); `/hooks` para verlos" }
    code-web: { supported: no,      how: null, notes: "no en la web" }
    cowork:   { supported: no,      how: null }
    chrome:   { supported: no,      how: null }
  exclusive_to: [code]
  plan_gate: null
  related: [custom-skills-commands, subagents]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: custom-skills-commands
  capability: { es: "Skills y slash commands personalizados / plugins", en: "Custom skills, slash commands, plugins" }
  keywords: [crear skill, slash command, comando personalizado, plugin, marketplace, custom skill, custom command, agent skills]
  category: files-and-code
  surfaces:
    chat:     { supported: yes,     how: "sube un skill (.zip con SKILL.md, requiere code execution); ruta UI varia (Settings → Features o Customize → Skills)", notes: "no se sincroniza con otras superficies" }
    code:     { supported: yes,     how: "carpeta en ~/.claude/skills/<name>/SKILL.md; `/skills` lista; plugins via `/plugin`" }
    code-web: { supported: partial, how: "usa los skills del repo/config" }
    cowork:   { supported: partial, how: "usa skills/plugins habilitados (controlados por admin en Team/Enterprise)" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Subir skills a claude.ai: requiere code execution; ruta UI y elegibilidad Free no estan firmes en docs (volatile)"
  related: [claude-md-memory, connectors-mcp]
  confidence: volatile
  last_reviewed: 2026-06-14
```

## Automation & scheduling

```yaml
- id: schedule-recurring-task
  capability: { es: "Programar una tarea recurrente", en: "Schedule a recurring task" }
  keywords: [tarea recurrente, programar tarea, agendar, cron, automatizar, que corra solo, rutina, todos los dias, recurring task, schedule, cron, routine, run automatically, every day]
  category: automation-and-scheduling
  surfaces:
    chat:     { supported: no,      how: null, notes: "el chat es interactivo; no corre solo en un horario" }
    code:     { supported: yes,     how: "`/schedule` (alias `/routines`) crea una Routine en la nube de Anthropic; sigue corriendo con la laptop cerrada" }
    code-web: { supported: yes,     how: "Routines en claude.ai/code: presets (hourly/daily/weekdays/weekly) + cron crudo (via `/schedule update`, min 1h) + triggers por API o evento de GitHub" }
    cowork:   { supported: yes,     how: "pide una tarea recurrente; corre LOCAL y SOLO mientras tu computadora este despierta y Claude Desktop abierto" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Routines (Claude Code on the web) y Cowork requieren plan de pago"
  related: [autonomous-deliverables, one-time-scheduled-run, subagents]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: one-time-scheduled-run
  capability: { es: "Ejecucion programada de una sola vez / recordatorio", en: "One-time scheduled run / reminder" }
  keywords: [una sola vez, en dos semanas, recordatorio, ejecutar despues, one-off, in two weeks, scheduled once, later]
  category: automation-and-scheduling
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "`/schedule` admite ejecuciones one-off (p. ej. 'in 2 weeks, open a cleanup PR'); corren en la nube" }
    code-web: { supported: yes,     how: "Routines admite ejecuciones one-off ademas de recurrentes" }
    cowork:   { supported: partial, how: "tareas programadas locales (requiere Desktop abierto)" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "plan de pago"
  related: [schedule-recurring-task]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: autonomous-deliverables
  capability: { es: "Entregables autonomos (trabaja solo y deja el resultado)", en: "Autonomous deliverables (works unattended, leaves the result)" }
  keywords: [trabajo autonomo, hazlo mientras no estoy, entregable, reporte automatico, deja el archivo listo, autonomous, do it while away, deliverable, unattended]
  category: automation-and-scheduling
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: partial, how: "puede producir archivos, pero la CLI es interactiva; usa Routines/background para algo desatendido" }
    code-web: { supported: partial, how: "las Routines producen codigo/PRs de forma desatendida (enfoque en codigo)" }
    cowork:   { supported: yes,     how: "superficie nativa para trabajo de oficina: describe el resultado y Cowork lo produce (Excel con formulas, PowerPoint, documentos con formato)" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Cowork: planes de pago (Pro/Max/Team/Enterprise)"
  related: [schedule-recurring-task, create-documents, create-artifact]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: loop-interval
  capability: { es: "Repetir un prompt en un intervalo (loop)", en: "Repeat a prompt on an interval (loop)" }
  keywords: [loop, repetir, cada 5 minutos, monitorear, poll, repeat every, watch, monitor]
  category: automation-and-scheduling
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "`/loop [intervalo] [prompt]` (bundled skill) repite el prompt dentro de la sesion" }
    code-web: { supported: partial, how: "para algo persistente usa Routines" }
    cowork:   { supported: partial, how: "tareas programadas locales" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [schedule-recurring-task]
  confidence: recent
  last_reviewed: 2026-06-14
```

## Integrations / connectors

```yaml
- id: connectors-mcp
  capability: { es: "Connectors / MCP (conectar apps externas)", en: "Connectors / MCP (connect external apps)" }
  keywords: [connector, conectar app, integracion, mcp, gmail, slack, notion, jira, drive, integration, connect, mcp server]
  category: integrations
  surfaces:
    chat:     { supported: yes,     how: "Settings → Connectors (o claude.com/connectors); MCP remoto" }
    code:     { supported: yes,     how: "`/mcp` o `claude mcp add`; soporta MCP local (stdio) y remoto (HTTP)" }
    code-web: { supported: yes,     how: "incluye connectors en la config de la Routine/sesion" }
    cowork:   { supported: yes,     how: "connectors disponibles; en Team/Enterprise un admin debe habilitarlos" }
    chrome:   { supported: partial, how: "soporte limitado segun permisos de la extension" }
  exclusive_to: null
  plan_gate: "Connectors web: todos los usuarios en Claude/Cowork/Desktop/Mobile + API. Team/Enterprise: admin habilita primero"
  related: [send-email, manage-calendar, google-drive-docs, custom-mcp-server]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: send-email
  capability: { es: "Enviar correos", en: "Send email" }
  keywords: [enviar correo, mandar email, responder correo, send email, send mail, reply email, email on my behalf]
  category: integrations
  surfaces:
    chat:     { supported: no,      how: "el connector de Gmail BUSCA, LEE y crea BORRADORES; tu presionas Enviar" }
    code:     { supported: no,      how: "igual: solo borradores via connector" }
    code-web: { supported: no,      how: "solo borradores" }
    cowork:   { supported: no,      how: "solo borradores" }
    chrome:   { supported: partial, how: "podria operar la UI web de tu correo si tu sesion esta abierta", notes: "no es el connector de Gmail" }
  exclusive_to: null
  plan_gate: null
  related: [connectors-mcp, manage-calendar]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: manage-calendar
  capability: { es: "Gestionar eventos de calendario", en: "Manage calendar events" }
  keywords: [calendario, agendar reunion, crear evento, disponibilidad, calendar, schedule meeting, create event, availability]
  category: integrations
  surfaces:
    chat:     { supported: yes,     how: "connector de Google Calendar: leer, crear, actualizar y borrar eventos" }
    code:     { supported: yes,     how: "via connector/MCP de Calendar" }
    code-web: { supported: yes,     how: "via connector en la sesion" }
    cowork:   { supported: yes,     how: "via connector de Calendar" }
    chrome:   { supported: partial, how: "puede operar la UI web del calendario" }
  exclusive_to: null
  plan_gate: "Team/Enterprise: admin habilita el connector"
  related: [send-email, google-drive-docs, connectors-mcp]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: google-drive-docs
  capability: { es: "Leer/escribir Google Drive y Docs", en: "Read/write Google Drive and Docs" }
  keywords: [google drive, google docs, leer documento de drive, guardar en drive, drive, docs, sheets]
  category: integrations
  surfaces:
    chat:     { supported: yes,     how: "connector de Google Workspace: buscar/leer archivos, subir y guardar archivos generados por Claude" }
    code:     { supported: yes,     how: "via connector/MCP" }
    code-web: { supported: yes,     how: "via connector en la sesion" }
    cowork:   { supported: yes,     how: "via connector" }
    chrome:   { supported: partial, how: "puede operar la UI web de Drive/Docs" }
  exclusive_to: null
  plan_gate: "Team/Enterprise: admin habilita Google Workspace"
  related: [manage-calendar, send-email, create-documents]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: custom-mcp-server
  capability: { es: "Conectar un servidor MCP propio", en: "Connect your own MCP server" }
  keywords: [mcp propio, servidor mcp, custom mcp, build mcp, my own server, remote mcp]
  category: integrations
  surfaces:
    chat:     { supported: yes,     how: "agrega un custom connector (MCP remoto) en Settings → Connectors" }
    code:     { supported: yes,     how: "`claude mcp add` o .mcp.json del proyecto; soporta stdio local y HTTP remoto" }
    code-web: { supported: partial, how: "MCP remoto via connectors; sin servidores locales" }
    cowork:   { supported: yes,     how: "custom connectors (MCP remoto) en Cloud/Desktop" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [connectors-mcp]
  confidence: stable
  last_reviewed: 2026-06-14
```

## Research & web

```yaml
- id: web-search
  capability: { es: "Busqueda web en vivo", en: "Live web search" }
  keywords: [buscar en internet, busqueda web, buscar en la web, web search, search the web, look it up, current info]
  category: research-and-web
  surfaces:
    chat:     { supported: yes,     how: "activa web search con el icono/slider del input; disponible en TODOS los planes incl. Free" }
    code:     { supported: yes,     how: "tool WebSearch (y WebFetch para una URL)" }
    code-web: { supported: yes,     how: "busqueda web disponible en la sesion" }
    cowork:   { supported: yes,     how: "busqueda web disponible" }
    chrome:   { supported: yes,     how: "navega y lee paginas directamente" }
  exclusive_to: null
  plan_gate: "Team/Enterprise: un Owner debe habilitarlo en Admin → Capabilities"
  related: [deep-research, fetch-url, browser-automation]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: deep-research
  capability: { es: "Research (reporte multi-fuente con citas)", en: "Deep Research (multi-source cited report)" }
  keywords: [research, investigacion profunda, reporte con fuentes, investigar a fondo, deep research, research report, cited report]
  category: research-and-web
  surfaces:
    chat:     { supported: yes,     how: "activa Research en el chat; hace busquedas encadenadas y entrega un reporte con citas verificables (planes de pago)" }
    code:     { supported: no,      how: null, notes: "no es la feature Research; puedes investigar con WebSearch/WebFetch manualmente" }
    code-web: { supported: no,      how: null }
    cowork:   { supported: partial, how: "puede hacer tareas de investigacion, pero la feature Research vive en el Chat" }
    chrome:   { supported: no,      how: null }
  exclusive_to: [chat]
  plan_gate: "solo planes de pago (Pro/Max/Team/Enterprise); requiere web search habilitado. Duracion oficial: 'respuestas exhaustivas en minutos' (sin numero fijo)"
  related: [web-search, fetch-url]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: fetch-url
  capability: { es: "Leer/resumir una URL especifica", en: "Fetch/summarize a specific URL" }
  keywords: [leer un link, resumir una pagina, abrir url, fetch url, read this link, summarize this page]
  category: research-and-web
  surfaces:
    chat:     { supported: yes,     how: "pega la URL; con web search activo Claude la abre y resume" }
    code:     { supported: yes,     how: "tool WebFetch" }
    code-web: { supported: yes,     how: "disponible en la sesion" }
    cowork:   { supported: yes,     how: "disponible" }
    chrome:   { supported: yes,     how: "abre la URL en el navegador y extrae el contenido" }
  exclusive_to: null
  plan_gate: null
  related: [web-search, deep-research]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: browser-automation
  capability: { es: "Automatizar el navegador (click, llenar formularios, navegar)", en: "Browser automation (click, fill forms, navigate)" }
  keywords: [automatizar navegador, llenar formulario, hacer click, navegar paginas, automatizar web, browser automation, click buttons, fill forms, navigate, scrape]
  category: research-and-web
  surfaces:
    chat:     { supported: no,      how: null }
    code:     { supported: yes,     how: "Claude Code + Chrome via `--chrome` o `/chrome` (requiere extension v1.0.36+, Code v2.0.73+, plan directo de Anthropic; no Bedrock/Vertex/Foundry)" }
    code-web: { supported: no,      how: null }
    cowork:   { supported: partial, how: "se integra con el navegador para tareas web", notes: "verifica en docs el alcance actual" }
    chrome:   { supported: yes,     how: "la extension Claude in Chrome (beta) hace click, escribe, navega tabs, lee/extrae contenido y descarga archivos" }
  exclusive_to: null
  plan_gate: "Claude in Chrome: beta, solo planes de pago (Pro/Max/Team/Enterprise); Pro limitado a Haiku 4.5 (verificar versiones)"
  related: [web-search, fetch-url]
  confidence: recent
  last_reviewed: 2026-06-14
```

## Content creation & Artifacts

```yaml
- id: create-artifact
  capability: { es: "Crear un Artifact compartible (app/doc/diagrama en vivo)", en: "Create a shareable Artifact (live app/doc/diagram)" }
  keywords: [artifact, crear app, hacer una herramienta, vista previa interactiva, mini app, react app, make an app, interactive preview, shareable app, publish artifact]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: yes,     how: "pide la app/doc/diagrama; aparece en el panel de Artifacts; comparte con Publish/Share; las apps pueden llamar a la API de Claude" }
    code:     { supported: no,      how: null, notes: "Code escribe archivos reales en tu repo, no Artifacts del chat" }
    code-web: { supported: no,      how: null }
    cowork:   { supported: partial, how: "Cowork tiene Live Artifacts (HTML interactivo persistente con historial), distinto del panel de Artifacts del chat" }
    chrome:   { supported: no,      how: null }
  exclusive_to: [chat]
  plan_gate: "crear y descubrir: todos los planes. Storage persistente y apps que usan la API/MCP: Pro/Max/Team/Enterprise"
  related: [build-web-app, autonomous-deliverables, share-publish]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: build-web-app
  capability: { es: "Construir un frontend / app web interactiva", en: "Build a web frontend / interactive app" }
  keywords: [frontend, pagina web, app web, react, html, sitio, build a website, web app, landing page]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: yes,     how: "como Artifact interactivo (React/HTML) en el panel; compartible" }
    code:     { supported: yes,     how: "como proyecto real: crea archivos, instala deps y corre el dev server" }
    code-web: { supported: yes,     how: "en un repo en la nube, abre PR" }
    cowork:   { supported: partial, how: "Live Artifacts para paginas interactivas" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [create-artifact, edit-local-files]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: generate-images
  capability: { es: "Generar imagenes", en: "Generate images" }
  keywords: [generar imagen, crear imagen, dibujar, ilustracion, generate image, create image, make a picture, ai art]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: partial, how: "no es nativo: via un connector/MCP de generacion de imagenes, o como SVG/HTML. Verifica en docs", notes: "Claude no genera imagenes raster de forma nativa" }
    code:     { supported: partial, how: "via un MCP de imagenes si esta conectado, o generando SVG/codigo" }
    code-web: { supported: partial, how: "via connector/MCP" }
    cowork:   { supported: partial, how: "via connector/MCP" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "depende del connector/servicio usado"
  related: [generate-video, generate-audio, build-web-app]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: generate-video
  capability: { es: "Generar/editar video", en: "Generate / edit video" }
  keywords: [generar video, crear video, editar video, generate video, make a video]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: partial, how: "no es nativo: via un connector/MCP de video (p. ej. herramientas de terceros). Verifica en docs" }
    code:     { supported: partial, how: "via MCP de video si esta conectado" }
    code-web: { supported: partial, how: "via connector/MCP" }
    cowork:   { supported: partial, how: "via connector/MCP" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "depende del connector/servicio"
  related: [generate-images, generate-audio]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: generate-audio
  capability: { es: "Generar audio / texto a voz", en: "Generate audio / TTS" }
  keywords: [generar audio, texto a voz, tts, voz sintetica, generate audio, text to speech, voiceover]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: partial, how: "no es nativo: via un connector/MCP de audio/TTS. Verifica en docs", notes: "distinto de Voice mode (conversar)" }
    code:     { supported: partial, how: "via MCP de audio si esta conectado" }
    code-web: { supported: partial, how: "via connector/MCP" }
    cowork:   { supported: partial, how: "via connector/MCP" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "depende del connector/servicio"
  related: [generate-images, voice-mode]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: create-documents
  capability: { es: "Crear archivos (Excel, PowerPoint, Word, PDF)", en: "Create files (Excel, PowerPoint, Word, PDF)" }
  keywords: [crear excel, hacer powerpoint, generar word, crear pdf, hoja de calculo, presentacion, xlsx, pptx, docx, create excel, make powerpoint, generate word, create pdf, spreadsheet, slides]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: yes,     how: "activa 'code execution and file creation' (Settings → Capabilities); crea .xlsx/.pptx/.docx/.pdf descargables (hasta 30MB)" }
    code:     { supported: yes,     how: "escribe los archivos directamente en tu carpeta" }
    code-web: { supported: yes,     how: "genera archivos en el sandbox del repo" }
    cowork:   { supported: yes,     how: "Excel con formulas y PowerPoint via Claude for Excel/PowerPoint; 'documentos con formato' (Word/PDF no nombrados oficialmente)" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Chat: creacion de archivos disponible en todos los planes (Settings → Capabilities)"
  related: [pdf-tools, autonomous-deliverables, google-drive-docs]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: pdf-tools
  capability: { es: "Manipular PDFs (combinar, dividir, extraer, OCR)", en: "Manipulate PDFs (merge, split, extract, OCR)" }
  keywords: [combinar pdf, dividir pdf, extraer texto pdf, ocr, rellenar pdf, merge pdf, split pdf, extract pdf, fill pdf form]
  category: content-and-artifacts
  surfaces:
    chat:     { supported: yes,     how: "via code execution (Python) sobre el PDF que subes" }
    code:     { supported: yes,     how: "con scripts/herramientas sobre los archivos locales (incl. el skill `pdf` si esta instalado)" }
    code-web: { supported: yes,     how: "en el sandbox" }
    cowork:   { supported: partial, how: "manipula archivos locales en su entorno" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: null
  related: [create-documents, read-analyze-files]
  confidence: stable
  last_reviewed: 2026-06-14
```

## Reasoning & thinking

```yaml
- id: extended-thinking
  capability: { es: "Razonamiento extendido (pensar mas)", en: "Extended thinking (reason longer)" }
  keywords: [pensar mas, razonamiento extendido, think harder, ultrathink, modo de pensar, extended thinking, deep reasoning, think step by step]
  category: reasoning
  surfaces:
    chat:     { supported: yes,     how: "menu del modelo (junto a enviar) → Effort/Thinking toggle; se puede cambiar en cualquier momento" }
    code:     { supported: yes,     how: "pide 'think'/'think hard'/'ultrathink', o ajusta `/effort`; la profundidad escala con la dificultad" }
    code-web: { supported: yes,     how: "mismo comportamiento que Code" }
    cowork:   { supported: yes,     how: "razona extendido durante la tarea" }
    chrome:   { supported: yes,     how: "disponible al planear acciones complejas" }
  exclusive_to: null
  plan_gate: "el toggle no esta plan-gateado; los effort levels consumen tus limites de plan"
  related: [plan-mode, deep-research, long-context]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: long-context
  capability: { es: "Contexto largo / analizar documentos grandes", en: "Long context / analyze large documents" }
  keywords: [contexto largo, documento grande, muchos archivos, 1m de tokens, long context, large document, big codebase, many files]
  category: reasoning
  surfaces:
    chat:     { supported: yes,     how: "200K de contexto (500K en Enterprise en modelos selectos); resume automaticamente al acercarse al limite" }
    code:     { supported: yes,     how: "ventanas amplias (hasta 1M en modelos selectos); `/context` muestra el uso, `/compact` resume" }
    code-web: { supported: yes,     how: "como Code" }
    cowork:   { supported: yes,     how: "maneja contexto amplio durante la tarea" }
    chrome:   { supported: partial, how: "limitado por el modelo activo de la extension" }
  exclusive_to: null
  plan_gate: "500K solo Enterprise en modelos selectos; 1M en plataformas/modelos selectos"
  related: [read-analyze-files, extended-thinking]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: vision
  capability: { es: "Vision (analizar imagenes y screenshots)", en: "Vision (analyze images and screenshots)" }
  keywords: [analizar imagen, leer screenshot, describir foto, ver imagen, vision, analyze image, read screenshot, describe photo, chart]
  category: reasoning
  surfaces:
    chat:     { supported: yes,     how: "adjunta imagenes (hasta 8000x8000 px); compara/analiza graficas, fotos, capturas" }
    code:     { supported: yes,     how: "lee imagenes referenciadas (Read soporta PNG/JPG)" }
    code-web: { supported: yes,     how: "lee imagenes del repo" }
    cowork:   { supported: yes,     how: "analiza imagenes locales" }
    chrome:   { supported: yes,     how: "toma y analiza screenshots de la pagina" }
  exclusive_to: null
  plan_gate: null
  related: [read-analyze-files]
  confidence: stable
  last_reviewed: 2026-06-14
```

## Collaboration & sharing

```yaml
- id: projects
  capability: { es: "Projects (workspace con conocimiento persistente)", en: "Projects (workspace with persistent knowledge)" }
  keywords: [proyecto, project, base de conocimiento, instrucciones del proyecto, project knowledge, custom instructions, workspace]
  category: collaboration
  surfaces:
    chat:     { supported: yes,     how: "crea un Project: sube documentos como conocimiento + instrucciones por proyecto. Free: max 5 projects" }
    code:     { supported: no,      how: null, notes: "Code usa CLAUDE.md/rules en su lugar" }
    code-web: { supported: no,      how: null }
    cowork:   { supported: yes,     how: "Projects de Cowork: agrupan tareas con archivos, links, instrucciones y memoria" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Projects: todos incl. Free (cap 5). Enhanced project knowledge (RAG ~10x): planes de pago"
  related: [claude-md-memory, share-publish, autonomous-deliverables]
  confidence: stable
  last_reviewed: 2026-06-14
```
```yaml
- id: share-publish
  capability: { es: "Compartir / publicar una conversacion o Artifact", en: "Share / publish a conversation or Artifact" }
  keywords: [compartir chat, publicar, enviar link, compartir artifact, share chat, publish, share link, public artifact]
  category: collaboration
  surfaces:
    chat:     { supported: yes,     how: "boton Share genera un link; Artifacts se publican (Free/Pro/Max) o se comparten en la org (Team/Enterprise)" }
    code:     { supported: partial, how: "puede compartir sesiones (research preview) o exportar transcripts en la web" }
    code-web: { supported: partial, how: "compartir/exportar sesiones (research preview)" }
    cowork:   { supported: partial, how: "comparte entregables/archivos producidos" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "Team/Enterprise: compartir es dentro de la organizacion"
  related: [create-artifact, team-workspaces]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: team-workspaces
  capability: { es: "Equipos / workspaces compartidos y admin", en: "Teams / shared workspaces and admin" }
  keywords: [equipo, organizacion, compartir con el equipo, sso, admin, audit logs, team, organization, shared workspace, enterprise admin]
  category: collaboration
  surfaces:
    chat:     { supported: yes,     how: "planes Team/Enterprise: Projects compartidos, SSO/SCIM, controles de gasto, audit logs, instrucciones de organizacion" }
    code:     { supported: partial, how: "managed settings/policy a nivel organizacion (CLAUDE.md managed, permisos)" }
    code-web: { supported: partial, how: "config de organizacion" }
    cowork:   { supported: partial, how: "plugins/connectors controlados por admin" }
    chrome:   { supported: partial, how: "habilitacion por admin en org" }
  exclusive_to: null
  plan_gate: "Team y Enterprise (Compliance API y 500K contexto: Enterprise)"
  related: [projects, privacy-admin, plan-tiers]
  confidence: stable
  last_reviewed: 2026-06-14
```

## Voice & mobile

```yaml
- id: voice-mode
  capability: { es: "Modo de voz (hablar con Claude)", en: "Voice mode (talk to Claude)" }
  keywords: [modo voz, hablar con claude, conversacion por voz, manos libres, voice mode, talk to claude, speak, hands-free]
  category: voice-and-mobile
  surfaces:
    chat:     { supported: yes,     how: "SOLO en las apps moviles (iOS/Android): toca el icono de voz. Todos los planes (beta)" }
    code:     { supported: no,      how: null }
    code-web: { supported: no,      how: null }
    cowork:   { supported: no,      how: null }
    chrome:   { supported: no,      how: null }
  exclusive_to: [chat]
  plan_gate: "todos los planes; las conversaciones de voz cuentan a tus limites; Enterprise admins pueden desactivarlo"
  related: [mobile-app, generate-audio]
  confidence: recent
  last_reviewed: 2026-06-14
```
```yaml
- id: mobile-app
  capability: { es: "Capacidades de la app movil (iOS/Android)", en: "Mobile app capabilities (iOS/Android)" }
  keywords: [app movil, celular, telefono, iphone, android, mobile app, phone, on my phone]
  category: voice-and-mobile
  surfaces:
    chat:     { supported: yes,     how: "apps iOS/Android: chat completo, voz, camara, busqueda; tambien monitorear sesiones de Claude Code (lectura/aprobar acciones)" }
    code:     { supported: partial, how: "no corre Code localmente en el movil; pero puedes monitorear/aprobar sesiones via Remote Control" }
    code-web: { supported: partial, how: "monitorea sesiones de Claude Code on the web desde el movil" }
    cowork:   { supported: partial, how: "el movil es companion de mensajeria (beta); el trabajo corre en el Desktop" }
    chrome:   { supported: no,      how: null }
  exclusive_to: null
  plan_gate: "todos los planes (apps moviles)"
  related: [voice-mode, vision]
  confidence: recent
  last_reviewed: 2026-06-14
```

## Admin & plans

```yaml
- id: plan-tiers
  capability: { es: "Que da cada plan (Free/Pro/Max/Team/Enterprise)", en: "What each plan unlocks (Free/Pro/Max/Team/Enterprise)" }
  keywords: [planes, precios, que incluye pro, free vs pro, max, team, enterprise, plans, pricing, what do i get]
  category: admin-and-plans
  surfaces:
    chat:     { supported: yes,     how: "ver availability.md para el desglose; verificar en claude.com/pricing (datos volatiles)" }
    code:     { supported: yes,     how: "mismo desglose; ver availability.md" }
    code-web: { supported: yes,     how: "ver availability.md" }
    cowork:   { supported: yes,     how: "ver availability.md" }
    chrome:   { supported: yes,     how: "ver availability.md" }
  exclusive_to: null
  plan_gate: "datos de planes son volatiles: verificar en docs al responder"
  related: [usage-limits, privacy-admin, team-workspaces]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: usage-limits
  capability: { es: "Limites de uso y ventana de contexto", en: "Usage limits and context window" }
  keywords: [limites, cuanto puedo usar, contexto, tokens, cuota, usage limits, context window, quota, rate limit]
  category: admin-and-plans
  surfaces:
    chat:     { supported: yes,     how: "limites por sesion/semana segun plan; contexto 200K (500K Enterprise selecto). Ver availability.md / docs" }
    code:     { supported: yes,     how: "`/usage` (alias `/cost`) muestra consumo; `/context` muestra la ventana" }
    code-web: { supported: yes,     how: "uso consume tu suscripcion; ver claude.ai/settings/usage" }
    cowork:   { supported: yes,     how: "consume limites del plan" }
    chrome:   { supported: yes,     how: "consume limites del plan; modelo segun plan" }
  exclusive_to: null
  plan_gate: "volatil: verificar numeros en docs"
  related: [plan-tiers, long-context]
  confidence: volatile
  last_reviewed: 2026-06-14
```
```yaml
- id: privacy-admin
  capability: { es: "Privacidad, control de datos y admin de organizacion", en: "Privacy, data controls, org admin" }
  keywords: [privacidad, datos, entrenan con mis datos, incognito, retencion, audit, privacy, data controls, incognito, retention, compliance]
  category: admin-and-plans
  surfaces:
    chat:     { supported: yes,     how: "chats incognito (no memorizados/buscables); controles de datos en Settings; Enterprise: Compliance API y retencion personalizada" }
    code:     { supported: partial, how: "managed settings/policy; permisos allow/deny; sin sandbox de SO (control por permisos)" }
    code-web: { supported: partial, how: "config de red por niveles (None/Trusted/Full/Custom)" }
    cowork:   { supported: partial, how: "controles de admin (Team/Enterprise)" }
    chrome:   { supported: partial, how: "permisos por accion; mitigacion de prompt injection" }
  exclusive_to: null
  plan_gate: "Compliance API y retencion avanzada: Enterprise"
  related: [team-workspaces, plan-tiers]
  confidence: recent
  last_reviewed: 2026-06-14
```
