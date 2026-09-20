// CC-O4-W0 — Brida de cintura (ICD Rev A, 2026-09-20)
// Lado A: base octópoda. Lado B: dummy / adaptador de torso.
// Licencia: CERN-OHL-S v2
// Autor: David Dorado Blázquez Moraleda López (@Hipsonmk)
//
// ESTE archivo sustituye a cc_o4_torso_docking_ring.scad (Ø180 / PCD 145 / M6).
// No es el patrón Tesla. Es nuestra junta. Un adaptador intermedio irá encima
// el día que exista cota oficial de torso.
//
// Unidades: mm. $fn alto para exportar STL de CNC/impresión.
// Material objetivo Fase 0: 6082-T6 e=12. Análogo FDM: PETG-CF, NO apretar a 25 N·m.

/* [ICD CC-O4-W0] */
flange_od        = 220.0;
flange_thick     = 12.0;
bore_dia         = 70.0;
keepout_dia      = 100.0;   // zona libre de tornillos / nervios
bolt_pcd         = 190.0;
bolt_count       = 8;
bolt_hole_dia    = 8.4;     // pasante M8 (6H va en la tuerca o en la placa hembra)
bolt_angle0      = 22.5;    // 22.5 + n*45  (fuera de los ejes)
dowel_pcd        = 150.0;
dowel_dia        = 8.0;     // h7 en metal; en FDM dejar holgura (ver analog_clearance)
dowel_depth      = 10.0;
analog_clearance = 0.20;    // holgura extra solo si printed = true

/* [Fabricación] */
printed          = false;   // true = holguras de PETG-CF / 624ZZ world
chamfer          = 0.6;
$fn              = 96;

function hole(d) = d + (printed ? analog_clearance : 0);

module flange_body() {
    difference() {
        cylinder(h = flange_thick, d = flange_od, center = true);

        // paso de arnés
        cylinder(h = flange_thick + 2, d = hole(bore_dia), center = true);

        // 8 × M8 PCD 190
        for (i = [0 : bolt_count - 1]) {
            a = bolt_angle0 + i * 360 / bolt_count;
            rotate([0, 0, a])
            translate([bolt_pcd / 2, 0, 0])
                cylinder(h = flange_thick + 2, d = hole(bolt_hole_dia), center = true);
        }

        // P1 maestro en +X, P2 a 180°. Profundos desde la cara +Z (torso).
        for (a = [0, 180]) {
            rotate([0, 0, a])
            translate([dowel_pcd / 2, 0, flange_thick / 2 - dowel_depth / 2 + 0.01])
                cylinder(h = dowel_depth + 0.02, d = hole(dowel_dia), center = true);
        }
    }
}

// Marca +X / P1 en el canto, para no montarlo al revés a las 3 de la mañana.
module clock_notch() {
    translate([flange_od / 2 - 3, 0, 0])
        cube([6, 4, flange_thick + 0.2], center = true);
}

module keepout_ghost() {
    // Solo preview: cilindro del keep-out. No entra en el STL.
    color([1, 0.4, 0.15, 0.12])
        cylinder(h = 80, d = keepout_dia, center = true);
}

module cc_o4_w0_base() {
    difference() {
        flange_body();
        clock_notch();
    }
}

// Placa dummy lado B (misma cota, pasadores pasantes para inspección).
module cc_o4_w0_dummy() {
    difference() {
        cylinder(h = flange_thick, d = flange_od, center = true);
        cylinder(h = flange_thick + 2, d = hole(bore_dia), center = true);
        for (i = [0 : bolt_count - 1]) {
            a = bolt_angle0 + i * 360 / bolt_count;
            rotate([0, 0, a])
            translate([bolt_pcd / 2, 0, 0])
                cylinder(h = flange_thick + 2, d = hole(bolt_hole_dia), center = true);
        }
        for (a = [0, 180]) {
            rotate([0, 0, a])
            translate([dowel_pcd / 2, 0, 0])
                cylinder(h = flange_thick + 2, d = hole(dowel_dia), center = true);
        }
        // muesca +X espejo
        translate([flange_od / 2 - 3, 0, 0])
            cube([6, 4, flange_thick + 0.2], center = true);
    }
}

// Vista de conjunto. Comenta dummy para exportar solo la base.
cc_o4_w0_base();
%keepout_ghost();
translate([0, 0, flange_thick + 0.2])
    color([0.75, 0.78, 0.82, 0.85])
        cc_o4_w0_dummy();

echo("CC-O4-W0 OD", flange_od, "PCD_M8", bolt_pcd, "PCD_DOWEL", dowel_pcd, "BORE", bore_dia);
echo(printed ? "FDM analog — NO 25 N·m on printed holes" : "6082-T6 target — M8 @ 25 N·m");
