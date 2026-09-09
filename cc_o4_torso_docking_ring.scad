// CC-O4 Centauro-Arácnido — Interfaz de Acoplamiento Plug & Play (Torso/Payload)
// Licencia: CERN-OHL-S v2
// Desarrollador: David Dorado Blázquez Moraleda López (@Hipsonmk)
//
// Descripción: Anillo de acoplamiento mecánico para fijar el torso humanoide superior 
// al chasis octópodo inferior. Incluye dientes de indexación anti-rotación y
// canales umbilicales centrales para el loop térmico de galinstano y bus de datos (Edge AI).

/* [Parámetros del Anillo de Acoplamiento] */
ring_outer_dia = 180.0;
ring_inner_dia = 110.0;
ring_thickness = 15.0;
tooth_count = 12;
tooth_depth = 8.0;

/* [Tolerancias y Montaje] */
bolt_hole_dia = 6.5; // Pasante para tornillería M6 estructural
bolt_circle_dia = 145.0;
umbilical_dia = 35.0; // Canal central para tubos de Galinstano y cableado
$fn = 100;

module docking_base() {
    difference() {
        // Cuerpo principal del anillo
        cylinder(h=ring_thickness, d=ring_outer_dia, center=true);
        
        // Vaciado central principal
        cylinder(h=ring_thickness + 2, d=ring_inner_dia, center=true);
        
        // Agujeros de montaje estructural (M6)
        for (i = [0 : 360/8 : 359]) {
            rotate([0, 0, i])
            translate([bolt_circle_dia/2, 0, 0])
            cylinder(h=ring_thickness + 2, d=bolt_hole_dia, center=true);
        }
    }
}

module indexing_teeth() {
    // Dientes trapezoidales para bloquear la torsión del torso
    for (i = [0 : 360/tooth_count : 359]) {
        rotate([0, 0, i])
        translate([ring_inner_dia/2 + tooth_depth/2 - 1, 0, ring_thickness/2])
        linear_extrude(height=6, scale=0.7, center=true)
        square([tooth_depth, 18], center=true);
    }
}

module central_umbilical_guide() {
    // Araña central que guía el loop de galinstano sin comprometer la rigidez
    difference() {
        cylinder(h=ring_thickness, d=umbilical_dia + 15, center=true);
        cylinder(h=ring_thickness + 2, d=umbilical_dia, center=true);
    }
    // Soportes en cruz
    for (i = [0, 90]) {
        rotate([0, 0, i])
        cube([ring_inner_dia, 8, ring_thickness], center=true);
    }
}

// Ensamblaje Final de la Pieza
union() {
    docking_base();
    indexing_teeth();
    central_umbilical_guide();
}
