# CMOS Buffer Energy-Delay Optimization

This project focuses on the design and optimization of a **three-stage CMOS buffer** driving a capacitive load $C_L = 50 \cdot C_{in}$. The goal is to identify the **Pareto Frontier** in the Energy-Delay design space through technological characterization, Monte Carlo simulations, and sensitivity analysis.

---

## 📌 Project Overview
The optimization process is divided into three main phases:
1. **Technological Characterization:** Extraction of electrical and timing parameters ($C_{in}$, $\gamma_E$, $\tau_0$, $\gamma_D$) from a 100nm CMOS reference inverter.
2. **Design Space Exploration:** A 10,000-run Monte Carlo simulation to analyze the impact of stage sizing ($X_1, X_2$) on energy consumption and propagation delay.
3. **Pareto Optimization:** Use of MATLAB's `fmincon` to find the optimal stage sizes that minimize energy for a given delay constraint.



## 🛠 1. Technological Characterization
An initial characterization of a balanced inverter ($W_p = 0.2 \mu m$, $W_n = 0.12 \mu m$) was performed to equalize switching times. The following fundamental parameters were extracted:

| Parameter | Symbol | Value |
| :--- | :---: | :--- |
| Input Capacitance | $C_{in}$ | 0.73 fF |
| Energy Factor | $\gamma_E$ | 0.825 |
| Intrinsic Delay | $\tau_0$ | 7.92 ps |
| Delay Coefficient | $\gamma_D$ | 0.627 |

## 📊 2. Monte Carlo & Design Space
A statistical simulation of **10,000 runs** was executed by varying the sizing factors $X_1$ and $X_2$ using the `mc(value, tolerance)` directive with a 75% variation. 

The resulting cloud plot reveals the **Pareto Frontier**, representing the maximum efficiency limit: for any point on this curve, it is impossible to reduce the delay without increasing energy dissipation.



## 🚀 3. Analytical Optimization & Validation
The optimal stage sizes were calculated by minimizing the energy function subject to non-linear delay constraints using the **Elmore delay model**:

$$t_p = \tau_0 \left( 1 + \frac{f}{\gamma_D} \right)$$

### Optimization Results (MATLAB vs. Spice)
| Target Delay $D_0$ [ps] | $X_1$ (Opt.) | $X_2$ (Opt.) | Spice Delay [ps] | Energy [fJ] |
| :---: | :---: | :---: | :---: | :---: |
| 150 | 3.69 | 13.60 | 162 | 58.5 |
| 200 | 1.67 | 5.60 | 189 | 40.3 |
| 250 | 1.04 | 3.78 | 234 | 37.2 |

The results demonstrate an excellent correlation between the analytical model and Spice simulations, validating the fitting techniques used.

---

## 📂 Repository Structure
* `/simulations`: LTspice schematics (`.asc`) and technology model files.
* `/docs`: Model

## ⚙️ Tools
* **LTspice**: Circuit simulation and parameter extraction.
* **MATLAB**: Numerical optimization and data visualization.

**Author:** Raffaele Petrolo
