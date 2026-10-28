<div align="center">

# 🐕 HardwareWatchdog

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=26&duration=3000&pause=1000&color=2EA043&center=true&vCenter=true&width=620&lines=Autonomous+Hardware+Health+Telemetry;Real-Time+Thermal+%26+Clock+Throttling+Alerts;PowerShell+%2B+Python+Dual-Engine+Runtime;JSON-Journaled+System+Diagnostics" alt="Typing SVG" />
</p>

<p align="center">
  <strong>Lightweight Background Hardware Sentry, Thermal Throttling Monitor & System Reliability Watchdog</strong>
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
flowchart LR
    subgraph Polling ["⏱️ Telemetry Loop (hardware_watchdog.py)"]
        WMI["WMI / CIM Hardware Sensors"]
        CPU["CPU Thermals & Utilization"]
        RAM["RAM Commit & Standby"]
        Storage["Storage I/O Queues"]
    end

    subgraph Analyzer ["🧠 Threshold Evaluation Engine"]
        Rules["config.json Thresholds"]
        Evaluator["Anomaly & Throttle Detector"]
    end

    subgraph Actions ["🚀 Notification & Telemetry Logging"]
        Alert["Console & Event Log Alerts"]
        JSONLog[("Structured Telemetry Log\ntelemetry_log.json")]
    end

    Polling --> Evaluator
    Rules --> Evaluator
    Evaluator --> Alert
    Evaluator --> JSONLog
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
