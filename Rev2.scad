// CC-O4 / NEXUS — Fase 0 (Rev 0.2 - Capa Compliant TPU + Límite Flecha PZT 0.18 mm)
// Cosecha piezoeléctrica en calzado de operador (nodo Móstoles, 1 g)
// Materiales:
//   - Base, Pusher y Tapa: PETG-CF o PA12 (4 perímetros, 50% gyroid)
//   - Pucks elásticos (x2): TPU 95A o Silicona Shore 60A
// Unidades: mm. OpenSCAD 2021+

$fn = 64;

// ---------- Parámetros mecánicos ----------
disc_od          = 27.0;   // Ø exterior disco latón PZT
ceramic_od       = 20.0;   // Ø cerámica activa
disc_th          = 0.45;   // espesor total del disco PZT
ceramic_flex_max = 0.18;   // FLECHA MÁXIMA SEGURA PZT (hace tope inferior a 0.18 mm)
pusher_stroke    = 1.20;   // carrera del pusher_plate antes del hard-stop en yunque

// Geometría del puck compliant (TPU 95A)
tpu_od           = 16.0;   // apoya dentro de la cerámica sin tocar soldadura
tpu_socket_d     = 1.00;   // empotramiento dentro del pusher_plate
tpu_h            = tpu_socket_d + pusher_stroke + 0.25; // 2.45 mm (0.25 mm de precarga)

// Espesores estructurales y canales 26-28 AWG
wall             = 2.4;
floor_th         = 2.6;    // suelo macizo bajo el pozo de 0.18 mm
lid_th           = 2.0;
pusher_th        = 2.6;
wire_w           = 2.4;    // ampliado para par 26-28 AWG silicona
wire_h           = 1.8;

// Cotas globales del bloque (100% plano en Z=0)
anvil_h = floor_th + ceramic_flex_max + disc_th; // 3.23 mm (plano de hard-stop)
body_l  = 72;
body_w  = 52;
body_h  = anvil_h + pusher_stroke + pusher_th + 0.6 + lid_th; // ~9.63 mm total
pitch_y = 28.0;

module rounded_box(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r])
        for (y = [-w/2 + r, w/2 - r])
            translate([x, y, 0]) cylinder(r=r, h=h);
    }
}

module disc_pocket_rev02() {
    // 1. Pozo de micro-flexión controlada (SOLO 0.18 mm de flecha libre bajo cerámica)
    // Superados 0.18 mm, el latón apoya en plano contra Z = floor_th (2.60 mm)
    translate([0, 0, floor_th])
        cylinder(d = ceramic_od - 0.5, h = ceramic_flex_max + 0.05);

    // 2. Chaflán suave de transición (evita arista viva contra el latón al flexionar)
    translate([0, 0, floor_th + ceramic_flex_max - 0.15])
        cylinder(d1 = ceramic_od - 0.5, d2 = ceramic_od + 1.0, h = 0.20);

    // 3. Asiento periférico del anillo de latón (cara superior queda a ras de Z = anvil_h)
    translate([0, 0, floor_th + ceramic_flex_max])
        cylinder(d = disc_od + 0.5, h = disc_th + 0.05);

    // 4. Chaflán superior del asiento (alivio de borde en el hard-stop)
    translate([0, 0, anvil_h - 0.25])
        cylinder(d1 = disc_od + 0.5, d2 = disc_od + 1.4, h = 0.30);

    // 5. Testigo de polaridad (+) y alivio para gota de soldadura en dirección +X
    translate([disc_od/2 - 1.0, 0, floor_th + ceramic_flex_max - 0.2])
        cylinder(d = 4.5, h = disc_th + 0.5);
}

module wire_channel_26awg() {
    // Canal principal de salida hacia el borde medial (+X, tobillo) para cable 26-28 AWG
    translate([body_l/2 - 10, 0, anvil_h - wire_h/2 + 0.2])
        cube([24, wire_w + 1.2, wire_h + 0.4], center=true);

    // Zanja colectora entre los dos testigos de soldadura (+X de cada disco)
    translate([2 + disc_od/2 - 1.0, 0, anvil_h - wire_h/2 + 0.2])
        cube([3.2, pitch_y + 2, wire_h + 0.4], center=true);
}

module base_body() {
    difference() {
        // Exterior macizo con base plana en Z = 0
        rounded_box(body_l, body_w, body_h - lid_th, 6);

        // Cámara del pusher_plate (el fondo en Z = anvil_h es el hard-stop plano)
        translate([0, 0, anvil_h])
            rounded_box(body_l - 2*wall, body_w - 2*wall, body_h, 4);

        // Dos cajeados PZT con límite de flecha de 0.18 mm
        for (s = [-1, 1])
            translate([2, s * pitch_y/2, 0])
                disc_pocket_rev02();

        // Zanjas para cable 26-28 AWG
        wire_channel_26awg();

        // Cajera superior para el labio de la tapa
        translate([0, 0, body_h - lid_th - 0.6])
            rounded_box(body_l - 1.6, body_w - 1.6, 2.0, 5.2);

        // Orificio de purga de aire (fuera de los discos)
        translate([-body_l/2 + 8, body_w/2 - 8, -0.1])
            cylinder(d = 2.2, h = anvil_h + 1);
    }
}

module pusher_plate() {
    // Placa rígida en PETG-CF/PA12 con alojamientos para los pucks de TPU 95A
    difference() {
        rounded_box(body_l - 2*wall - 1.0, body_w - 2*wall - 1.0, pusher_th, 4);

        // Alojamientos inferiores para empotrar los 2 pucks de TPU 95A
        for (s = [-1, 1])
            translate([2, s * pitch_y/2, -0.05])
                cylinder(d = tpu_od + 0.3, h = tpu_socket_d + 0.05);

        // Rebaje inferior sobre la zanja de cables para no pellizcar el 26-28 AWG
        translate([2 + disc_od/2 - 1.0, 0, -0.05])
            cube([6.0, pitch_y + 6, 0.9], center=true);
    }
}

module tpu_puck() {
    // Imprimir 2 unidades en TPU 95A (100% infill o 4 perímetros + 60% gyroid)
    cylinder(d1 = tpu_od - 1.0, d2 = tpu_od, h = tpu_h);
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
module assembly(explode = 0, compression = 0) {
    color("DimGray") base_body();

    color("Gold")
    for (s = [-1, 1])
        translate([2, s * pitch_y/2, floor_th + ceramic_flex_max + explode*4])
            cylinder(d = disc_od, h = disc_th);

    color("Crimson")
    for (s = [-1, 1])
        translate([2, s * pitch_y/2, anvil_h + explode*7])
            tpu_puck();

    color("SteelBlue")
        translate([0, 0, anvil_h + pusher_stroke - compression + explode*10])
            pusher_plate();

    color("SlateGray")
        translate([0, 0, body_h - lid_th + explode*15])
            lid();
}

// Render por defecto
// Para exportar STL: base_body(); | pusher_plate(); | tpu_puck(); | rotate([180,0,0]) lid();
assembly(explode = 0, compression = 0);
