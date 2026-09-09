// NEXUS-L Arm Kinematic Routine: Hot-Swap for SKUNX-AL-AIR-02
// Bay Constraints: 120x90 mm cross-section, Length: 448 mm[span_0](start_span)[span_0](end_span)

#include <NexusArmRTOS.h>
#include <SKUNX_AlAir.h>

void executeHotSwapSequence() {
    ArmController.setEndEffector(TOOL_QUICK_RELEASE_GRIPPER);
    
    // 1. Aproximación lineal al chasis hexápodo (Bahía 120x90 mm)[span_1](start_span)[span_1](end_span)
    Arm.moveToCoordinates(BAY_AL_AIR_POS, APPROACH_VECTOR_Z, 50.0); // mm/s
    
    // 2. Desacople de los puertos mecánicos y roscas M20 de transferencia[span_2](start_span)[span_2](end_span)
    Arm.actuateValves(M20_PORT_LOCK, UNLOCK);
    
    // 3. Sujeción del tirador táctico quick-release (80x30 mm)[span_3](start_span)[span_3](end_span)
    Arm.closeGripper(HANDLE_80X30_MM);
    
    // 4. Extracción lineal del cartucho agotado a lo largo del eje de 448 mm[span_4](start_span)[span_4](end_span)
    Arm.linearRetract(448.0, 20.0); // mm
    
    // 5. Ciclo de intercambio: Desechar unidad oxidada y posicionar nueva celda Al-Air (5.0 kg)[span_5](start_span)[span_5](end_span)
    Arm.swapCartridgeBay(SLOT_FRESH_UNIT);
}
