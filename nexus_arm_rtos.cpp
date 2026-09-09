// NEXUS-L RTOS FSM: Hot-Swap con Veto de Anclaje Lógico
#include <NexusArmRTOS.h>
#include <LogicalAnchorRTOS.h>
#include <SKUNX_AlAir.h>

typedef enum {
    STATE_IDLE,
    STATE_PREFLIGHT_CHECK,
    STATE_ANCHOR_LOCKED_HOLD,
    STATE_DISENGAGE_M20_LOCK,
    STATE_EXTRACT_CARTRIDGE,
    STATE_SWAP_COMPLETE
} HotSwapState_t;

HotSwapState_t current_state = STATE_IDLE;

void executeHotSwapFSM() {
    switch (current_state) {
        case STATE_IDLE:
            if (CommandQueue.receive() == CMD_INIT_HOT_SWAP) {
                current_state = STATE_PREFLIGHT_CHECK;
            }
            break;

        case STATE_PREFLIGHT_CHECK:
            // Validar temperatura, presión del cárter y estado del bus
            if (SensorBus.readPressure() < MAX_SAFE_P && SensorBus.readTemp() < 85.0) {
                current_state = STATE_ANCHOR_LOCKED_HOLD;
            } else {
                current_state = STATE_IDLE; // Aborto preventivo
            }
            break;

        case STATE_ANCHOR_LOCKED_HOLD:
            // Veto de seguridad: El Ancla Lógica debe asegurar el chasis (piso firme)
            if (LogicalAnchor.getTiltDegrees() < 35.0 && LogicalAnchor.isDeployed()) {
                ArmController.setEndEffector(TOOL_QUICK_RELEASE_GRIPPER);
                Arm.moveToCoordinates(BAY_AL_AIR_POS, APPROACH_VECTOR_Z, 50.0);
                current_state = STATE_DISENGAGE_M20_LOCK;
            } else {
                LogicalAnchor.holdPosition(); // Esperar estabilización del chasis
            }
            break;

        case STATE_DISENGAGE_M20_LOCK:
            Arm.actuateValves(M20_PORT_LOCK, UNLOCK);
            Arm.actuateValves(M20_DRAIN_RELIEF, CLOSE);
            Arm.closeGripper(HANDLE_80X30_MM);
            current_state = STATE_EXTRACT_CARTRIDGE;
            break;

        case STATE_EXTRACT_CARTRIDGE:
            // Extracción lineal estricta a 20 mm/s con monitoreo IMU activo[span_5](start_span)[span_5](end_span)
            if (LogicalAnchor.getTiltDegrees() < 35.0) {
                Arm.linearRetract(448.0, 20.0); //[span_6](start_span)[span_6](end_span)
                current_state = STATE_SWAP_COMPLETE;
            } else {
                Arm.emergencyStop(); // Aborto inmediato si el chasis oscila con 5 kg en punta
                current_state = STATE_ANCHOR_LOCKED_HOLD;
            }
            break;

        case STATE_SWAP_COMPLETE:
            Arm.swapCartridgeBay(SLOT_FRESH_UNIT);
            current_state = STATE_IDLE;
            break;
    }
}
