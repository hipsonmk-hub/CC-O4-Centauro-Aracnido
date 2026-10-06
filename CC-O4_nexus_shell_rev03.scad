// =====================================================================
// CC-O4 NEXUS SHELL - DOMINIO 1: MÓDULO TÁCTICO ZINC-AIRE (REV 0.3)
// Arquitectura: circuito abierto al ambiente, cerrado al traje y a la lluvia
// Filosofía: el ánodo es combustible sólido; el oxígeno no es el de respirar
// =====================================================================
//
// Cambios frente a REV 0.2
// - El cinturón no atraviesa la cámara húmeda. Va por dos puentes externos.
// - El cátodo no mira al cielo. Toma aire lateral, con labio y membrana.
// - El cartucho es cassette completo (ánodo + gel + separador), no un lingote.
// - Contactos al fondo del riel, chaveta de polaridad, pestillo de retención.
// - Bahía seca separada para el elevador. El KOH no llega a la electrónica.
// - Química única: zinc-aire. El aluminio-aire suelta hidrógeno; no comparte venteo.
// - Persianas de cátodo cerrables: en modo traje sellado el módulo se aísla.

cinturon_ancho = 50;
cinturon_grosor = 8;
grosor_pared = 3.5;

modulo_largo = 112;
modulo_ancho = 72;
modulo_alto = 44;

cartucho_largo = 78;
cartucho_ancho = 48;
cartucho_alto = 18;

bahia_seca_largo = 22;
$fn = 48;

module chasis_principal() {
    difference() {
        hull() {
            for (x = [-1, 1])
                for (y = [-1, 1])
                    for (z = [-1, 1])
                        translate([x * (modulo_largo/2 - 3), y * (modulo_ancho/2 - 3), z * (modulo_alto/2 - 3)])
                            sphere(r = 3);
        }

        // Cámara húmeda: cassette por la cara frontal (+X)
        translate([6, 0, 2])
            cube([cartucho_largo + 0.6, cartucho_ancho + 0.5, cartucho_alto + 0.45], center = true);

        // Chaveta de polaridad: impide girar el cassette
        translate([cartucho_largo/2 - 8, cartucho_ancho/2 - 6, 2])
            cube([10, 6, cartucho_alto + 1], center = true);

        // Bahía seca trasera, sin comunicación con la cámara húmeda
        translate([-modulo_largo/2 + bahia_seca_largo/2 + grosor_pared, 0, 1])
            cube([bahia_seca_largo - 1, modulo_ancho - 16, modulo_alto - 14], center = true);

        // Tomas laterales del cátodo. No en la tapa superior.
        for (i = [-18 : 12 : 18]) {
            translate([i + 4, modulo_ancho/2, 4])
                rotate([90, 0, 0])
                cylinder(d = 3.2, h = 12, center = true);
            translate([i + 4, -modulo_ancho/2, 4])
                rotate([90, 0, 0])
                cylinder(d = 3.2, h = 12, center = true);
        }

        // Drenaje de condensado, no venteo de gas de ánodo
        translate([8, 0, -modulo_alto/2])
            cylinder(d = 2.4, h = 8, center = true);
    }
}

module puente_cinturon() {
    difference() {
        cube([16, cinturon_ancho + 8, cinturon_grosor + 6], center = true);
        cube([16 + 2, cinturon_ancho, cinturon_grosor], center = true);
    }
}

module cartucho_zinc() {
    difference() {
        cube([cartucho_largo, cartucho_ancho, cartucho_alto], center = true);
        // Muesca de pestillo
        translate([-cartucho_largo/2 + 4, 0, cartucho_alto/2])
            cube([8, 14, 4], center = true);
        // Chaflán de la chaveta
        translate([0, cartucho_ancho/2, 0])
            cube([cartucho_largo + 2, 5, cartucho_alto + 2], center = true);
    }
}

color("DarkSlateGray") chasis_principal();

for (x = [-34, 34])
    translate([x, 0, -modulo_alto/2 - 4])
        color("DimGray") puente_cinturon();

translate([46, 0, 2])
    color("Silver") cartucho_zinc();
