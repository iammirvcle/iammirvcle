
```markdown
# Azure Linux VM — Setup & Monitoring

Provisioned a **B1s** Ubuntu VM, enabled monitoring (platform metrics + VM Insights), and captured evidence.

---

## A) Create VM (Portal)
1. Go to **portal.azure.com** → **Create a resource** → **Virtual machine**.
2. **Basics**
   - **Resource group:** `rg-vm-lab` (reuse or create)
   - **Name:** `vm-lab-linux`
   - **Region:** your closest region
   - **Image:** *Ubuntu Server 22.04 LTS*
   - **Size:** **B1s** (free tier–eligible)
   - **Authentication type:** **SSH public key** (recommended) or **Password**
   - **Public inbound ports:** **None** (safer; monitoring still works)
3. **Disks / Networking:** defaults are fine.
4. **Management:**
   - **Boot diagnostics:** **Enable with managed storage account**
   - (Optional) **System-assigned managed identity:** On
5. **Monitoring:** leave default On; VM Insights will be enabled later.
6. **Review + create** → **Create**.

---

## B) Enable VM Insights
1. Open the VM → **Monitoring → Insights** → **Enable**.
2. If prompted, allow Azure to create/attach a **Log Analytics workspace**.
3. Wait until **Performance** and **Maps** tabs populate.

---

## C) (Optional) Allow SSH temporarily
If you want to generate CPU activity from inside the VM:
1. VM → **Networking** → **Add inbound port rule**
   - **Destination port ranges:** `22`
   - **Protocol:** TCP
   - **Action:** Allow
   - **Priority:** e.g., `300`
   - **Name:** `allow-ssh-temp`
2. From your computer:
```bash
ssh azureuser@<public-ip>

