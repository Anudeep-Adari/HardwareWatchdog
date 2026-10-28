<div align="center">

# 🐕 HardwareWatchdog

### Background Hardware Sentry, Thermal Throttling Monitor & Reliability Watchdog
**PowerShell 7+ • Python 3.10+ • WMI / CIM Sensor Interrogation • Structured JSON Telemetry**

<p align="center">
  <em>Lightweight, non-intrusive hardware sentinel monitoring thermal dissipation, core clock throttling, and memory saturation in real time.</em>
</p>

<!-- Badges -->
<p align="center">
  <a href="https://www.python.org/downloads/"><img src="https://img.shields.io/badge/Python-3.10%2B-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python 3.10+" /></a>
  <a href="https://learn.microsoft.com/en-us/powershell/"><img src="https://img.shields.io/badge/PowerShell-7%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="PowerShell" /></a>
  <a href="https://coderabbit.ai"><img src="https://img.shields.io/badge/CodeRabbit-AI_Reviewed-FF5C00?style=for-the-badge&logo=coderabbit&logoColor=white" alt="CodeRabbit" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" /></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Footprint-%3C_15MB_RAM-brightgreen?style=flat-square" />
  <img src="https://img.shields.io/badge/Logging-Structured_JSON-blueviolet?style=flat-square" />
  <img src="https://img.shields.io/badge/OS-Windows_11_%7C_10-0078D4?style=flat-square" />
</p>

---

</div>

## 📌 Architecture & Sentry Loop

```mermaid
flowchart TB
    %% Styling & Spacing
    classDef client fill:#161b22,stroke:#58a6ff,stroke-width:2px,color:#ffffff;
    classDef zone fill:#0d1117,stroke:#30363d,stroke-width:1.5px,color:#c9d1d9;
    classDef security fill:#161b22,stroke:#f85149,stroke-width:2px,color:#ffffff;
    classDef data fill:#161b22,stroke:#3fb950,stroke-width:2px,color:#ffffff;

    subgraph KernelSensors [" 🖥️ HARDWARE & SENSOR INTERROGATION TIER "]
        direction LR
        WMI["WMI / CIM Providers<br/><sub>Root\WMI & Root\CIMV2 Classes</sub>"]:::client
        PerfMon["Performance Counters<br/><sub>High-Resolution Hardware Timers</sub>"]:::client
    end

    subgraph Region1 [" 🔌 REGION 1: HARDWARE METRIC SAMPLING ZONE "]
        direction TB
        CPUThermal["CPU Thermals & Throttling<br/>• Package Temp & Thermal Decay<br/>• Core Clock Scaling & PROCHOT Flagger"]:::client
        RAMCommit["Memory Saturation Monitor<br/>• Committed Virtual Memory Rate<br/>• Available Physical RAM Depletion"]:::client
        StorageIO["Storage S.M.A.R.T. Sentry<br/>• Disk Read/Write Active Time<br/>• IOPS Wait Queue Depth"]:::client
    end

    subgraph Region2 [" 🧠 REGION 2: THRESHOLD & ANOMALY ENGINE "]
        direction TB
        ConfigRules["Rule Matrix (config.json)<br/>• Critical Temperature Limits (85°C)<br/>• Memory Pressure Watermarks"]:::client
        Evaluator["Anomaly Evaluator<br/>• Delta Velocity Calculation<br/>• Sustained Load Threshold Detector"]:::security
    end

    subgraph CentralTransit [" ⚙️ CENTRAL TRANSIT: DUAL RUNTIME GATEWAY "]
        direction TB
        PyEngine["Python Runtime (hardware_watchdog.py)<br/><sub>Structured Async Sampling Daemon</sub>"]:::client
        PSEngine["PowerShell Sentry (Invoke-HardwareWatchdog.ps1)<br/><sub>Native Windows Zero-Dependency Runner</sub>"]:::client
    end

    subgraph OutputPlane [" 📊 TELEMETRY PERSISTENCE & ALERTING PLANE "]
        direction LR
        LogStore[("Structured JSON Log<br/>telemetry_log.json Ledger")]:::data
        AlertConsole["System Alerts & Event Logs<br/><sub>Windows Event Log (ID 1001/41) & Console</sub>"]:::data
    end

    %% Spacious Architectural Connections
    WMI --------------> CPUThermal
    WMI --------------> RAMCommit
    PerfMon ----------> StorageIO

    CPUThermal -------> Evaluator
    RAMCommit --------> Evaluator
    StorageIO --------> Evaluator
    ConfigRules ------> Evaluator

    Evaluator --------> PyEngine
    Evaluator --------> PSEngine

    PyEngine ---------> LogStore
    PSEngine ---------> AlertConsole
```

---

## ⚡ Key Capabilities

* **Dual Engine Architecture:** Runs either natively via Python (`hardware_watchdog.py`) or as a standalone zero-dependency PowerShell script (`Invoke-HardwareWatchdog.ps1`).
* **Thermal Throttling Protection:** Immediately flags CPU frequency throttling and thermal breaches before system instabilities occur.
* **Low Impact Operation:** Designed for 24/7 background monitoring with zero measurable performance degradation.

---

## 🖥️ Live Telemetry Preview

```
================================================================================
  HardwareWatchdog Sentry ─ [MONITORING ACTIVE]
================================================================================
  [SAMPLE RATE] 5s  │  [LOG DESTINATION] telemetry_log.json
--------------------------------------------------------------------------------
  [23:59:10] CPU: 42°C (Optimal) │ Core Clock: 4.80 GHz │ Load: 18%
  [23:59:15] RAM: 48% (15.4 / 32.0 GB) │ Memory Pressure: Normal
  [23:59:20] NVMe: 38°C │ Active Time: 3% │ SMART State: HEALTHY
================================================================================
```

---

## 🚀 Quickstart

```powershell
# Clone the repository
git clone https://github.com/Anudeep-Adari/HardwareWatchdog.git
cd HardwareWatchdog

# Option A: Run via Python
pip install psutil
python hardware_watchdog.py

# Option B: Run natively via PowerShell
.\Invoke-HardwareWatchdog.ps1
```

---

<div align="center">

Crafted with high engineering precision by **[Anudeep Adari](https://github.com/Anudeep-Adari)**  
Continuous AI Code Reviews powered by **CodeRabbit**

</div>

