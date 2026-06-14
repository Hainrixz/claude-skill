<p align="center">
  <img src="assets/logo.png" alt="claud — Claude pixel mascot" width="200">
</p>

# claud — Claude Capability Router 🧭

> **ES:** Un skill que sabe **qué puede hacer Claude y dónde**. Pregúntale `/claud ¿puedo hacer X?`
> y te dice si se puede, **en qué superficie** (Chat, Claude Code, Claude Code on the web, Cowork,
> Claude in Chrome) y **cómo exactamente**.
>
> **EN:** A skill that knows **what Claude can do and where**. Ask `/claud can I do X?` and it tells
> you whether it's possible, **on which surface** (Chat, Claude Code, Claude Code on the web, Cowork,
> Claude in Chrome) and **exactly how**.

Cada superficie de Claude trabaja distinto pero **no sabe de forma nativa lo que pueden hacer las
otras**. `claud` es ese conocimiento compartido: un enrutador de capacidades, bilingüe (ES/EN) y
**anclado a una base de conocimiento verificada** (no inventa). · *Each Claude surface works
differently but doesn't natively know what the others can do; `claud` is that shared, grounded,
bilingual knowledge.*

<p align="center">
  <img src="assets/generated/mascot-1.png" width="110">
  <img src="assets/generated/mascot-2.png" width="110">
  <img src="assets/generated/mascot-3.png" width="110">
  <img src="assets/generated/mascot-4.png" width="110">
</p>
<p align="center"><sub>Mascota en pixel art — generada con Higgsfield · <code>gpt_image_2</code>. / Pixel-art mascot.</sub></p>

---

## ¿Por qué "claud" sin la e? / Why "claud" without the e?

claude.ai prohíbe las palabras **"claude"** y **"anthropic"** en el `name` de un skill, así que un
skill llamado `claude` es rechazado al subirlo. **`claud`** (sin la "e" final) no contiene la
subcadena "claude", así que pasa la validación y se sigue leyendo como "Claude". · *claude.ai forbids
"claude"/"anthropic" in a skill's `name`; dropping the final "e" — `claud` — clears validation while
still reading like "Claude".*

---

## Instalación / Installation

> Requiere plan de pago (Pro/Max/Team/Enterprise) para subirlo a claude.ai/Cowork, con **code
> execution** activado. Claude Code funciona en cualquier plan con la CLI. Los skills **no se
> sincronizan** entre superficies: instálalo en cada una donde lo quieras.

### 1) Claude Code (CLI / IDE)
**Un comando / one command** — descarga e instala en `~/.claude/skills/claud`:
```bash
curl -fsSL https://raw.githubusercontent.com/Hainrixz/claude-skill/main/install.sh | bash
```
Usa el script [`install.sh`](install.sh) (`./install.sh --uninstall` para quitarlo;
`CLAUD_LINK=1 ./install.sh` para symlink desde un clon local).

O manual / or manually:
```bash
git clone https://github.com/Hainrixz/claude-skill.git
cp -R claude-skill/claud ~/.claude/skills/claud      # o: ln -s "$PWD/claude-skill/claud" ~/.claude/skills/claud
```
Listo: úsalo con `/claud` o pregunta una capacidad y se auto-activa. / Use `/claud` or just ask a
capability question.

### 2) claude.ai (Chat)
1. Descarga **[`dist/claud.zip`](dist/claud.zip)**.
2. Activa **code execution**: Settings → Capabilities → *Code execution / Create and edit files*.
3. Súbelo: **Customize → Skills** → `+` → *Upload a skill* → elige `claud.zip`.
   *(Si no ves "Customize → Skills", usa Settings → Features.)*
4. Se auto-activa por su descripción — no necesitas escribir nada especial. / It auto-triggers by
   its description.

### 3) Claude Cowork (Claude Desktop)
La misma subida a tu cuenta de claude.ai **también lo habilita en Cowork**. Verifica en
**Customize → Skills** dentro de la app de escritorio. En Team/Enterprise, un Owner debe activar
*code execution* y el toggle de *Skills* en Organization settings. · *The same claude.ai upload
enables it in Cowork too.*

---

## Cómo funciona / How it works

Ante una pregunta de capacidad, responde en 3 partes — **¿se puede? → ¿en qué superficie? → ¿cómo?**:

```
Programar una tarea recurrente — PARCIAL (depende de la superficie)
✅ Claude Code on the web → Routines (corre en la nube aunque cierres la laptop)
✅ Claude Cowork → tarea recurrente local (solo mientras Claude Desktop esté abierto)
❌ Chat y Chrome → no ejecutan nada por sí solos en un horario
👉 Recomendado: código sobre un repo → Routines; trabajo de oficina → Cowork
```

Reglas de diseño clave (anti-alucinación): toda afirmación se **ancla** a `claud/references/
capability-matrix.md`; por defecto algo es *no verificado* hasta encontrarlo; nunca inventa comandos;
los datos volátiles se marcan y se pueden verificar contra docs oficiales. Si las referencias no
cargan (p. ej. en claude.ai), una tabla inline en `SKILL.md` sostiene la respuesta.

---

## Estructura del repo / Repo layout

```
claude-skill/
├── claud/                       # el skill (esto es lo que se instala/empaqueta)
│   ├── SKILL.md                  # router: algoritmo, reglas de grounding, tabla inline, plantilla
│   ├── references/
│   │   ├── capability-matrix.md  # fuente única de verdad: ~40 capacidades × 5 superficies
│   │   ├── surfaces.md           # definición/desambiguación de superficies
│   │   ├── availability.md       # planes/gating + exclusivas
│   │   └── sources.md            # URLs oficiales + fechas de verificación
│   ├── evals/evals.json          # tests por modo de falla (no se empaqueta en el .zip)
│   └── LICENSE.txt
├── dist/claud.zip               # artefacto listo para subir a claude.ai / Cowork
├── LICENSE
└── README.md
```

## Mantenimiento / Maintenance
Los datos de capacidades cambian seguido. Todo es trazable en `claud/references/sources.md` con
fecha de "last verified". Para regenerar el `.zip` tras editar el skill:
```bash
# con skill-creator instalado:
python3 -m scripts.package_skill /ruta/a/claude-skill/claud /ruta/a/claude-skill/dist
```
Las pruebas de regresión viven en `claud/evals/evals.json` (grounding, cross-surface, modo degradado).

## Licencia / License
Apache-2.0 — ver [`LICENSE`](LICENSE).
