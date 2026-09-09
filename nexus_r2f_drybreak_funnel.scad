// NEXUS SHELL (Ecosistema CC-O4) — Embudo R2F (Rapid Refill) y Válvula Dry-Break
// Licencia: CERN-OHL-S v2
// Desarrollador: David Dorado Blázquez Moraleda López (@Hipsonmk)
//
// Descripción: Interfaz cónica de acoplamiento de fluidos (Ecofire/Agua/Combustible).
// Diseñado para operaciones en pendiente sin interrupción. Incluye canal principal
// de 8 bar y anillo perimetral de purga neumática para expulsar ceniza/polvo lunar antes del sellado.

/* [Dimensiones del Embudo Cónico] */
cone_outer_dia = 120.0;
cone_inner_dia = 40.0;
cone_depth = 55.0;
flange_thickness = 8.0;

/* [Canales de Fluidos y Neumática] */
fluid_channel_dia = 25.0; // Caudal masivo (45 L/min)
purge_ring_dia = 32.0;    // Diámetro del anillo donde se sitúan los inyectores de aire
purge_hole_dia = 2.5;     // Soplado de purga a 8 bar
$fn = 80;

module guiding_cone() {
    difference() {
        // Bloque exterior del embudo
        cylinder(h=cone_depth, r1=cone_inner_dia/2 + 10, r2=cone_outer_dia/2, center=false);
        
        // Vaciado cónico interno (Guía mecánica para el brazo del NEXUS-L)
        translate([0, 0, flange_thickness])
        cylinder(h=cone_depth, r1=cone_inner_dia/2, r2=cone_outer_dia/2 - 5, center=false);
        
        // Canal central de fluidos (Válvula Dry-Break)
        translate([0, 0, -5])
        cylinder(h=cone_depth + 10, d=fluid_channel_dia, center=false);
    }
}

module pneumatic_purge_system() {
    // Inyectores de aire a alta presión para limpiar el acoplamiento
    // Actúan milisegundos antes del contacto físico total
    for (i = [0 : 360/8 : 359]) {
        rotate([0, 0, i])
        translate([purge_ring_dia/2, 0, -2])
        cylinder(h=flange_thickness + 5, d=purge_hole_dia, center=false);
    }
}

module structural_flange() {
    // Brida de anclaje al depósito del robot
    difference() {
        cylinder(h=flange_thickness, d=cone_outer_dia + 20, center=false);
        
        // Agujeros de anclaje M5
        for (i = [45 : 90 : 315]) {
            rotate([0, 0, i])
            translate([cone_outer_dia/2 + 4, 0, -1])
            cylinder(h=flange_thickness + 2, d=5.5, center=false);
        }
    }
}

// Ensamblaje Final de la Pieza
difference() {
    union() {
        structural_flange();
        guiding_cone();
    }
    pneumatic_purge_system();
}
