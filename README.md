<h3 align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
	Catppuccin for <a href="https://www.gnu.org/software/grub/">Grub</a>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>
<p align="center">
    <a href="https://github.com/catppuccin/grub/stargazers"><img alt="Stargazers" src="https://img.shields.io/github/stars/catppuccin/grub?style=for-the-badge&color=B4BEFE&logoColor=CDD6F4&labelColor=363a4f"></a>
    <a href="https://github.com/catppuccin/grub/issues"><img src="https://img.shields.io/github/issues/catppuccin/grub?colorA=363a4f&colorB=FAB387&style=for-the-badge"></a>
    <a href="https://github.com/catppuccin/grub/contributors"><img src="https://img.shields.io/github/contributors/catppuccin/grub?colorA=363a4f&colorB=A6E3A1&style=for-the-badge"></a>
</p>


<p align="center">
  <img src="assets/cat-grub.png"/>
</p>

## Usage

1. Clone this repository locally and enter the cloned folder:
   
   ```shell
   git clone https://github.com/catppuccin/grub.git && cd grub
   ```

2. Copy all or selected theme from `src` folder to `/usr/share/grub/themes/`, for example to copy all themes use:
   
   ```shell
   sudo cp -r src/* /usr/share/grub/themes/
   ```
3. Uncomment and edit following line in `/etc/default/grub` to selected theme:
    - 🌻 Catppuccin-latte:
   
      ```shell
      GRUB_THEME="/usr/share/grub/themes/catppuccin-latte-grub-theme/theme.txt"
      ```
    - 🪴 Catppuccin-frappe:
   
      ```shell
      GRUB_THEME="/usr/share/grub/themes/catppuccin-frappe-grub-theme/theme.txt"
      ```
    - 🌺 Catppuccin-macchiato:
   
      ```shell
      GRUB_THEME="/usr/share/grub/themes/catppuccin-macchiato-grub-theme/theme.txt"
      ```
    - 🌿 Catppuccin-mocha:
   
      ```shell
      GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
      ```

4. Update grub:
   
   ```shell
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

## 🙋 FAQ

- Q: **_"My Grub is not working in my screen resolution"_**
  
  A: 
  - Uncomment and edit following line in `/etc/default/grub` (modify `1920x1080` to Your screen resolution): 
  
     ```shell
     GRUB_GFXMODE=1920x1080
     ```
  - update grub (see point 4)
  
- Q: **_"My Grub is not detecting my all systems (dual-boot)"_**
  
  A: 
  - Make sure You have [os-prober](https://joeyh.name/code/os-prober/) installed
  
  - Add or uncomment following line in `/etc/default/grub` :
  
     ```shell
     GRUB_DISABLE_OS_PROBER=false
     ```
  - Save that file and update grub (see point 4)
  
- Q: **_"Grub isn't detecting the theme"_**

  A1: 
  - Make sure to **comment** the following line in `/etc/default/grub`:
  
     ```
     GRUB_TERMINAL_OUTPUT="console"
     ```
  - Save that file and update grub (see point 4)
  
  A2:
  - If A1 is not working try to replace `/usr/share/` with `/boot/` and repeat points (2-4)
  
## 💝 Thanks to

- [vinceliuice](https://github.com/vinceliuice/grub2-themes)
- [tuhanayim](https://github.com/tuhanayim)

&nbsp;

<p align="center"><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" /></p>
<p align="center">Copyright &copy; 2021-present <a href="https://github.com/catppuccin" target="_blank">Catppuccin Org</a>
<p align="center"><a href="https://github.com/catppuccin/catppuccin/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=CDD6F4&colorA=363a4f&colorB=B4BEFE"/></a></p>
