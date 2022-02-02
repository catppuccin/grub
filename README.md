<h3 align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/dev/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/dev/assets/misc/transparent.png" height="30" width="0px"/>
	Catppuccin for Grub
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/dev/assets/misc/transparent.png" height="30" width="0px"/>
</h3>
<p align="center">
    <a href="https://github.com/elkrien/catppuccin-grub/stargazers"><img src="https://img.shields.io/github/stars/elkrien/catppuccin-grub?colorA=1e1e28&colorB=c9cbff&style=for-the-badge&logo=starship style=for-the-badge"></a>
    <a href="https://github.com/elkrien/catppuccin-grub/issues"><img src="https://img.shields.io/github/issues/elkrien/catppuccin-grub?colorA=1e1e28&colorB=f7be95&style=for-the-badge"></a>
    <a href="https://github.com/elkrien/catppuccin-grub/contributors"><img src="https://img.shields.io/github/contributors/elkrien/catppuccin-grub?colorA=1e1e28&colorB=b1e1a6&style=for-the-badge"></a>
</p>


<p align="center">
  <a href="https://raw.githubusercontent.com/elkrien/catppuccin-grub/assets/cat-grub.png"><img src="https://github.com/elkrien/catppuccin-grub/raw/main/assets/cat-grub-preview.png"></a>
</p>

## Usage

1. Clone this repository locally
2. Copy `catppuccin-grub-theme` folder to `/usr/share/grub/themes/`, e.g. :
   
   ```shell
   sudo cp -r catppuccin-grub-theme /usr/share/grub/themes/
   ```
3. Uncomment and edit following line in `/etc/default/grub` to :
   
   ```shell
   GRUB_THEME="/usr/share/grub/themes/catppuccin-grub-theme/theme.txt"
   ```
4. Update grub :
   
   ```shell
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

## 🙋 FAQ

- Q: **_"My Grub is not working in my screen resolution"_**
  
  A: 
  - Uncomment and edit following line in `/etc/default/grub` (modify `1920x1080` to your's screen resolution) : 
  
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
  
## 💝 Thanks to

- [vinceliuice](https://github.com/vinceliuice/grub2-themes)
- [dracula](https://github.com/dracula/grub)

