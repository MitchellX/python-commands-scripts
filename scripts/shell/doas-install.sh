#!/bin/bash

set -u

# If DOAS_UPDATE_ROOT is unset or empty, default it.
DOAS_SCM_REPO_NAME=${DOAS_SCM_REPO_NAME:-security/zti/doas}
DOAS_UPDATE_ROOT="${DOAS_UPDATE_ROOT:-https://tosv.byted.org/obj}"

DOAS_VALID_ENV_VARS=( "cn" "sg" "us" "i18n" "ttp" )
DOAS_VALID_TOS_ENV_VARS=( "cn" "sg" "us" "i18n" )

usage() {
    cat 1>&2 <<EOF
doas-install - install doas
The installer for doas

USAGE:
    doas-install [FLAGS] [OPTIONS]

FLAGS:
    -v, --verbose           Enable verbose output
    -q, --quiet             Disable progress output
    -y                      Disable confirmation prompt.
    -h, --help              Prints help information
    --scm                   Use SCM source to download doas

OPTIONS:
    -e, --env <>...         Runtime Environment (cn/us/i18n/ttp)
EOF
}


main() {
    downloader --check
    need_cmd uname
    need_cmd mktemp
    need_cmd chmod
    need_cmd mkdir
    need_cmd rm
    need_cmd rmdir
    need_cmd mv
    need_cmd cp

    get_architecture || return 1
    local _arch="$RETVAL"
    assert_nz "$_arch" "arch"
    local _result=${_env:-}
    local _version
    local _dir
    _dir="$(ensure mktemp -d)"
    local _file="${_dir}/doas"
    local _version_file="${_dir}/doas_version"
    local _doas_path

    local _ansi_escapes_are_valid=false
    if [ -t 2 ]; then
        if [ "${TERM+set}" = 'set' ]; then
            case "$TERM" in
                xterm*|rxvt*|urxvt*|linux*|vt*)
                    _ansi_escapes_are_valid=true
                ;;
            esac
        fi
    fi

    # check if we have to use /dev/tty to prompt the user
    local need_tty=yes
    # check if we only to use SCM download doas
    local only_scm=no
    local _env=${_env:-}
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                usage
                exit 0
                ;;
            -y)
                shift
                # user wants to skip the prompt -- we don't need /dev/tty
                need_tty=no
                ;;
            --scm)
                shift
                # user wants to use SCM to download doas
                only_scm=yes
                ;;
            -e|--env)
                shift
                _env="$1"
                if [[ ! " ${DOAS_VALID_ENV_VARS[*]} " =~ " ${_env} " ]]; then
                    echo "Invalid environment: ${_env}" >&2
                    exit 1
                fi
                ;;
            *)
                ;;
        esac
    done

    if $_ansi_escapes_are_valid; then
        printf "\33[1minfo:\33[0m detecting doas lastest version\n" 1>&2
    else
        printf '%s\n' 'info: detecting doas lastest version' 1>&2
    fi
    
    ensure mkdir -p "$_dir"

    if [ ! "$only_scm" = "yes" ]; then
        if $_ansi_escapes_are_valid; then
            printf "\33[1minfo:\33[0m downloading doas binary from TOS bucket\n" 1>&2
        else
            printf '%s\n' 'info: downloading doas binary from TOS bucket' 1>&2
        fi
        if tos_downloader "$_env" "$_version_file" "$_file" "$_arch"; then
            _result=1
        fi
        ignore rm "${_version_file}"
    fi

    if [[ -z "$_result" && $_arch = "linux-amd64" ]]; then
        if $_ansi_escapes_are_valid; then
            printf "\33[1minfo:\33[0m downloading doas binary from SCM\n" 1>&2
        else
            printf '%s\n' 'info: downloading doas binary from SCM' 1>&2
        fi
        if scm_downloader "$_env" "$_dir" "$_file" "$_arch"; then
            _result=1
        fi
    fi

    if [ -z "$_result" ]; then
        if $_ansi_escapes_are_valid; then
            printf "\33[1merror:\33[0m failed to download doas\n" 1>&2
        else
            printf '%s\n' 'error: failed to download doas' 1>&2
        fi
        exit 1
    fi

    ensure chmod u+x "$_file"
    case "$_arch" in

        *darwin*)
        if check_cmd xattr; then
            xattr -p com.apple.quarantine "${_file}" >/dev/null 2>&1
            status=$?
            if [ -z $status ]; then
                xattr -d com.apple.quarantine "${_file}"
            fi 
        else
            echo "warning: xattr not found, skipping com.apple.quarantine"
        fi
        ;;
    esac

    if [ ! -x "$_file" ]; then
        printf '%s\n' "Cannot execute $_file (likely because of mounting /tmp as noexec)." 1>&2
        printf '%s\n' "Please copy the file to a location where you can execute binaries and run ./doas install." 1>&2
        exit 1
    fi

    if [ "$need_tty" = "yes" ]; then
        # The installer is going to want to ask for confirmation by
        # reading stdin.  This script was piped into `sh` though and
        # doesn't have stdin to pass to its children. Instead we're going
        # to explicitly connect /dev/tty to the installer's stdin.
        if [ ! -t 1 ]; then
            err "Unable to run interactively. Run with -y to accept defaults, --help for additional options"
        fi

        ignore "$_file" install < /dev/tty
    else
        ignore "$_file" install
    fi

    local _retval=$?

    _doas_path=$(command -v doas)
    if [[ -z $_doas_path ]]; then
        cp -rf "$_file" "${PWD}/doas"
        if $_ansi_escapes_are_valid; then
            printf "\33[1mError:\33[0m No installation permission, please manually move doas from the current directory to \$PATH\n" 1>&2
        else
            printf '%s\n' "Error: No installation permission, please manually move doas from the current directory to \$PATH" 1>&2
        fi
    else
        if ! cmp_binary "$_file" "$_doas_path"; then
            cp -rf "$_file" "${PWD}/doas"
            if $_ansi_escapes_are_valid; then
                printf "\33[1mError:\33[0m No installation permission, please manually move doas from the current directory to \$PATH\n" 1>&2
            else
                printf '%s\n' "Error: No installation permission, please manually move doas from the current directory to \$PATH" 1>&2
            fi
        else
            if $_ansi_escapes_are_valid; then
                printf "\33[1minfo:\33[0m doas installed successfully, current path: %s\n" "$_doas_path" 1>&2
            else
                printf '%s\n' "info: doas installed successfully, current path: $_doas_path" 1>&2
            fi
        fi
    fi

    ignore rm "${_file}"
    ignore rmdir "$_dir"

    return "$_retval"
}

cmp_binary() {
    local _status
    _status=$(cmp --silent "$1" "$2"; echo $?)
    return "$_status"
}
# This is just for indicating that commands' results are being
# intentionally ignored. Usually, because it's being executed
# as part of error handling.
ignore() {
    "$@"
}

assert_nz() {
    if [ -z "$1" ]; then err "assert_nz $2"; fi
}

check_proc() {
    # Check for /proc by looking for the /proc/self/exe link
    # This is only run on Linux
    if ! test -L /proc/self/exe ; then
        err "fatal: Unable to find /proc/self/exe.  Is /proc mounted?  Installation cannot proceed without /proc."
    fi
}

get_bitness() {
    need_cmd head
    # Architecture detection without dependencies beyond coreutils.
    # ELF files start out "\x7fELF", and the following byte is
    #   0x01 for 32-bit and
    #   0x02 for 64-bit.
    # The printf builtin on some shells like dash only supports octal
    # escape sequences, so we use those.
    local _current_exe_head
    _current_exe_head=$(head -c 5 /proc/self/exe )
    if [ "$_current_exe_head" = "$(printf '\177ELF\001')" ]; then
        echo 32
    elif [ "$_current_exe_head" = "$(printf '\177ELF\002')" ]; then
        echo 64
    else
        err "unknown platform bitness"
    fi
}

is_host_amd64_elf() {
    need_cmd head
    need_cmd tail
    # ELF e_machine detection without dependencies beyond coreutils.
    # Two-byte field at offset 0x12 indicates the CPU,
    # but we're interested in it being 0x3E to indicate amd64, or not that.
    local _current_exe_machine
    _current_exe_machine=$(head -c 19 /proc/self/exe | tail -c 1)
    [ "$_current_exe_machine" = "$(printf '\076')" ]
}

say() {
    printf 'doas-install: %s\n' "$1"
}

err() {
    say "$1" >&2
    exit 1
}

need_cmd() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}


# This wraps curl or wget. Try curl first, if not installed,
# use wget instead.
downloader() {
    local _dld
    local _ciphersuites
    local _err
    local _status
    if check_cmd curl; then
        _dld=curl
    elif check_cmd wget; then
        _dld=wget
    else
        _dld='curl or wget' # to be used in error message of need_cmd
    fi

    if [ "$1" = --check ]; then
        need_cmd "$_dld"
    elif [ "$_dld" = curl ]; then
        get_ciphersuites_for_curl
        _ciphersuites="$RETVAL"
        if [ -n "$_ciphersuites" ]; then
            _err=$(curl --proto '=https' --tlsv1.2 --ciphers "$_ciphersuites" --silent --show-error --fail --location "$1" --output "$2" 2>&1)
            _status=$?
        else
            echo "Warning: Not enforcing strong cipher suites for TLS, this is potentially less secure"
            if ! check_help_for "$3" curl --proto --tlsv1.2; then
                echo "Warning: Not enforcing TLS v1.2, this is potentially less secure"
                _err=$(curl --silent --show-error --fail --location "$1" --output "$2" 2>&1)
                _status=$?
            else
                _err=$(curl --proto '=https' --tlsv1.2 --silent --show-error --fail --location "$1" --output "$2" 2>&1)
                _status=$?
            fi
        fi
        if [ -n "$_err" ]; then
            echo "$_err" >&2
            if echo "$_err" | grep -q 404$; then
                if [[ ! "$1" =~ "CURRENT_VERSION" ]]; then
                    err "installer for platform '$3' not found, this may be unsupported"
                fi
            fi
        fi
        return $_status
    elif [ "$_dld" = wget ]; then
        get_ciphersuites_for_wget
        _ciphersuites="$RETVAL"
        if [ -n "$_ciphersuites" ]; then
            _err=$(wget --https-only --secure-protocol=TLSv1_2 --ciphers "$_ciphersuites" "$1" -O "$2" 2>&1)
            _status=$?
        else
            echo "Warning: Not enforcing strong cipher suites for TLS, this is potentially less secure"
            if ! check_help_for "$3" wget --https-only --secure-protocol; then
                echo "Warning: Not enforcing TLS v1.2, this is potentially less secure"
                _err=$(wget "$1" -O "$2" 2>&1)
                _status=$?
            else
                _err=$(wget --https-only --secure-protocol=TLSv1_2 "$1" -O "$2" 2>&1)
                _status=$?
            fi
        fi
        if [ -n "$_err" ]; then
            echo "$_err" >&2
            if echo "$_err" | grep -q ' 404 Not Found$'; then
                if [[ ! "$1" =~ "CURRENT_VERSION" ]]; then
                    err "installer for platform '$3' not found, this may be unsupported"
                fi
            fi
        fi
        return $_status
    else
        err "Unknown downloader"   # should not reach here
    fi
}

check_help_for() {
    local _arch
    local _cmd
    local _arg
    _arch="$1"
    shift
    _cmd="$1"
    shift

    local _category
    if "$_cmd" --help | grep -q 'For all options use the manual or "--help all".'; then
      _category="all"
    else
      _category=""
    fi

    case "$_arch" in

        *darwin*)
        if check_cmd sw_vers; then
            case $(sw_vers -productVersion) in
                10.*)
                    # If we're running on macOS, older than 10.13, then we always
                    # fail to find these options to force fallback
                    if [ "$(sw_vers -productVersion | cut -d. -f2)" -lt 13 ]; then
                        # Older than 10.13
                        echo "Warning: Detected macOS platform older than 10.13"
                        return 1
                    fi
                    ;;
                11.*)
                    # We assume Big Sur will be OK for now
                    ;;
                *)
                    # Unknown product version, warn and continue
                    echo "Warning: Detected unknown macOS major version: $(sw_vers -productVersion)"
                    echo "Warning TLS capabilities detection may fail"
                    ;;
            esac
        fi
        ;;

    esac

    for _arg in "$@"; do
        if ! "$_cmd" --help "$_category" | grep -q -- "$_arg"; then
            return 1
        fi
    done

    true # not strictly needed
}

get_architecture() {
    local _ostype _cputype _bitness _arch
    _ostype="$(uname -s)"
    _cputype="$(uname -m)"

    if [ "$_ostype" = Darwin ] && [ "$_cputype" = i386 ]; then
        # Darwin `uname -m` lies
        if sysctl hw.optional.x86_64 | grep -q ': 1'; then
            _cputype=x86_64
        fi
    fi

    case "$_ostype" in

        Linux)
            check_proc
            _ostype=linux
            _bitness=$(get_bitness)
            ;;

        FreeBSD)
            _ostype=freebsd
            ;;

        Darwin)
            _ostype=darwin
            ;;

        MINGW* | MSYS* | CYGWIN*)
            _ostype=windows
            ;;

        *)
            err "unrecognized OS type: $_ostype"
            ;;

    esac

    case "$_cputype" in

        i386 | i486 | i686 | i786 | x86)
            _cputype=386
            ;;

        xscale | arm | armv6l)
            _cputype=arm
            ;;

        aarch64 | arm64)
            _cputype=arm64
            ;;

        x86_64 | x86-64 | x64 | amd64)
            _cputype=amd64
            ;;

        *)
            err "unsupported CPU type: $_cputype"

    esac

    _arch="${_ostype}-${_cputype}"

    RETVAL="$_arch"
}

# Return cipher suite string specified by user, otherwise return strong TLS 1.2-1.3 cipher suites
# if support by local tools is detected. Detection currently supports these wget backends: 
# GnuTLS and OpenSSL (possibly also LibreSSL and BoringSSL). Return value can be empty.
get_ciphersuites_for_wget() {
    if [ -n "${RUSTUP_TLS_CIPHERSUITES-}" ]; then
        # user specified custom cipher suites, assume they know what they're doing
        RETVAL="$RUSTUP_TLS_CIPHERSUITES"
        return
    fi

    local _cs=""
    if wget -V | grep -q '\-DHAVE_LIBSSL'; then
        # "unspecified" is for arch, allows for possibility old OS using macports, homebrew, etc.
        if check_help_for "notspecified" "wget" "TLSv1_2" "--ciphers" "--https-only" "--secure-protocol"; then
            _cs=$(get_strong_ciphersuites_for "openssl")
        fi
    elif wget -V | grep -q '\-DHAVE_LIBGNUTLS'; then
        # "unspecified" is for arch, allows for possibility old OS using macports, homebrew, etc.
        if check_help_for "notspecified" "wget" "TLSv1_2" "--ciphers" "--https-only" "--secure-protocol"; then
            _cs=$(get_strong_ciphersuites_for "gnutls")
        fi
    fi

    RETVAL="$_cs"
}


# Return cipher suite string specified by user, otherwise return strong TLS 1.2-1.3 cipher suites
# if support by local tools is detected. Detection currently supports these curl backends: 
# GnuTLS and OpenSSL (possibly also LibreSSL and BoringSSL). Return value can be empty.
get_ciphersuites_for_curl() {
    if [ -n "${RUSTUP_TLS_CIPHERSUITES-}" ]; then
        # user specified custom cipher suites, assume they know what they're doing
        RETVAL="$RUSTUP_TLS_CIPHERSUITES"
        return
    fi

    local _openssl_syntax="no"
    local _gnutls_syntax="no"
    local _backend_supported="yes"
    if curl -V | grep -q ' OpenSSL/'; then
        _openssl_syntax="yes"
    elif curl -V | grep -iq ' LibreSSL/'; then
        _openssl_syntax="yes"
    elif curl -V | grep -iq ' BoringSSL/'; then
        _openssl_syntax="yes"
    elif curl -V | grep -iq ' GnuTLS/'; then
        _gnutls_syntax="yes"
    else
        _backend_supported="no"
    fi

    local _args_supported="no"
    if [ "$_backend_supported" = "yes" ]; then
        # "unspecified" is for arch, allows for possibility old OS using macports, homebrew, etc.
        if check_help_for "notspecified" "curl" "--tlsv1.2" "--ciphers" "--proto"; then
            _args_supported="yes"
        fi
    fi

    local _cs=""
    if [ "$_args_supported" = "yes" ]; then
        if [ "$_openssl_syntax" = "yes" ]; then
            _cs=$(get_strong_ciphersuites_for "openssl")
        elif [ "$_gnutls_syntax" = "yes" ]; then
            _cs=$(get_strong_ciphersuites_for "gnutls")
        fi
    fi

    RETVAL="$_cs"
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}


# Return strong TLS 1.2-1.3 cipher suites in OpenSSL or GnuTLS syntax. TLS 1.2 
# excludes non-ECDHE and non-AEAD cipher suites. DHE is excluded due to bad 
# DH params often found on servers (see RFC 7919). Sequence matches or is
# similar to Firefox 68 ESR with weak cipher suites disabled via about:config.  
# $1 must be openssl or gnutls.
get_strong_ciphersuites_for() {
    if [ "$1" = "openssl" ]; then
        # OpenSSL is forgiving of unknown values, no problems with TLS 1.3 values on versions that don't support it yet.
        echo "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384"
    elif [ "$1" = "gnutls" ]; then
        # GnuTLS isn't forgiving of unknown values, so this may require a GnuTLS version that supports TLS 1.3 even if wget doesn't.
        # Begin with SECURE128 (and higher) then remove/add to build cipher suites. Produces same 9 cipher suites as OpenSSL but in slightly different order.
        echo "SECURE128:-VERS-SSL3.0:-VERS-TLS1.0:-VERS-TLS1.1:-VERS-DTLS-ALL:-CIPHER-ALL:-MAC-ALL:-KX-ALL:+AEAD:+ECDHE-ECDSA:+ECDHE-RSA:+AES-128-GCM:+CHACHA20-POLY1305:+AES-256-GCM"
    fi 
}

get_tos_env_bucket() {
    if [ "$1" = "cn" ]; then
        echo "doas-user-binary"
    elif [ "$1" = "sg" ]; then
        echo "doas-user-binary-sg"
    elif [ "$1" = "us" ]; then
        echo "doas-user-binary-us"
    elif [ "$1" = "i18n" ]; then
        echo "doas-user-binary-aiso"
    elif [ "$1" = "ttp" ]; then
        err "TTP is not supported to use TOS bucket downloader"
    fi 
}

get_scm_env_url() {
    if [ "$1" = "cn" ]; then
        echo "https://luban-source.byted.org"
    elif [ "$1" = "sg" ]; then
        echo "https://luban-source.byted.org"
    elif [ "$1" = "us" ]; then
        echo "https://luban-source-us.byted.org"
    elif [ "$1" = "i18n" ]; then
        echo "https://luban-source-us.byted.org"
    elif [ "$1" = "ttp" ]; then
        echo "https://luban-source.tiktokd.org"
    fi 
}

tos_downloader() {
    need_cmd gzip
    local _retval=${_retval:-}
    local _version
    local _version_url
    local _bucket_name
    local _tos_env=$1
    local _version_file=$2
    local _file=$3
    local _arch=$4
    if [[ -z "$1" ]]; then
        for _tos_env in "${DOAS_VALID_TOS_ENV_VARS[@]}"; do
            _bucket_name=$(get_tos_env_bucket "$_tos_env")
            _version_url="${DOAS_UPDATE_ROOT}/${_bucket_name}/CURRENT_VERSION"
            if downloader "$_version_url" "$_version_file" "$_arch"; then
                _retval="$_tos_env"
                break
            fi
        done
    elif [[  "$_tos_env" = "ttp" ]]; then
        err "TOS bucket downloader not supports TTP"
    else
        _bucket_name=$(get_tos_env_bucket "$_tos_env")
        _version_url="${DOAS_UPDATE_ROOT}/${_bucket_name}/CURRENT_VERSION"
        if downloader "$_version_url" "$_version_file" "$_arch"; then
            _retval="$_tos_env"
        fi
    fi

    if [[ -z "$_retval" ]]; then 
        echo "Unable to download doas from TOS bucket" 
        return 1
    fi

    _version="$(cat "$_version_file")"
    if [[ -z "$_version" ]]; then
        echo "Unable to read version from $_version_file"
        return 1
    fi
    local _url="${DOAS_UPDATE_ROOT}/${_bucket_name}/${_version}/doas-${_arch}.gz"
    ensure downloader "$_url" "${_file}.gz" "$_arch"
    ensure gzip -d "${_file}.gz"

    true
}

scm_downloader() {
    need_cmd tar
    local _retval=${_retval:-}
    local _scm_host
    local _scm_url
    local _compress_ext=".tar.gz"
    local _dir=$2
    local _file=$3
    local _arch=$4
    if [[ -z "$1" ]]; then
        for _env in "${DOAS_VALID_ENV_VARS[@]}"; do
            _scm_host=$(get_scm_env_url "$_env")
            _scm_url="${_scm_host}/repository/scm/api/v1/download_latest/?name=${DOAS_SCM_REPO_NAME}"
            if downloader "$_scm_url" "${_file}${_compress_ext}" "$_arch"; then
                _retval="$_env"
                break
            fi
        done
    else
        _scm_host=$(get_scm_env_url "$1")
        _scm_url="${_scm_host}/repository/scm/api/v1/download_latest/?name=${DOAS_SCM_REPO_NAME}"
        if downloader "$_scm_url" "${_file}${_compress_ext}" "$_arch"; then
            _retval="$1"
        fi
    fi

    if [[ -z "$_retval" ]]; then 
        echo "Unable to download doas from SCM Repo ${DOAS_SCM_REPO_NAME}" 
        return 1
    fi
    
    ensure tar zxf "${_file}${_compress_ext}" -C "$_dir"
    ensure mv "$_dir/bin/doas" "$_file"

    ignore rm "${_file}${_compress_ext}"
    ignore rmdir "$_dir/bin"
    ignore rm "$_dir/current_revision"

    true
}

SUDO_USER=${SUDO_USER:-}
if [ -n "$SUDO_USER" ]; then
    SUDO_PATH=$(sudo -Hiu $SUDO_USER printenv PATH)
fi
export SUDO_PATH=${SUDO_PATH:-}

main "$@" || exit 1