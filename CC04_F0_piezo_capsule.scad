// CC-O4 / NEXUS — Fase 0 (Rev 0.1 - Geometría FDM corregida)
// Cosecha piezoeléctrica en calzado de operador (nodo Móstoles, 1 g)
// Cajeado FDM con hard-stop macizo a 1.20 mm para discos PZT
// Autor conceptual: HIPSONMK / David Dorado — módulo paralelo al ICD CC-04-W0
// Unidades: mm. OpenSCAD 2021+

$fn = 64;

// ---------- Parámetros mecánicos ----------
disc_od          = 27.0;   // disco piezo comercial típico (latón)
ceramic_od       = 20.0;   // cerámica activa
disc_th          = 0.45;   // espesor total disco
deflect_nom      = 1.20;   // carrera útil objetivo antes del hard-stop (mm)
wall             = 2.2;    // espesor de pared perimetral
floor_th         = 2.4;    // suelo bajo el pozo de flexión
lid_th           = 2.0;    // espesor de tapa superior
pusher_th        = 2.0;    // espesor de placa empujadora
wire_w           = 1.8;
wire_h           = 1.2;

// Cotas derivadas del yunque macizo y del inserto (~9.85 mm alto total)
anvil_h = floor_th + deflect_nom + disc_th; // 4.05 mm (cota del tope plano)
body_l  = 72;
body_w  = 52;
body_h  = anvil_h + deflect_nom + pusher_th + 0.6 + lid_th;

// Dos discos en talón, eje medio-lateral
pitch_y = 28.0;

module rounded_box(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r])
        for (y = [-w/2 + r, w/2 - r])
            translate([x, y, 0]) cylinder(r=r, h=h);
    }
}

module disc_pocket_solid() {
    // 1. Pozo de flexión bajo la cerámica (1.35 mm libres: 1.20 mm carrera + 0.15 mm margen)
    translate([0, 0, floor_th - 0.15])
        cylinder(d = ceramic_od + 0.8, h = deflect_nom + 0.25);

    // 2. Escalón periférico para el anillo de latón (deja la cara superior a Z = anvil_h)
    translate([0, 0, floor_th + deflect_nom])
        cylinder(d = disc_od + 0.5, h = disc_th + 0.05);
}

module wire_channel() {
    // Salida hacia el borde medial (tobillo / PMIC en contrafuerte)
    translate([body_l/2 - 8, 0, floor_th + deflect_nom])
        rotate([0, 90, 0])
            cube([wire_h + 0.4, wire_w + 0.6, 20], center=true);

    // Zanja central de unión entre ambos discos PZT
    translate([2, 0, floor_th + deflect_nom])
        cube([4.0, pitch_y, wire_h + 0.4], center=true);
}

module base_body() {
    difference() {
        // Bloque exterior 100% plano en Z=0 (sin elementos en Z negativo)
        rounded_box(body_l, body_w, body_h - lid_th, 6);

        // Cámara superior para alojar el recorrido del pusher_plate
        translate([0, 0, anvil_h])
            rounded_box(body_l - 2*wall, body_w - 2*wall, body_h, 4);

        // Excavación de los dos bolsillos en el yunque macizo
        for (s = [-1, 1])
            translate([2, s * pitch_y/2, 0])
                disc_pocket_solid();

        // Canales para hilo 30 AWG
        wire_channel();

        // Cajera de registro para el labio de la tapa
        translate([0, 0, body_h - lid_th - 0.6])
            rounded_box(body_l - 1.6, body_w - 1.6, 2, 5.2);

        // Orificio de ecualización de aire / desmoldeo
        translate([-body_l/2 + 8, body_w/2 - 8, -0.1])
            cylinder(d = 2.2, h = anvil_h + 1);
    }
}

module pusher_plate() {
    // Imprimible boca arriba invirtiendo Z (rotate([180,0,0])) para evitar soportes
    difference() {
        union() {
            // Placa plana que hace hard-stop contra Z = anvil_h al bajar 1.20 mm
            rounded_box(body_l - 2*wall - 1.0, body_w - 2*wall - 1.0, pusher_th, 4);

            // Tetones centrales que deflectan la cerámica 1.20 mm
            for (s = [-1, 1])
                translate([2, s * pitch_y/2, -deflect_nom])
                    cylinder(d = ceramic_od - 4.0, h = deflect_nom + 0.05);
        }
        // Ventana central de alivio para los cables soldados
        cube([16, 6, 10], center=true);
    }
}

module lid() {
    rounded_box(body_l, body_w, lid_th, 6);
    translate([0, 0, -0.6])
        difference() {
            rounded_box(body_l - 2.0, body_w - 2.0, 0.6, 5);
            translate([0, 0, -0.1])
                rounded_box(body_l - 3.6, body_w - 3.6, 1.0, 4);
        }
}

// ---------- Ensamblaje de visualización ----------
// compression = 0.0 (reposo) | compression = 1.20 (talonazo en hard-stop)
module assembly(explode = 0, compression = 0) {
    color("DimGray") base_body();

    color("Gold")
    for (s = [-1, 1])
        translate([2, s * pitch_y/2, floor_th + deflect_nom + explode*4])
            cylinder(d = disc_od, h = disc_th);

    color("SteelBlue")
        translate([0, 0, anvil_h + deflect_nom - compression + explode*8])
            pusher_plate();

    color("SlateGray")
        translate([0, 0, body_h - lid_th + explode*14])
            lid();
}

// Render por defecto: conjunto cerrado en reposo
// Para exportar STL sin soportes:
//   1. base_body();
//   2. rotate([180,0,0]) pusher_plate();
//   3. rotate([180,0,0]) lid();
assembly(explode = 0, compression = 0);
