#! /usr/bin/env bash

# Exit Immediately if a command fails
set -o errexit

readonly ROOT_UID=0
readonly Project_Name="GRUB2::THEMES"
readonly MAX_DELAY=20 # max delay for user to enter root password
tui_root_login=

THEME_DIR="/usr/share/grub/themes"
REO_DIR="$(cd $(dirname $0) && pwd)"

THEME_VARIANTS=('tela' 'vimix' 'stylish' 'whitesur')
ICON_VARIANTS=('color' 'white' 'whitesur')
SCREEN_VARIANTS=('1080p' '2k' '4k' 'ultrawide' 'ultrawide2k')

print() {
    case "$1" in
    -e | --error)
		printf "($(date +"%H:%M:%S") \e[1;31mERROR\e[0m) %s\n" "${2}"
        ;;
    -w | --warning)
		printf "($(date +"%H:%M:%S") \e[0;33mWARNING\e[0m) %s\n" "${2}"
        ;;
    -s | --success)
		printf "($(date +"%H:%M:%S") \e[0;32mSUCCESS\e[0m) %s\n" "${2}"
        ;;
    *)
		printf "($(date +"%H:%M:%S") \e[0;34mINFO\e[0m) %s\n" "${1}" # default is LOG_INFO
        ;;
    esac
}


# Check command availability
function has_command() {
    command -v $1 &>/dev/null #with "&>", all output will be redirected.
}

usage() {
    printf "%s\n" "Usage: ${0##*/} [OPTIONS...]"
    printf "\n%s\n" "OPTIONS:"
    printf "  %-25s%s\n" "-b, --boot" "install grub theme into /boot/grub/themes"
    printf "  %-25s%s\n" "-t, --theme" "theme variant(s) [tela|vimix|stylish|whitesur] (default is tela)"
    printf "  %-25s%s\n" "-i, --icon" "icon variant(s) [color|white|whitesur] (default is color)"
    printf "  %-25s%s\n" "-s, --screen" "screen display variant(s) [1080p|2k|4k|ultrawide|ultrawide2k] (default is 1080p)"
    printf "  %-25s%s\n" "-r, --remove" "Remove theme (must add theme name option)"
    printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
    local theme=${1}
    local icon=${2}
    local screen=${3}

    # Check for root access and proceed if it is present
    if [[ "$UID" -eq "$ROOT_UID" ]]; then

        # Make a themes directory if it doesn't exist
        print -s "\n Checking for the existence of themes directory..."

        [[ -d "${THEME_DIR}/${theme}" ]] && rm -rf "${THEME_DIR}/${theme}"
        mkdir -p "${THEME_DIR}/${theme}"

        # Copy theme
        print -s "\n Installing ${theme} ${icon} ${screen} theme..."

        # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
        cp -a --no-preserve=ownership "${REO_DIR}/common/"{*.png,*.pf2} "${THEME_DIR}/${theme}"
        cp -a --no-preserve=ownership "${REO_DIR}/config/theme-${screen}.txt" "${THEME_DIR}/${theme}/theme.txt"
        cp -a --no-preserve=ownership "${REO_DIR}/backgrounds/${screen}/background-${theme}.jpg" "${THEME_DIR}/${theme}/background.jpg"

        # Use custom background.jpg as grub background image
        if [[ -f "${REO_DIR}/background.jpg" ]]; then
            print -w "\n Using custom background.jpg as grub background image..."
            cp -a --no-preserve=ownership "${REO_DIR}/background.jpg" "${THEME_DIR}/${theme}/background.jpg"
            convert -auto-orient "${THEME_DIR}/${theme}/background.jpg" "${THEME_DIR}/${theme}/background.jpg"
        fi

        if [[ ${screen} == 'ultrawide' ]]; then
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-${icon}/icons-1080p" "${THEME_DIR}/${theme}/icons"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-select/select-1080p/"*.png "${THEME_DIR}/${theme}"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/info-1080p.png" "${THEME_DIR}/${theme}/info.png"
        elif [[ ${screen} == 'ultrawide2k' ]]; then
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-${icon}/icons-2k" "${THEME_DIR}/${theme}/icons"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-select/select-2k/"*.png "${THEME_DIR}/${theme}"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/info-2k.png" "${THEME_DIR}/${theme}/info.png"
        else
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-${icon}/icons-${screen}" "${THEME_DIR}/${theme}/icons"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-select/select-${screen}/"*.png "${THEME_DIR}/${theme}"
            cp -a --no-preserve=ownership "${REO_DIR}/assets/info-${screen}.png" "${THEME_DIR}/${theme}/info.png"
        fi

        # Set theme
        print -s "\n Setting ${theme} as default..."

        # Backup grub config
        cp -an /etc/default/grub /etc/default/grub.bak

        # Fedora workaround to fix the missing unicode.pf2 file (tested on fedora 34): https://bugzilla.redhat.com/show_bug.cgi?id=1739762
        # This occurs when we add a theme on grub2 with Fedora.
        if has_command dnf; then
            if [[ -f "/boot/grub2/fonts/unicode.pf2" ]]; then
                if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
                    #Replace GRUB_FONT
                    sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/grub2/fonts/unicode.pf2|" /etc/default/grub
                else
                    #Append GRUB_FONT
                    echo "GRUB_FONT=/boot/grub2/fonts/unicode.pf2" >>/etc/default/grub
                fi
            elif [[ -f "/boot/efi/EFI/fedora/fonts/unicode.pf2" ]]; then
                if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
                    #Replace GRUB_FONT
                    sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2|" /etc/default/grub
                else
                    #Append GRUB_FONT
                    echo "GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2" >>/etc/default/grub
                fi
            fi
        fi

        if grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null; then
            #Replace GRUB_THEME
            sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"|" /etc/default/grub
        else
            #Append GRUB_THEME
            echo "GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"" >>/etc/default/grub
        fi

        # Make sure the right resolution for grub is set
        if [[ ${screen} == '1080p' ]]; then
            gfxmode="GRUB_GFXMODE=1920x1080,auto"
        elif [[ ${screen} == 'ultrawide' ]]; then
            gfxmode="GRUB_GFXMODE=2560x1080,auto"
        elif [[ ${screen} == '4k' ]]; then
            gfxmode="GRUB_GFXMODE=3840x2160,auto"
        elif [[ ${screen} == '2k' ]]; then
            gfxmode="GRUB_GFXMODE=2560x1440,auto"
        elif [[ ${screen} == 'ultrawide2k' ]]; then
            gfxmode="GRUB_GFXMODE=3440x1440,auto"
        fi

        if grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null; then
            #Replace GRUB_GFXMODE
            sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub
        else
            #Append GRUB_GFXMODE
            echo "${gfxmode}" >>/etc/default/grub
        fi

        if grep "GRUB_TERMINAL=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
            #Replace GRUB_TERMINAL
            sed -i "s|.*GRUB_TERMINAL=.*|#GRUB_TERMINAL=console|" /etc/default/grub
        fi

        if grep "GRUB_TERMINAL_OUTPUT=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL_OUTPUT=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
            #Replace GRUB_TERMINAL_OUTPUT
            sed -i "s|.*GRUB_TERMINAL_OUTPUT=.*|#GRUB_TERMINAL_OUTPUT=console|" /etc/default/grub
        fi

        # For Kali linux
        if [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then
            cp -an /etc/default/grub.d/kali-themes.cfg /etc/default/grub.d/kali-themes.cfg.bak
            sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub.d/kali-themes.cfg
            sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"|" /etc/default/grub.d/kali-themes.cfg
        fi

        # Update grub config
        print -s "\n Updating grub config...\n"
        updating_grub
        print -w "\n * At the next restart of your computer you will see your new Grub theme: '$theme' "

    #Check if password is cached (if cache timestamp has not expired yet)
    elif sudo -n true 2>/dev/null && echo; then #No need for "$?" ==> https://github.com/koalaman/shellcheck/wiki/SC2181
        sudo "$0" -t ${theme} -i ${icon} -s ${screen}
    else

        #Ask for password
        if [[ -n ${tui_root_login} ]]; then
            if [[ -n "${theme}" && -n "${screen}" ]]; then
                sudo -S $0 -t ${theme} -i ${icon} -s ${screen} <<<${tui_root_login}
            fi
        else

            print -e "\n [ Error! ] -> Run me as root! "
            read -r -p " [ Trusted ] Specify the root password : " -t ${MAX_DELAY} -s

            if sudo -S echo <<<$REPLY 2>/dev/null && echo; then

                #Correct password, use with sudo's stdin
                sudo -S "$0" -t ${theme} -i ${icon} -s ${screen} <<<${REPLY}
            else

                #block for 3 seconds before allowing another attempt
                sleep 3
                print -e "\n [ Error! ] -> Incorrect password!\n"
                exit 1
            fi
        fi
    fi
}

operation_canceled() {
    clear
    print -i "\n Operation canceled by user, Bye!"
    exit 1
}

updating_grub() {
    if has_command update-grub; then
        update-grub
    elif has_command grub-mkconfig; then
        grub-mkconfig -o /boot/grub/grub.cfg
    elif has_command zypper; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
        if [[ -f /boot/efi/EFI/fedora/grub.cfg ]]; then
            print -i "Find config file on /boot/efi/EFI/fedora/grub.cfg ...\n"
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
        fi
        if [[ -f /boot/grub2/grub.cfg ]]; then
            print -i "Find config file on /boot/grub2/grub.cfg ...\n"
            grub2-mkconfig -o /boot/grub2/grub.cfg
        fi
    fi

    # Success message
    print -s "\n * All done!"
}

function install_program() {
    if has_command zypper; then
        zypper in "$@"
    elif has_command apt-get; then
        apt-get install "$@"
    elif has_command dnf; then
        dnf install -y "$@"
    elif has_command yum; then
        yum install "$@"
    elif has_command pacman; then
        pacman -S --noconfirm "$@"
    fi
}

remove() {
    local theme=${1}

    # Check for root access and proceed if it is present
    if [ "$UID" -eq "$ROOT_UID" ]; then

        echo -e "\n Checking for the existence of themes directory..."
        if [[ -d "${THEME_DIR}/${theme}" ]]; then
            rm -rf "${THEME_DIR}/${theme}"
        else
            print -e "\n Specified ${theme} theme does not exist!"
            exit 0
        fi

        local grub_config_location=""
        if [[ -f "/etc/default/grub" ]]; then

            grub_config_location="/etc/default/grub"
        elif [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then

            grub_config_location="/etc/default/grub.d/kali-themes.cfg"
        else

            print -e "\nCannot find grub config file in default locations!"
            print -e "\nPlease inform the developers by opening an issue on github."
            print -e "\nExiting..."
            exit 1
        fi

        local current_theme="" # Declaration and assignment should be done seperately ==> https://github.com/koalaman/shellcheck/wiki/SC2155
        current_theme="$(grep 'GRUB_THEME=' $grub_config_location | grep -v \#)"
        if [[ -n "$current_theme" ]]; then

            # Backup with --in-place option to grub.bak within the same directory; then remove the current theme.
            sed --in-place='.bak' "s|$current_theme|#GRUB_THEME=|" "$grub_config_location"

            # Update grub config
            print -s "\n Resetting grub theme...\n"
            updating_grub
        else

            print -e "\nNo active theme found."
            print -e "\nExiting..."
            exit 1
        fi

    else
        #Check if password is cached (if cache timestamp not expired yet)
        if sudo -n true 2>/dev/null && echo; then
            #No need to ask for password
            sudo "$0" "${PROG_ARGS[@]}"
        else
            #Ask for password
            print -e "\n [ Error! ] -> Run me as root! "
            read -r -p " [ Trusted ] Specify the root password : " -t ${MAX_DELAY} -s #when using "read" command, "-r" option must be supplied ==> https://github.com/koalaman/shellcheck/wiki/SC2162

            if sudo -S echo <<<$REPLY 2>/dev/null && echo; then
                #Correct password, use with sudo's stdin
                sudo -S "$0" "${PROG_ARGS[@]}" <<<$REPLY
            else
                #block for 3 seconds before allowing another attempt
                sleep 3
                print -e "\n [ Error! ] -> Incorrect password!\n"
                exit 1
            fi
        fi
    fi
}

arg_parser() {
	while [[ $# -gt 0 ]]; do
		PROG_ARGS+=("${1}")
		dialog='false'
		case "${1}" in
		-b | --boot)
			THEME_DIR="/boot/grub/themes"
			shift 1
			;;
		-r | --remove)
			remove='true'
			shift 1
			;;
		-t | --theme)
			shift
			for theme in "${@}"; do
				case "${theme}" in
				tela)
					themes+=("${THEME_VARIANTS[0]}")
					shift
					;;
				vimix)
					themes+=("${THEME_VARIANTS[1]}")
					shift
					;;
				stylish)
					themes+=("${THEME_VARIANTS[2]}")
					shift
					;;
				whitesur)
					themes+=("${THEME_VARIANTS[3]}")
					shift
					;;
				-*) # "-*" overrides "--*"
					break
					;;
				*)
					print -e "Unrecognized theme variant '$1'."
					print -i "Try '$0 --help' for more information."
					exit 1
					;;
				esac
			done
			;;
		-i | --icon)
			shift
			for icon in "${@}"; do
				case "${icon}" in
				color)
					icons+=("${ICON_VARIANTS[0]}")
					shift
					;;
				white)
					icons+=("${ICON_VARIANTS[1]}")
					shift
					;;
				whitesur)
					icons+=("${ICON_VARIANTS[2]}")
					shift
					;;
				-*)
					break
					;;
				*)
					print -e "ERROR: Unrecognized icon variant '$1'."
					print -i "Try '$0 --help' for more information."
					exit 1
					;;
				esac
			done
			;;
		-s | --screen)
			shift
			for screen in "${@}"; do
				case "${screen}" in
				1080p)
					screens+=("${SCREEN_VARIANTS[0]}")
					shift
					;;
				2k)
					screens+=("${SCREEN_VARIANTS[1]}")
					shift
					;;
				4k)
					screens+=("${SCREEN_VARIANTS[2]}")
					shift
					;;
				ultrawide)
					screens+=("${SCREEN_VARIANTS[3]}")
					shift
					;;
				ultrawide2k)
					screens+=("${SCREEN_VARIANTS[4]}")
					shift
					;;
				-*)
					break
					;;
				*)
					print -e "ERROR: Unrecognized icon variant '$1'."
					print -i "Try '$0 --help' for more information."
					exit 1
					;;
				esac
			done
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			print -e "Unrecognized installation option '$1'."
			print -i "Try '$0 --help' for more information."
			exit 1
			;;
		esac
	done
}


main() {
	parse_args "${@}"

    if [[ "${remove:-}" != 'true' ]]; then
        for theme in "${themes[@]-${THEME_VARIANTS[0]}}"; do
            for icon in "${icons[@]-${ICON_VARIANTS[0]}}"; do
                for screen in "${screens[@]-${SCREEN_VARIANTS[0]}}"; do
                    install "${theme}" "${icon}" "${screen}"
                done
            done
        done
    elif [[ "${remove:-}" == 'true' ]]; then
        for theme in "${themes[@]-${THEME_VARIANTS[0]}}"; do
            remove "${theme}"
        done
    fi
}

main "${@}"
