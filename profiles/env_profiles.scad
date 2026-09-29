// ============================================================================
// CC-O4 / NEXUS SHELL — Selector Maestro de Entorno Operativo
// Archivo: profiles/env_profiles.scad
// Uso: Cambiar ENV_MODE o compilar por CLI con: openscad -D 'ENV_MODE="MONTE"'
// ============================================================================

ENV_MODE = "MOSTOLES"; // Opciones: "MOSTOLES" (Fase 0) | "ORBITA" (Cryo) | "MONTE" (Ignis)

// --- 1. Identificación y Gravedad Local ---
g_accel = (ENV_MODE == "ORBITA")   ? 3.72 : 9.81; // m/s² (Marte 0.38g vs Tierra 1g)

// --- 2. Materiales Estructurales Asignados ---
mat_flange = (ENV_MODE == "MOSTOLES") ? "Aluminio 6082-T6 / PETG-CF" :
             (ENV_MODE == "ORBITA")   ? "Titanio Ti-6Al-4V (Grado 5)" :
                                        "Acero Inox 316L / Inconel 718";

mat_limbs  = (ENV_MODE == "MOSTOLES") ? "FDM PETG-CF (4 perim, 50% gyroid)" :
             (ENV_MODE == "ORBITA")   ? "Tubo CFRP (Matriz Cianato/PEEK)" :
                                        "Acero 310S + Camisa Cerámica/Ablativa";

mat_seal   = (ENV_MODE == "MOSTOLES") ? "TPU 95A / Fuelle textil" :
             (ENV_MODE == "ORBITA")   ? "Sello laberíntico + PTFE/MoS2 seco" :
                                        "Trenza de fibra cerámica + Grafito";

// --- 3. Tolerancias de Encaje y Dilatación Térmica (mm) ---
// - MOSTOLES: 0.25 mm para compensar contracción y elephant foot en FDM
// - ORBITA:   0.04 mm para mecanizado CNC de precisión en frío extremo
// - MONTE:    0.18 mm de holgura libre para evitar gripado por dilatación a +800 °C
tol_fit    = (ENV_MODE == "MOSTOLES") ? 0.25 :
             (ENV_MODE == "ORBITA")   ? 0.04 :
                                        0.18;

// --- 4. Factor de Escala de Pared y Escudo Térmico Exterior (mm) ---
wall_factor = (ENV_MODE == "MOSTOLES") ? 1.00 :
              (ENV_MODE == "ORBITA")   ? 0.85 : // Aligerado por alta resistencia específica
                                         1.25;  // Sobreespesor contra fluencia térmica

// Espesor de recubrimiento externo (0 en taller, MLI en órbita, ablativo en incendio)
shield_th   = (ENV_MODE == "MOSTOLES") ? 0.0 :
              (ENV_MODE == "ORBITA")   ? 2.0 :  // Manta multicapa MLI (Kapton aluminizado)
                                         6.5;   // Escudo ablativo fenólico + aerogel de sílice

// --- 5. Colores de Renderizado por Perfil ---
color_primary = (ENV_MODE == "MOSTOLES") ? "DimGray" :
                (ENV_MODE == "ORBITA")   ? "Silver" :
                                           "DarkSlateGray";

color_shield  = (ENV_MODE == "MOSTOLES") ? "SteelBlue" :
                (ENV_MODE == "ORBITA")   ? "Gold" :       // Kapton espacial
                                           "FireBrick";   // Recubrimiento intumescente/ablativo

// --- Módulo Envolvente Automático para Eslabones de Pata ---
module apply_thermal_shield() {
    if (shield_th > 0) {
        color(color_shield, 0.65)
            render()
            difference() {
                minkowski() {
                    children();
                    sphere(r = shield_th, $fn = 24);
                }
                children();
            }
    }
    color(color_primary) children();
}

// --- Salida de Auditoría en Consola OpenSCAD ---
echo(str("=== [CC-O4 NEXUS] PERFIL ACTIVO: ", ENV_MODE, " ==="));
echo(str("Material Brida/Chasis : ", mat_flange));
echo(str("Material Patas        : ", mat_limbs));
echo(str("Holgura de encaje     : ", tol_fit, " mm"));
echo(str("Escudo exterior       : ", shield_th, " mm"));
