# Analog-PI-controlled-buck-Converter
# ⚡ Analog PI Controlled Buck Converter on FPGA

## 📌 Overview
This project implements a closed-loop DC-DC buck converter regulated using a PI (Proportional-Integral) controller on an FPGA. The system maintains a stable output voltage under varying input and load conditions by dynamically adjusting the PWM duty cycle.

The controller mimics analog PI behavior but is implemented digitally using Verilog on FPGA hardware.

---

## 🚀 Features
- Closed-loop voltage regulation
- FPGA-based digital PI controller
- PWM generation for switching control
- Real-time feedback processing
- Stable operation under disturbances
- Modular Verilog design

---

## 🧠 System Architecture

1. **Buck Converter (Power Stage)**
   - Steps down DC voltage using MOSFET switching
   - Components: MOSFET, diode, inductor, capacitor

2. **Voltage Sensing**
   - Output voltage is scaled and fed to ADC

3. **ADC Interface**
   - Converts analog voltage to digital signal

4. **PI Controller (FPGA)**
   - Computes error: `e = Vref - Vout`
   - Applies PI control:
     ```
     u[n] = Kp * e[n] + Ki * Σe[n]
     ```

5. **PWM Generator**
   - Converts control signal into duty cycle
   - Drives MOSFET switching

---

## ⚙️ Implementation Details

| Module            | Description                          |
|------------------|--------------------------------------|
| pi_controller.v  | Implements PI control logic          |
| pwm_generator.v  | Generates PWM signal                 |
| adc_interface.v  | Handles ADC input                    |
| top_module.v     | Integrates all modules               |

- Language: Verilog
- Platform: FPGA (Spartan-7 / PYNQ Z2)
- Control Type: Discrete-time PI controller
- Arithmetic: Fixed-point implementation

---


## 🔧 Working Principle

1. Output voltage is sensed and fed to ADC  
2. FPGA computes error with respect to reference  
3. PI controller processes error  
4. Controller output determines PWM duty cycle  
5. PWM drives MOSFET switching  
6. Output voltage is regulated via feedback  

---

## 📈 Control Strategy

- **Proportional (Kp):** Improves response speed  
- **Integral (Ki):** Eliminates steady-state error  

Together, they ensure stable and accurate voltage regulation.

---

## ⚠️ Challenges

- Fixed-point precision and overflow handling  
- PI tuning (Kp, Ki selection)  
- Noise in ADC measurements  
- Timing synchronization between modules  
- Tradeoff between PWM resolution and switching frequency  

---

## 🧪 Results

- Stable regulated output voltage  
- Reduced steady-state error  
- Fast transient response  
- Robust under load variations  

---

## 🧩 Future Work

- Add derivative term (PID controller)  
- Adaptive/self-tuning control  
- Higher resolution ADC integration  
- Hardware optimization for ASIC/VLSI  
- Advanced digital compensation techniques  

---

## 🛠️ Requirements

- FPGA board (Spartan-7 / PYNQ Z2)
- Power stage components (MOSFET, inductor, capacitor, diode)
- ADC for voltage sensing
- Vivado / FPGA toolchain

---

## 🎯 Conclusion

This project demonstrates the implementation of a classical control system on FPGA hardware, combining power electronics and digital design. It highlights how analog control concepts can be effectively realized using digital logic for real-time applications.

---
