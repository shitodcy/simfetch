# 🐧 simfetch

A simple, elegant, and highly customizable command-line system information tool written in bash. It displays system information beautifully next to your favorite image or a classic ASCII logo, right in your terminal.

## Preview

| ascii mode                              | image mode                      |
| -------------------------------------------------------------- | ---------------------------------------------------------------- |
|![image-1](https://github.com/shitodcy/simfetch/blob/main/image/simfetch-ascii.png)|![image-2](https://github.com/shitodcy/simfetch/blob/main/image/simfetch-image.png)|

## ✨ Features

  - **Elegant Layout:** Displays system information in a perfectly aligned, boxed table.
  - **Highly Customizable:** Easily change colors, icons, and labels through a simple config file.
  - **Flexible Visuals:** Supports both custom images (converted to ANSI art by `chafa`) and classic ASCII text logos.
  - **Smart Detection:** Automatically detects your Distro, Kernel, DE/WM, CPU, GPU, Shell, and more.
  - **Auto-Configuration:** Automatically generates a default, easy-to-edit config file on the first run.
  - **Fallback Logo:** If a custom image path is not found, it intelligently falls back to a built-in ASCII logo for your detected Linux distribution.

## 📋 Requirements

Before you begin, ensure you have the following dependencies installed:

  - **`bash`** v4.0+
  - **`chafa`**: For rendering images and ASCII art.
  - **`pciutils`**: Provides the `lspci` command for GPU detection.
  - A **Nerd Font**: Required for the icons to display correctly. Popular choices include [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads), [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads), etc.

You can typically install `chafa` and `pciutils` with your package manager:

```bash
# For Debian / Ubuntu
sudo apt update && sudo apt install chafa pciutils

# For Arch Linux
sudo pacman -S chafa pciutils
```

-----

## 🚀 Installation

Installing `simfetch` is easy. The installer script handles everything for you.

### 1\. Download the Scripts
```bash
git clone https://github.com/shitodcy/simfetch
cd simfetcb
```

### 2\. Run the Installer

Open your terminal, navigate to the directory where you saved the files, and run the installer:

```bash
bash install.sh
```

The installer will make the `simfetch` script executable and move it to `~/.local/bin/`, making it available as a system-wide command for your user.

### 3\. Final Step

Close and reopen your terminal to ensure your shell recognizes the new command. If the `simfetch` command is still not found, you may need to add the following line to your `~/.bashrc` or `~/.zshrc` file:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 💻 Usage

After a successful installation, simply open your terminal and type:

```bash
simfetch
```

The script will display your system information. Enjoy\!


-----

Of course. Here are those instructions reformatted into a GitHub README section in English.

-----

## ⚙️ Configuration

Converting ASCII to image is quite easy.

### 1. Open the Configuration File

Open a terminal and run the following command to edit the configuration file using the `nano` text editor:

```bash
nano ~/.local/bin/simfetch
```

-----

### 2. Change ASCII mode to image

Inside the editor, you will find the variable `DISPLAY_MODE="ascii"`. By default, this variable points to an ASCII logo file, but if you want to change it to an image, simply change it to something like this:

```bash
DISPLAY_MODE="image"
```

To display your custom image, simply change this path to the full absolute path of your image file. For example:

```bash
IMAGE_PATH="/home/jhon/Pictures/cat.png"
```

The `simfetch` script will automatically detect that the path points to the image and display it correctly.

-----

### 3. Save and Exit

Once you've edited the path, save the file and exit `nano` by following these steps:

1. Press **`Ctrl + X`** to exit.
2. Press **`Y`** to confirm that you want to save the changes.
3. Press **`Enter`** to confirm the filename.

Now, run the `simfetch` command again in your terminal. This command should immediately display your custom image instead of the ASCII logo.
