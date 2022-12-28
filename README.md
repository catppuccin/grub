<h3 align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
  Catppuccin for <a href="https://www.gnu.org/software/grub/">Grub</a>
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>
<p align="center">
  <a href="https://github.com/catppuccin/grub/stargazers"><img alt="Stargazers" src="https://img.shields.io/github/stars/catppuccin/grub?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
  <a href="https://github.com/catppuccin/grub/issues"><img src="https://img.shields.io/github/issues/catppuccin/grub?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
  <a href="https://github.com/catppuccin/grub/contributors"><img src="https://img.shields.io/github/contributors/catppuccin/grub?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/grub/main/assets/grub.png"/>
</p>

## Previews

<details>
<summary>🌻 Latte</summary>
  <img src="https://raw.githubusercontent.com/catppuccin/grub/main/assets/grub-latte.png"/>
</details>
<details>
<summary>🪴 Frappé</summary>
  <img src="https://raw.githubusercontent.com/catppuccin/grub/main/assets/grub-frappe.png"/>
</details>
<details>
<summary>🌺 Macchiato</summary>
  <img src="https://raw.githubusercontent.com/catppuccin/grub/main/assets/grub-macchiato.png"/>
</details>
<details>
<summary>🌿 Mocha</summary>
  <img src="https://raw.githubusercontent.com/catppuccin/grub/main/assets/grub-mocha.png"/>
</details>

## Usage

**1.** Clone this repository locally and enter the cloned folder:

```shell
git clone https://github.com/catppuccin/grub.git && cd grub
```

**2.** Copy all or selected theme from `src` folder to
`/usr/share/grub/themes/`, for example to copy all themes use:

```shell
sudo cp -r src/* /usr/share/grub/themes/
```

**3.** Uncomment and edit following line in `/etc/default/grub` to selected
theme:

🌻 Latte:

```shell
GRUB_THEME="/usr/share/grub/themes/catppuccin-latte-grub-theme/theme.txt"
```

🪴 Frappé:

```shell
GRUB_THEME="/usr/share/grub/themes/catppuccin-frappe-grub-theme/theme.txt"
```

🌺 Macchiato:

```shell
GRUB_THEME="/usr/share/grub/themes/catppuccin-macchiato-grub-theme/theme.txt"
```

🌿 Mocha:

```shell
GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
```

**4.** Update grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
For Fedora:
```shell
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

## 🙋 FAQ

**Q:** **_"My Grub is not working in my screen resolution"_**

**A:** Uncomment and edit following line in `/etc/default/grub` (modify
`1920x1080` to Your screen resolution):

```shell
GRUB_GFXMODE=1920x1080
```

Proceed to update grub (see step 4 of the installation)

**Q**: **_"My Grub is not detecting all my systems (dual-boot)"_**

**A:** Make sure you have `os-prober` installed.\
Add or uncomment following line in `/etc/default/grub` :

```shell
GRUB_DISABLE_OS_PROBER=false
```

Save that file and update grub (see step 4 of the installation)

**Q:** **_"Grub isn't detecting the theme"_**

**A:** Make sure to **comment** the following line in `/etc/default/grub`:

```
GRUB_TERMINAL_OUTPUT="console"
```

Save that file and update grub (step 4). If this did not work, try to replace
`/usr/share/` with `/boot/` and repeat installation steps 2-4.

## 💝 Thanks to

- [vinceliuice](https://github.com/vinceliuice/grub2-themes)
- [tuhanayim](https://github.com/tuhanayim)

&nbsp;

<p align="center"><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" /></p>
<p align="center">Copyright &copy; 2021-present <a href="https://github.com/catppuccin" target="_blank">Catppuccin Org</a>
<p align="center"><a href="https://github.com/catppuccin/catppuccin/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8"/></a></p>
