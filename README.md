##Project-Report
https://drive.google.com/file/d/18vexKBdzoGaN8CIMzaQ4-NZs2poVH5wS/view?usp=drive_link

# Energy-Automation-PID-Building-Simulation
Occupancy-based lighting + PID HVAC temperature control with a 24-hour MATLAB/Octave simulation, energy (kWh) and cost reporting.

## Overview
This project simulates an automated energy management system designed to optimize building lighting and HVAC energy usage while maintaining comfort.
Lighting is enabled only during occupied hours, and HVAC power is controlled by a PID controller to regulate room temperature to a 22°C setpoint.

## What it demonstrates
- Building automation logic (occupancy-driven actuation)
- Feedback control (PID) applied to temperature regulation
- End-to-end reporting: hourly power traces, temperature trace, and daily energy/cost summary

## Model & parameters (from the script)
- Simulation horizon: 24 hours (hourly steps)
- Ambient temperature: 30°C
- Desired temperature: 22°C
- Lighting power: 100 W (max)
- HVAC power: up to 1500 W
- PID gains: Kp = 20, Ki = 5, Kd = 2
- Occupancy schedule: 24-element array (1 = occupied)

## Outputs
The script generates:
1) Occupancy vs time
2) Lighting power vs time
3) HVAC power + room temperature (dual-axis) with desired setpoint
4) Bar chart: lighting energy, HVAC energy, total energy

It also prints a daily energy report (kWh + cost estimate) in the console.

## How to run
### Option A: MATLAB
Run: `code/energy_automation_pid.m`

### Option B: GNU Octave (free alternative)
Octave syntax is largely compatible with MATLAB.
Run: `energy_automation_pid.m` from the `code/` folder.

## Repository structure
- `code/energy_automation_pid.m` — simulation + PID control + plots + energy report
- `report/Energy_Automation_Project.pdf` — full mini-project write-up
- `outputs/` — exported plots (add later)

## Extensions (ideas)
- Use smaller time steps (e.g., 1–5 minutes)
- Multi-zone thermal model (multiple rooms)
- Add disturbance models (door open, external heat gains)
- IoT pipeline (ESP32 sensors + MQTT + dashboard)
