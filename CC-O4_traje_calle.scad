// =====================================================================
// CC-O4 NEXUS SHELL — TRAJE DE CALLE (REV 0.1)
// Un solo archivo. Unidades: milímetros.
//
// Qué es este traje
//   Capa de lluvia de perfil bajo, no paraguas.
//   Apoyo solo donde hay camino de carga y ciclo: talón, rodilla, codo, nudillo.
//   El roce difuso del torso no cosecha.
//   Zinc-aire en el cinturón, circuito abierto al ambiente, cerrado al aire de respirar.
//   Modo calle: no sellado. El modo galería no vive en este archivo.
//
// Piezas
//   01 capa y capucha con visera
//   02 guantes de nudillo (verano = bisagra textil; invierno = mismo guante + tendón)
//   03 suela de carrera corta
//   04 cinturón, módulo zinc-aire REV 0.3, bahía seca
//   05 bisagras de codo y rodilla
// =====================================================================

$fn = 24;

altura_usuario = 1760;
escala = altura_usuario / 1760;

// --- materiales (solo color de vista) ---
col_capa   = [0.16, 0.20, 0.22];
col_base   = [0.10, 0.11, 0.13];
col_guante = [0.22, 0.24, 0.26];
col_suela  = [0.12, 0.12, 0.12];
col_zinc   = [0.75, 0.77, 0.80];
col_seco   = [0.15, 0.28, 0.42];
col_cint   = [0.28, 0.20, 0.12];
col_bis    = [0.45, 0.38, 0.16];

module elipse(rx, ry, h) {
    scale([rx, ry, 1]) cylinder(r = 1, h = h, center = true);
}

// ---------------------------------------------------------------------
// 01  CAPA
//     Caída por delante de la rodilla. Bajo libre. Visera corta.
//     Abertura trasera de capucha para que la ráfaga no infle.
// ---------------------------------------------------------------------
module capa() {
    color(col_capa) {
        difference() {
            union() {
                // cuerpo de capa, más larga delante
                hull() {
                    translate([0, 0, 1280]) elipse(210, 150, 20);
                    translate([10, 40, 760]) elipse(250, 180, 16);
                    translate([-20, -30, 760]) elipse(230, 170, 16);
                }
                // hombrera que escurre
                translate([0, 0, 1360]) elipse(240, 160, 30);
                // capucha
                translate([-20, 0, 1520]) sphere(r = 130);
                // visera rígida corta
                translate([95, 0, 1505]) rotate([0, 70, 0]) cube([70, 150, 6], center = true);
            }
            // hueco interior
            translate([0, 0, 1100]) cube([340, 260, 900], center = true);
            // boca de cara
            translate([90, 0, 1520]) cube([80, 110, 90], center = true);
            // abertura trasera de presión
            translate([-140, 0, 1540]) cube([40, 36, 28], center = true);
            // bajo abierto: no es un saco
            translate([0, 0, 700]) cube([520, 400, 80], center = true);
        }
        // dobladillo con lastre (el viento levanta y sale, no hace campana)
        translate([20, 50, 790]) color([0.30, 0.32, 0.28]) elipse(240, 12, 8);
    }
}

module base_torso() {
    color(col_base) {
        translate([0, 0, 1180]) elipse(160, 110, 340);
        translate([0, 0, 1000]) elipse(150, 105, 80);
    }
}

// ---------------------------------------------------------------------
// 05  EXTREMIDAD CON BISAGRA
//     La bisagra es el generador. La manga lisa no.
// ---------------------------------------------------------------------
module segmento(l, r) {
    cylinder(r = r, h = l);
    translate([0, 0, l]) sphere(r = r);
}

module bisagra() {
    color(col_bis) rotate([90, 0, 0]) cylinder(r = 14, h = 28, center = true);
}

module brazo() {
    color(col_base) segmento(240, 38);
    translate([0, 0, 250]) bisagra();
    translate([0, 0, 260]) color(col_base) segmento(220, 32);
}

module pierna() {
    color(col_base) segmento(380, 55);
    translate([0, 0, 390]) bisagra();
    translate([0, 0, 400]) color(col_base) segmento(360, 42);
}

// ---------------------------------------------------------------------
// 02  GUANTE
//     Verano: bisagra de nudillo, dorso activo, palma libre de sudor.
//     Invierno: la misma bisagra más tendón dorsal. Mismo archivo.
// ---------------------------------------------------------------------
module dedo(l, r) {
    color(col_guante) {
        cylinder(r = r, h = l * 0.45);
        translate([0, 0, l * 0.45]) color(col_bis) sphere(r = r + 1.5); // nudillo activo
        translate([0, 0, l * 0.50]) cylinder(r = r * 0.85, h = l * 0.5);
    }
}

module guante(invierno = false) {
    color(col_guante) {
        translate([0, 0, 0]) scale([1, 0.7, 0.55]) sphere(r = 42);
        if (invierno)
            translate([-8, 0, 6]) cube([36, 8, 6], center = true); // tendón dorsal
    }
    for (a = [-30, -10, 10, 30])
        rotate([0, 0, a]) translate([0, 28, 8]) rotate([70, 0, 0]) dedo(52, 7);
    rotate([0, 20, 40]) translate([0, 18, -6]) dedo(40, 8); // pulgar
}

// ---------------------------------------------------------------------
// 03  SUELA DE CARRERA CORTA
//     4 mm de carrera útil. Tope rígido al fondo. Energía por paso ~ F·δ.
// ---------------------------------------------------------------------
module bota() {
    color(col_suela) {
        hull() {
            translate([-20, 0, 16]) cube([150, 90, 16], center = true);
            translate([70, 0, 20]) cube([80, 70, 12], center = true);
        }
        // tope de carrera
        translate([-55, 0, 6]) cube([40, 50, 6], center = true);
        // celda de talón, cámara de 4 mm
        color([0.35, 0.32, 0.20]) translate([-55, 0, 14]) cube([36, 44, 4], center = true);
    }
}

// ---------------------------------------------------------------------
// 04  CINTURÓN Y MÓDULO ZINC-AIRE
//     Bahía húmeda delante-lateral. Bahía seca al otro lado de la pared.
//     El cinturón no atraviesa el vaso.
// ---------------------------------------------------------------------
module modulo_zinc() {
    color([0.18, 0.22, 0.26]) difference() {
        cube([112, 72, 44], center = true);
        translate([16, 0, 2]) cube([78, 48, 18], center = true);
        translate([-40, 0, 0]) cube([20, 52, 28], center = true);
    }
    // cassette a medio extraer, solo en vista explosionada
    color(col_zinc) translate([70, 0, 2]) cube([78, 46, 16], center = true);
    color(col_seco) translate([-40, 0, 0]) cube([16, 40, 22], center = true);
}

module cinturon() {
    color(col_cint) difference() {
        elipse(175, 125, 18);
        elipse(155, 108, 22);
    }
    // puentes, no túnel a través de la cámara
    for (x = [-20, 28])
        translate([x, 150, -8]) color([0.25, 0.27, 0.30]) cube([16, 16, 14], center = true);
    translate([8, 168, 10]) modulo_zinc();
    // nodo / condensador del traje, bahía seca de sistema
    translate([-150, 40, 8]) color(col_seco) cube([36, 22, 14], center = true);
}

// ---------------------------------------------------------------------
// ENSAMBLAJE — modo calle, de pie, brazos separados para ver el guante
// invierno = true añade el tendón dorsal. No cambia el casco ni la suela.
// ---------------------------------------------------------------------
invierno = true;
explosion = false; // true separa el cassette; el módulo ya lo muestra extraído

translate([0, 0, 0]) base_torso();
translate([0, 0, 0]) capa();

translate([-210, 0, 1320]) rotate([0, 18, 180]) brazo();
translate([210, 0, 1320]) rotate([0, -18, 0]) brazo();

translate([-250, 20, 860]) rotate([0, 70, 0]) guante(invierno);
translate([250, 20, 860]) rotate([0, -70, 180]) guante(invierno);

translate([-90, 0, 200]) pierna();
translate([90, 0, 200]) pierna();

translate([-90, 10, 16]) bota();
translate([90, 10, 16]) rotate([0, 0, 0]) bota();

translate([0, 0, 980]) cinturon();
