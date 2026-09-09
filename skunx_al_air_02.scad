// [PROYECTO NEXUS SHELL] - SKUNX-AL-AIR-02 DEFINITIVO
// Arquitectura Paramétrica de Celda Metal-Aire Terrestre

$fn = 64;

// --- PARÁMETROS FÍSICOS REPRODUCIBLES ---
c_width = 120;                  // Restricción de bahía hexápodo (mm)[span_0](start_span)[span_0](end_span)
c_height = 90;                  // Restricción de bahía hexápodo (mm)[span_1](start_span)[span_1](end_span)
c_length = 448;                 // Longitud autoescalada (mm)[span_2](start_span)[span_2](end_span)
masa_aluminio_kg = 5.0;         // Carga reactiva de Al (kg)[span_3](start_span)[span_3](end_span)
volumen_koh_l = 2.0;            // Solución electrolítica KOH (L)[span_4](start_span)[span_4](end_span)
factor_expansion = 1.20;        // Margen volumétrico de escoria Al(OH)3

module skunx_al_air_02_rig() {
    difference() {
        // Chasis Balístico Dinámico
        color("DarkSlateGray")
        cube([c_length, c_width, c_height], center=true);

        // Cámara de Reacción Interna
        translate([0, 0, 5])
        cube([c_length - 12, c_width - 12, c_height], center=true);

        // Puerto M20 de Anclaje Mecánico (Lock)
        translate([c_length/2 - 25, c_width/2, -c_height/4]) 
        rotate([90, 0, 0]) cylinder(h=12, r=10, center=true);

        // Puerto M20 Separado: Alivio de Presión y Drenaje de Escoria
        translate([c_length/2 - 55, c_width/2, -c_height/4]) 
        rotate([90, 0, 0]) cylinder(h=12, r=10, center=true);
        
        // Tirador Quick-Release (80x30 mm)
        translate([0, -c_width/2 - 15, 0])
        cube([80, 30, 20], center=true);
    }
}

skunx_al_air_02_rig();
