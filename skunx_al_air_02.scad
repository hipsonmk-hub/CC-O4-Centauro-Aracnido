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
// [PROYECTO NEXUS SHELL] - SKUNX-AL-AIR-02 REPRODUCIBLE Y ESTRIADO
$fn = 64;

// --- PARÁMETROS FÍSICOS Y ESTEQUIOMÉTRICOS ---
c_width = 120;                  // Restricción de bahía hexápodo[span_0](start_span)[span_0](end_span)
c_height = 90;                  // Restricción de bahía hexápodo[span_1](start_span)[span_1](end_span)
masa_al_kg = 5.0;               // Carga reactiva de Al[span_2](start_span)[span_2](end_span)
vol_koh_l = 2.0;                // Solución electrolítica KOH[span_3](start_span)[span_3](end_span)
factor_escoria = 1.20;          // Margen volumétrico post-oxidación[span_4](start_span)[span_4](end_span)

// Motor termodinámico volumétrico real (Al + KOH + Al(OH)3)
vol_al_cm3 = (masa_al_kg * 1000) / 2.70;
vol_koh_cm3 = vol_koh_l * 1000;
// 5 kg de Al generan ~14.5 kg de Al(OH)3 con densidad compactada ~2.42 g/cm3 (~5991 cm3)
vol_escoria_cm3 = ((masa_al_kg * 1000 * 78.003) / 26.98) / 2.42;
vol_total_cm3 = (vol_al_cm3 + vol_koh_cm3 + (vol_escoria_cm3 * factor_escoria));

// Longitud autoescalada real derivada de la celda (mínimo estructural 448 mm)[span_5](start_span)[span_5](end_span)
c_length = max(448, round((vol_total_cm3 * 1000) / (c_width * c_height) + 50));

module skunx_al_air_02_production() {
    union() {
        difference() {
            // 1. Chasis Balístico Estructural
            color("DarkSlateGray")
            cube([c_length, c_width, c_height], center=true);

            // 2. Cámara de Reacción Activa (Zona Cátodo / Al)
            translate([20, 0, 5])
            cube([c_length - 80, c_width - 12, c_height - 16], center=true);

            // 3. Sump / Cárter de Escoria Aislado (Trasero)
            translate([-c_length/4, 0, 5])
            cube([c_length/3, c_width - 12, c_height - 16], center=true);

            // 4. Conducto M20 Lock (Con Boss pasante reforzado)
            translate([c_length/2 - 25, c_width/2 - 6, -c_height/4]) 
            rotate([90, 0, 0]) cylinder(h=20, r=8.75, center=true); // Rosca menor M20

            // 5. Conducto M20 Draining y Alivio de Presión (Aislado del Cátodo)
            translate([c_length/2 - 55, c_width/2 - 6, -c_height/4]) 
            rotate([90, 0, 0]) cylinder(h=20, r=8.75, center=true);
        }

        // 6. Tirador Quick-Release Sólido (Integrado en Cara -Y)
        color("Black")
        translate([c_length/2 - 40, -c_width/2 - 10, 0])
        cube([80, 20, 20], center=true);

        // 7. Tabique Interno de Separación de Fases (Cátodo vs Cárter Escoria)
        color("DimGray")
        translate([-20, 0, 0])
        cube([10, c_width - 12, c_height - 16], center=true);
    }
}

skunx_al_air_02_production();
// NEXUS-L RTOS FSM: Hot-Swap No-Bloqueante con Telemetría Activa
#include <NexusArmRTOS.h>
#include <LogicalAnchorRTOS.h>
#include <SKUNX_AlAir.h>

typedef enum {
    STATE_IDLE,
    STATE_PREFLIGHT_CHECK,
    STATE_ANCHOR_LOCKED_HOLD,
    STATE_DISENGAGE_M20_LOCK,
    STATE_EXTRACT_CARTRIDGE,
    STATE_SAFE_REINSERT,
    STATE_SWAP_COMPLETE
} HotSwapState_t;

HotSwapState_t current_state = STATE_IDLE;
static float extraction_progress_mm = 0.0;
const float target_retraction_mm = 448.0;[span_6](start_span)[span_6](end_span)
const float retraction_speed_mm_s = 20.0;[span_7](start_span)[span_7](end_span)
unsigned long last_tick_ms = 0;

void executeHotSwapFSM() {
    unsigned long current_ms = millis();
    float dt = (current_ms - last_tick_ms) / 1000.0;
    if (dt < 0.01) return; // Ciclo de control a ~100 Hz
    last_tick_ms = current_ms;

    switch (current_state) {
        case STATE_IDLE:
            if (CommandQueue.receive() == CMD_INIT_HOT_SWAP) {
                extraction_progress_mm = 0.0;
                current_state = STATE_PREFLIGHT_CHECK;
            }
            break;

        case STATE_PREFLIGHT_CHECK:
            if (SensorBus.readPressure() < MAX_SAFE_P && SensorBus.readTemp() < 85.0) {
                current_state = STATE_ANCHOR_LOCKED_HOLD;
            } else {
                current_state = STATE_IDLE;
            }
            break;

        case STATE_ANCHOR_LOCKED_HOLD:
            if (LogicalAnchor.getTiltDegrees() < 35.0 && LogicalAnchor.isDeployed()) {
                ArmController.setEndEffector(TOOL_QUICK_RELEASE_GRIPPER);
                Arm.moveToCoordinates(BAY_AL_AIR_POS, APPROACH_VECTOR_Z, 50.0);
                current_state = STATE_DISENGAGE_M20_LOCK;
            } else {
                LogicalAnchor.holdPosition();
            }
            break;

        case STATE_DISENGAGE_M20_LOCK:
            Arm.actuateValves(M20_PORT_LOCK, UNLOCK);
            Arm.actuateValves(M20_DRAIN_RELIEF, OPEN); // Despresurización previa al movimiento
            Arm.closeGripper(HANDLE_80X30_MM);[span_8](start_span)[span_8](end_span)
            current_state = STATE_EXTRACT_CARTRIDGE;
            break;

        case STATE_EXTRACT_CARTRIDGE:
            // Veto dinámico continuo durante la trayectoria
            if (LogicalAnchor.getTiltDegrees() >= 35.0 || !LogicalAnchor.isDeployed()) {
                Arm.emergencyStop();
                current_state = STATE_SAFE_REINSERT;
                break;
            }

            // Avance lineal paso a paso (No bloqueante)
            extraction_progress_mm += retraction_speed_mm_s * dt;[span_9](start_span)[span_9](end_span)
            Arm.stepLinearRetract(extraction_progress_mm);

            if (extraction_progress_mm >= target_retraction_mm)[span_10](start_span)[span_10](end_span) {
                current_state = STATE_SWAP_COMPLETE;
            }
            break;

        case STATE_SAFE_REINSERT:
            // Retorno a posición de reposo con carga para evitar caída de 5 kg
            extraction_progress_mm -= retraction_speed_mm_s * dt;
            Arm.stepLinearRetract(max(0.0f, extraction_progress_mm));
            if (extraction_progress_mm <= 0.0) {
                Arm.actuateValves(M20_PORT_LOCK, LOCK);
                current_state = STATE_IDLE;
            }
            break;

        case STATE_SWAP_COMPLETE:
            Arm.swapCartridgeBay(SLOT_FRESH_UNIT);
            current_state = STATE_IDLE;
            break;
    }
}
