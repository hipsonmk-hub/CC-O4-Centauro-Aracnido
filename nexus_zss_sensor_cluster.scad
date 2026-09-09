// CC-O4 / NEXUS SHELL — ZSS (Zero Sight Suite) Sensor Cluster
// Licencia: CERN-OHL-S v2
// Desarrollador: David Dorado Blázquez Moraleda López (@Hipsonmk)
//
// Descripción: Chasis del módulo de percepción multimodal ZSS.
// Aloja LiDAR Multi-Eco SWIR, cámaras LWIR estéreo, radar FMCW,
// sensores ultrasónicos y hardware de navegación (IMU táctica + UWB).
// Diseñado con planos angulares para desviar calor radiante y escombros.

/* [Dimensiones del Cluster ZSS] */
zss_width = 140.0;
zss_height = 80.0;
zss_depth = 90.0;
wall_thickness = 4.0;

/* [Ventanas de Sensores] */
lidar_dia = 45.0;       // LiDAR SWIR central (visibilidad a través de humo/polvo)
lwir_dia = 22.0;        // Lentes estéreo LWIR (Infrarrojo Térmico)
lwir_baseline = 90.0;   // Separación estéreo (línea base para profundidad)
us_dia = 16.0;          // Transductores ultrasónicos
        
$fn = 80;

// --- Cuerpo Principal (Diseño Angular/Faceted) ---
module zss_shell() {
    difference() {
        // Bloque exterior trapezoidal (desvío aerodinámico y balístico)
        hull() {
            translate([0, zss_depth/2 - 10, -zss_height/2 + 10]) 
                cube([zss_width, 20, 20], center=true); // Frente bajo
            translate([0, zss_depth/2 - 10, zss_height/2 - 10]) 
                cube([zss_width - 30, 20, 20], center=true); // Frente alto (inclinado)
            translate([0, -zss_depth/2 + 10, 0]) 
                cube([zss_width - 20, 20, zss_height], center=true); // Trasera
        }

        // Vaciado interno para la electrónica Edge AI y cableado
        hull() {
            translate([0, zss_depth/2 - 10, -zss_height/2 + 10]) 
                cube([zss_width - wall_thickness*2, 20, 20 - wall_thickness], center=true);
            translate([0, zss_depth/2 - 10, zss_height/2 - 10]) 
                cube([zss_width - 30 - wall_thickness*2, 20, 20 - wall_thickness], center=true);
            translate([0, -zss_depth/2 + 10, 0]) 
                cube([zss_width - 20 - wall_thickness*2, 20, zss_height - wall_thickness*2], center=true);
        }

        // 1. Apertura Central: LiDAR SWIR 1.5 µm
        translate([0, zss_depth/2, 0])
            rotate([90, 0, 0])
            cylinder(d=lidar_dia, h=30, center=true);

        // 2. Aperturas Estéreo: Cámaras LWIR (Infrarrojo Térmico)
        translate([lwir_baseline/2, zss_depth/2, 0])
            rotate([90, 0, 0])
            cylinder(d=lwir_dia, h=30, center=true);
        translate([-lwir_baseline/2, zss_depth/2, 0])
            rotate([90, 0, 0])
            cylinder(d=lwir_dia, h=30, center=true);

        // 3. Sensores Ultrasónicos (Inclinados hacia el suelo para mapeo cercano)
        translate([lwir_baseline/2 - 15, zss_depth/2 - 12, -zss_height/2 + 5])
            rotate([90, 20, 0])
            cylinder(d=us_dia, h=30, center=true);
        translate([-lwir_baseline/2 + 15, zss_depth/2 - 12, -zss_height/2 + 5])
            rotate([90, -20, 0])
            cylinder(d=us_dia, h=30, center=true);
            
        // 4. Panel de interfaz de montaje (Cuello)
        translate([0, -zss_depth/4, -zss_height/2])
            cylinder(d=40, h=15, center=true);
    }
}

// --- Paneles Radar FMCW ---
module radar_panels() {
    // Los radares de onda continua (77-81 GHz) van sellados tras los laterales angulados
    // para protección total frente a ceniza o polvo.
    color("DarkSlateGray") {
        translate([zss_width/2 - 12, 0, 0])
            rotate([0, 15, 0])
            cube([4, 40, 40], center=true);
        translate([-zss_width/2 + 12, 0, 0])
            rotate([0, -15, 0])
            cube([4, 40, 40], center=true);
    }
}

// --- Base de Acoplamiento y Rutas de Datos ---
module mounting_interface() {
    // Interfaz base para anclar al torso, con canal para bus UWB y alimentación
    translate([0, -zss_depth/4, -zss_height/2 - 5])
    difference() {
        cylinder(d=45, h=10, center=true);
        cylinder(d=25, h=12, center=true); // Canal interno de cables
        
        // Agujeros de anclaje (M4)
        for (i = [0:90:270]) {
            rotate([0, 0, i])
            translate([16, 0, 0])
            cylinder(d=4.5, h=12, center=true);
        }
    }
}

// Ensamblaje Final
union() {
    color([0.20, 0.22, 0.25]) zss_shell();
    radar_panels();
    color([0.45, 0.45, 0.48]) mounting_interface();
}
### Módulo de Percepción ZSS - Zero Sight Suite (`nexus_zss_sensor_cluster.scad`)
El chasis cognitivo de la plataforma. Diseñado con una morfología angular/trapezoidal, su función es alojar el clúster de sensores evitando la acumulación de ceniza, regolito y desviando el calor radiante. 

*   **Fusión Multimodal:** Incorpora espacios paramétricos para un LiDAR Multi-Eco SWIR (1.5 µm) central, y cámaras estéreo LWIR (8-14 µm) con una línea base de 90mm (`lwir_baseline = 90.0`) para calcular profundidad en visibilidad cero.
*   **Paneles FMCW Integrados:** Laterales angulados diseñados para alojar radares FMCW de 77–81 GHz operando a través de la carcasa sellada.
*   **Mapeo de Proximidad:** Puertos inferiores inclinados 20 grados para transductores ultrasónicos, permitiendo topografía del suelo y detección de obstáculos inmediatos.
