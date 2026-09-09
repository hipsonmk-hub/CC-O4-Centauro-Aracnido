// CC-O4 Centauro-Arácnido — Terminal de Anclaje Híbrido Cero-G (Pie)
// Licencia: CERN-OHL-S v2
// Desarrollador: David Dorado Blázquez Moraleda López (@Hipsonmk)
//
// Descripción: Módulo terminal para las 8 extremidades diseñado para microgravedad (asteroides).
// Integra tres sistemas:
// 1. Percusión neumática (8 bar) para anclaje balístico instantáneo.
// 2. Inyección criogénica de galinstano (expansión en vacío) para bloqueo mecánico profundo.
// 3. Almohadillas PVDF para cosecha piezoeléctrica a partir de la tensión estructural.

/* [Dimensiones del Terminal Cero-G] */
foot_outer_dia = 65.0;
foot_height = 55.0;
joint_connector_w = 24.0; // Compatible con cc_o4_joint_624zz

/* [Subsistema Neumático y Térmico] */
pneumatic_cylinder_dia = 16.0; // Cilindro para el perno de carburo de tungsteno
galinstan_capillary_dia = 3.5; // Canales de inyección de metal líquido
pvdf_pad_thickness = 4.0;      // Espacio para los transductores piezoeléctricos

$fn = 80;

module structural_housing() {
    difference() {
        // Campana exterior del terminal
        hull() {
            cylinder(d=foot_outer_dia, h=10, center=false);
            translate([0, 0, foot_height - 15])
            cylinder(d=foot_outer_dia - 20, h=15, center=false);
        }
        
        // Vaciado central para el cilindro neumático del perno percutor
        translate([0, 0, -5])
        cylinder(d=pneumatic_cylinder_dia, h=foot_height + 10, center=false);
        
        // Vaciado inferior para el alojamiento de la almohadilla PVDF
        translate([0, 0, -1])
        cylinder(d=foot_outer_dia - 10, h=pvdf_pad_thickness + 1, center=false);
        
        // Capilares periféricos para la inyección de Galinstano
        for (i = [0 : 360/6 : 359]) {
            rotate([0, 0, i])
            translate([foot_outer_dia/2 - 12, 0, -2])
            cylinder(d=galinstan_capillary_dia, h=foot_height, center=false);
        }
    }
}

module joint_interface() {
    // Horquilla superior para conectar con el nodo 624ZZ
    translate([0, 0, foot_height])
    difference() {
        hull() {
            cylinder(d=foot_outer_dia - 20, h=5, center=false);
            translate([0, 0, 18])
            cube([joint_connector_w + 12, 25, 20], center=true);
        }
        // Hueco para la articulación
        translate([0, 0, 20])
        cube([joint_connector_w + 0.8, 30, 25], center=true);
        // Eje pasante M4
        translate([0, 0, 18])
        rotate([90, 0, 0])
        cylinder(d=4.3, h=40, center=true);
    }
}

module pvdf_piezo_pads() {
    // Representación del anillo piezoeléctrico de contacto
    color("Gold")
    translate([0, 0, 0.5])
    difference() {
        cylinder(d=foot_outer_dia - 10.5, h=pvdf_pad_thickness - 0.5, center=false);
        cylinder(d=pneumatic_cylinder_dia + 4, h=pvdf_pad_thickness + 2, center=false);
    }
}

// Ensamblaje Final
union() {
    color([0.25, 0.25, 0.28]) structural_housing();
    color([0.4, 0.4, 0.45]) joint_interface();
    pvdf_piezo_pads();
}
### Terminal de Anclaje Híbrido Cero-G (`cc_o4_hybrid_anchor_foot.scad`)
En un entorno de microgravedad (minería de asteroides), un rover tradicional sale despedido al intentar taladrar. La base octópoda del CC-O4 soluciona esto operando mediante pura biomecánica de inmovilización: anula la inercia controlando el centro de gravedad con agarres absolutos a la roca. 

El terminal de cada pata integra un sistema de triple acción:
*   **Percusión Neumática:** Dispara un micro-perno de carburo a 8 bar en milisegundos, asegurando el anclaje inicial antes de que la fuerza de reacción empuje al robot.
*   **Bloqueo Criogénico de Galinstano:** Inyecta fluido del circuito de refrigeración en las grietas de la roca. Al exponerse al vacío, el metal se congela y se expande pasivamente, creando un candado estructural irrompible. Para soltar la pata, el sistema calienta el fluido y retrae el metal.
*   **Cosecha Piezo-Tensional:** Incorpora transductores PVDF (`pvdf_pad_thickness = 4.0`) en la base. Toda la tensión generada al aferrarse al asteroide se convierte en electricidad constante, alimentando la plataforma mientras trabaja.
