# StrayCore Kernel Installer 🚀

**The definitive installer for the StrayCore Kernel - an ultimate gaming and development kernel built for performance excellence.**

![StrayCore Banner](https://i.imgur.com/ipMnMfl.png) 

---

## ✨ What is StrayCore?

StrayCore is a custom Linux kernel installer designed for **Arch-based systems**. It automates the entire process of downloading the latest stable kernel source, applying a suite of performance-oriented optimizations, and compiling it specifically for your hardware.

The result is a kernel fine-tuned for **maximum gaming performance, development speed, and system responsiveness**. The installer itself features a modern, interactive UI to make the process seamless and engaging.

## 🌟 Key Features

-   **Fully Automated:** Downloads, configures, compiles, and installs the kernel with a single command.
-   **Latest Stable Kernel:** Always fetches the most recent stable release from kernel.org.
-   **Performance-Tuned:** Applies critical optimizations out-of-the-box:
    -   **BBR** TCP congestion control for better networking.
    -   **BFQ** I/O scheduler for improved responsiveness.
    -   **Performance CPU Governor** set as default.
    -   Voluntary Preemption (`PREEMPT_VOLUNTARY`) for smoother desktop experience.
-   **Interactive Installer:** A modern, colorful UI with real-time compilation progress, module counters, and ETA.
-   **Hardware-Specific Configuration:** Uses `localmodconfig` to build a lean kernel tailored to your specific hardware.
-   **Smart Bootloader Configuration:** Automatically detects and configures **GRUB** and **systemd-boot**.
-   **RAM-Disk Compilation:** Automatically uses `/dev/shm` for compilation if enough free RAM is available, dramatically speeding up the process.
-   **Custom Tools Included:** Comes with a suite of tools to manage and monitor your new kernel.

## 🖥️ Prerequisites

-   An **Arch-based Linux distribution** (e.g., Arch Linux, Garuda Linux, EndeavourOS).
-   `sudo` privileges for the user running the script.
-   An active internet connection.
-   Required packages (`git`, `base-devel`, `curl`, etc.) will be installed automatically by the script.

## 🛠️ Installation

To install the StrayCore Kernel, simply run the following command in your terminal. This will download and execute the installer script.

```bash
curl -s https://raw.githubusercontent.com/StrayVibes/StrayCore-Kernel-Installer/main/install.sh | bash
```

The script will guide you through the process, checking your system, installing dependencies, and compiling the kernel.

## ⚙️ Post-Installation

After the script completes successfully:

1.  **Reboot** your system.
2.  At the bootloader menu, select **"StrayCore Kernel (Guardian Edition)"**.
3.  Log in and enjoy a more responsive and powerful system! You will be greeted by a new welcome message in your terminal.

##  dashboard Included Tools

StrayCore comes with a few handy commands to help you manage and monitor your system.

### `straycore`
Launch a custom, real-time system dashboard inspired by `htop`. It provides a live overview of your CPU, memory, disk usage, top processes, and active StrayCore optimizations.

-   **Live Refresh:** Updates every 1.5 seconds.
-   **Exit:** Press `q` to quit.

![StrayCore Dashboard](https://i.imgur.com/ipMnMfl.png)
<!-- You can replace this URL with a screenshot of your dashboard -->

### `straycore-update`
Check for and install the latest version of the StrayCore Kernel. This command re-runs the installer script, allowing you to easily upgrade whenever a new stable kernel is released.

### `straycore-optimize`
A background service that applies performance tweaks on every boot, ensuring your system is always running at its peak. This includes setting the CPU governor to `performance`, optimizing the I/O scheduler, and more.

## 🤝 Contributing

Contributions are welcome! If you have suggestions for new features, optimizations, or bug fixes, please feel free to open an issue or submit a pull request.

## 📜 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

---

*Developed with ❤️ by StrayVibes (Thomas Garau)*
