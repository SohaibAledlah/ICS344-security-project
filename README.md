# ICS344-security-project
This repo contains the code used in 344 project for Team 7.
Mainly the code is a python code that is used in the third task of the project (custom script).
The python code automates the brute-force attack on the service as well as the honeypot.
Tow versions of the python code are provided. They are similar, the difference is that the python script
that targets the service includes establishing a session with the service (needed by the service).

Also, the .sh file is a code for the task in Phase4 (the bonus phase), it monitors the logs, generates alerts, and blocks IP adresses trying to brute-force.

Project commands cannot be shared as a code, they are used in the linux VMs, and so they are mentioned
in details in the project report.

## TTPs Used in Caldera
---
### Tactic: Initial Access

T1071.001: Application Layer Protocol: Web Shell (used for creating and managing web-based access)
T1071.002: Application Layer Protocol: HTTP/S (web traffic)

### Tactic: Execution

T1203: Exploitation for Client Execution (used to simulate exploitation of web-based vulnerabilities)

### Tactic: Persistence

T1071.001: Application Layer Protocol: Web Shell (may also allow persistence on the system)

### Tactic: Privilege Escalation

T1071.001: Application Layer Protocol: Web Shell (used to escalate privileges via web-based access)

### Tactic: Defense Evasion

T1070: Indicator Removal on Host (typically a technique used to clear traces from logs, used in Caldera if adapted for real-world attack simulation)
T1071.001: Application Layer Protocol: Web Shell (used for stealthy communication to evade detection mechanisms)

### Tactic: Credential Access

T1110: Brute Force (attempting multiple password combinations)

### Tactic: Discovery

T1087: Account Discovery (used for discovering user accounts within a system)

### Tactic: Lateral Movement

T1021: Remote Services (such as SSH or RDP, used to move laterally)

### Tactic: Exfiltration

T1041: Exfiltration Over Command and Control Channel (sending data over a communication channel)

### Tactic: Impact

T1486: Data Encrypted for Impact (used to simulate ransomware scenarios)
