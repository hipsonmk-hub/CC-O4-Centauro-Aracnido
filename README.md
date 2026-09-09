# CC-O4-Centauro-Aracnido
Arquitectura robótica híbrida Centauro-Arácnido para exploración lunar/marciana
# PROYECTO CC-04: ARQUITECTURA ROBÓTICA CENTAURO-ARÁCNIDO

**Solución Híbrida para Estabilidad y Operaciones Autónomas en Superficies Extraplanetarias**

**Código de Clasificación:** CC-O4-2026  
**Ecosistema Objetivo:** Exploración Lunar y Marciana (Compatibilidad Starship)  
**Fecha de Emisión:** Junio de 2026  
**Desarrollador de Arquitectura:** David Dorado Blázquez Moraleda López

## 1. Resumen Ejecutivo

El presente documento define la arquitectura conceptual de la plataforma robótica híbrida **CC-O4 (Centauro-Arácnido)**, diseñada para superar las limitaciones de rovers de ruedas y bípedos en entornos de microgravedad y terreno irregular.

Integra:
- Base octópoda hiper-redundante para anclaje extremo
- Torso antropomórfico modular (compatible con Optimus)
- Ecosistema energético piezoeléctrico
- Refrigeración vascular por nanotubos
- Núcleo cognitivo Edge AI con protocolo de "Ancla Lógica"

## 2. Morfología Modular y Compatibilidad "Plug & Play"

- **Base Octópoda de Anclaje Dinámico**: Ocho extremidades simétricas radiales. Centro de gravedad ultra-bajo y tolerancia a fallos (redistribución automática de carga).
- **Torso Humanoide Superior (Modularidad Optimus)**: Plataforma desmontable que permite acoplar directamente un torso humanoide estándar, combinando movilidad todoterreno con destreza fina.

## 3. Subsistemas Termodinámicos y Materiales Avanzados

- **Sistema Vascular Termodinámico**: Refrigeración activa mediante bomba central y líquido iónico/galinstano circulando por capilares de nanotubos de carbono.
- **Blindaje**: Ópticas con Gorilla Glass aeroespacial y protección con mallas multicapa de Kevlar balístico.

## 4. Arquitectura Energética Descentralizada

- **Cosecha Piezoeléctrica Dinámica**: Transductores PVDF en articulaciones y almohadillas que convierten tensión mecánica en electricidad.
- **Carga Inalámbrica por Inducción**: Evita puertos físicos que se obstruirían con regolito.

## 5. Arquitectura Cognitiva de Borde (Edge AI)

- **Procesamiento Multimodal (Gemma 4)**: Coordinación perfecta entre las 8 patas y las manos.
- **Protocolo "Ancla Lógica" (🔱)**: En caso de sobrecarga de datos, suspende tareas secundarias y prioriza homeostasis térmica y fijación al terreno.

## 6. Roadmap y Protocolo de Pruebas Terrestres

- **Fase 1**: Simulación en análogo terrestre (Nodo Móstoles) – tracción asimétrica y cosecha piezoeléctrica.
- **Fase 2**: Simulación de sobrecarga cognitiva (estilo Tesla Dojo).
- **Fase 3**: Pruebas en cámara de vacío y despliegue lunar.

## 7. Matriz de Rendimiento Extraplanetario

| Morfología de Plataforma       | Estabilidad Cinética | Motricidad Fina | Tolerancia a Fallos | Autosuficiencia     | Adaptabilidad a Marte |
|-------------------------------|----------------------|-----------------|---------------------|---------------------|-----------------------|
| Rover de Ruedas Estándar      | Media                | Nula/Limitada   | Baja                | Baja                | Media                 |
| Bípedo Humanoide Puro         | Baja (microgravedad) | Alta            | Muy Baja            | Media               | Baja                  |
| **Centauro-Arácnido (CC-O4)** | **Excelente**        | **Alta**        | **Extrema**         | **Alta**            | **Alta**              |

---

**Imágenes y visuales del concepto** (incluye las que adjuntaste):
- Robot centauro-arácnido en superficie marciana
- Instalación de paneles solares
- Detalles mecánicos y close-ups
- 
Copyright (c) 2026 David Dorado Blázquez Moraleda López (@Hipsonmk)

This source describes Open Hardware and is licensed under the CERN-OHL-S v2.

You may redistribute and modify this source and make products using it under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE. Please see the CERN-OHL-S v2 for applicable conditions.

Source location: https://github.com/hipsonmk-hub/CC-O4-Centauro-Aracnido

As per CERN-OHL-S v2 section 4, should you produce hardware based on this source, you must maintain the Creator's attribution and provide access to the modifications under the same license.
## ⚙️ Arquitectura Paramétrica y Hardware Abierto

El núcleo mecánico de la plataforma CC-O4 está diseñado bajo un paradigma paramétrico en **OpenSCAD**, garantizando su replicabilidad y adaptabilidad para misiones terrestres (NEXUS SHELL) y aeroespaciales.

### Nodo de Articulación Principal (`cc_o4_joint_624zz.scad`)
El primer módulo liberado establece el estándar de tolerancia termomecánica para las extremidades del octópodo. 

*   **Material Especificado:** PETG-CF (Fibra de carbono). Impresión orientada en el eje Z local (eje de bisagra) para evitar delaminación bajo carga.
*   **Hardware COTS:** Utiliza rodamientos 624ZZ (4x13x5) ajustados a presión (tolerancia `bearing_od_fit = 0.20`).
*   **Diseño Antidesgaste:** Implementa un eje de vástago liso de 4mm, evitando la fricción de hilos de rosca contra la pista interior del rodamiento.
*   **Retención Mecánica:** Sistema de tuerca cautiva DIN 934 insertada bajo el cajeado del rodamiento superior, garantizando integridad frente a vibraciones extremas o ciclos térmicos.

## ⚖️ Autoría y Licencia

Este proyecto es Hardware Abierto. Toda la arquitectura, diseño conceptual (CC-O4 y variantes NEXUS), lógica de control termodinámico (Galinstano) y scripts paramétricos son propiedad intelectual de **David Dorado Blázquez Moraleda López (@Hipsonmk)**. 

Distribuido bajo la licencia fuertemente recíproca **CERN-OHL-S v2**. Cualquier bifurcación, uso comercial, desarrollo estatal o derivación técnica debe hacer pública su arquitectura modificada y atribuir la autoría original de forma visible.
