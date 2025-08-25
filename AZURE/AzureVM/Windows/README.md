# Azure Windows VM — Setup & Monitoring

Provisioned a Windows Server VM, enabled monitoring (platform metrics + VM Insights), and captured evidence.

---

## Step 1 Create VM (Portal)
1. Go to **portal.azure.com** → **Create a resource** → **Virtual machine**.
2. **Basics**
   - **Subscription: Free Trial 
   - **Resource group:** `rg-free-tier-lab` (Create new if needed)
   - **Name:** `vm-lab-win`
   - **Region:** your closest region (East US (check B1s availability))
   - **Image:** *Windows Server 2022 Datacenter: Azure Edition*
   - **Size:** **B1s** (free tier–eligible)
   - **Authentication type:** **Password** (set strong creds)
   - **Public inbound ports:** **None** (safer; monitoring still works)
4. **Disks / Networking:** Keep defaults → but disable Public IP if lab doesn’t require internet access (saves exposure).
5. **Management:**
   - **Boot diagnostics:** **Enable with managed storage account**
   - (Optional) **System-assigned managed identity:** On
6. **Monitoring:** leave default On; VM Insights will be enabled later.
7. **Review + create** → **Create**.

## Step 2 Enable VM Insights
1. Open the VM → **Monitoring → Insights** → **Enable**.
2. If prompted, allow Azure to create/attach a **Log Analytics workspace**.
3. Wait until **Performance** and **Maps** tabs populate.

## Step 3 (Optional) Allow RDP temporarily
If you want to generate CPU activity from inside the VM:
1. VM → **Networking** → **Add inbound port rule**
   - **Destination port ranges:** `3389`
   - **Protocol:** TCP
   - **Action:** Allow
   - **Priority:** e.g., `300`
   - **Name:** `allow-rdp-temp`
2. From your computer, RDP to the VM’s **Public IP**.
3. **After** you’re done, **remove** this inbound rule.

## 🔹 Step 4: Free Tier Optimization Tips
✅ Stick with Standard_B1s only.

✅ Use Linux instead of Windows — Windows eats more credits and storage.

✅ Choose East US or West US for better free SKU availability.

✅ Always attach the smallest disk (default 30 GB SSD is fine, free tier includes 64 GB).

✅ Shut down/delete VM when lab ends.
