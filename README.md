# Apps

A user-local installation prefix for building and installing software on Linux without root access.

This repository provides `setup_env.sh`, a Bash helper that configures the current shell to discover programs, libraries, headers, pkg-config metadata, and manual pages installed under this repository.

## How it works

The environment script uses the repository directory as an installation prefix and adds these paths to the current shell:

- `bin/` → `PATH`
- `lib/` → `LD_LIBRARY_PATH`
- `include/` → `C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH`
- `lib/pkgconfig/` → `PKG_CONFIG_PATH`
- `share/man/` → `MANPATH`

Previous values are saved and can be restored with `deactivate_apps`.

## Recommended location

Keep the repository in a user-local directory such as:

```text
$HOME/path/to/Apps
```

`$HOME` is the standard Linux environment variable for your home directory. `$USER_HOME` is not normally defined by default.

## Usage

Clone the repository into your user-local installation directory and source the script from the shell where the locally installed applications should be available:

```bash
git clone https://github.com/Souritra-Garai/Apps.git "$HOME/path/to/Apps"
cd "$HOME/path/to/Apps"
source ./setup_env.sh
```

You can also source the script using its full path:

```bash
source "$HOME/path/to/Apps/setup_env.sh"
```

Install software with this repository as its prefix. For example, many Autotools-based projects can be configured with:

```bash
./configure --prefix="$HOME/path/to/Apps"
make
make install
```

For CMake-based projects:

```bash
cmake -S . -B build \
  -DCMAKE_INSTALL_PREFIX="$HOME/path/to/Apps"
cmake --build build
cmake --install build
```

After installation, commands in `bin/` should be available in the shell:

```bash
which <program>
<program> --version
```

When finished, restore the shell's previous environment:

```bash
deactivate_apps
```

> `setup_env.sh` must be **sourced**, not executed, so that its environment changes affect the current shell.

## Requirements

- Linux or another Unix-like environment with Bash
- A compiler and build tools appropriate for the software being installed
- Sufficient disk space in the checkout for locally installed dependencies

## Repository layout

```text
.
├── setup_env.sh   # Environment activation/deactivation helpers
├── bin/           # Locally installed executables (ignored by Git)
├── include/       # Locally installed headers (ignored by Git)
├── lib/           # Locally installed libraries and pkg-config files (ignored by Git)
└── share/         # Locally installed data and manual pages (ignored by Git)
```

The installation directories are intentionally ignored because they contain generated and machine-specific files. Keep source code and build recipes in separate repositories or directories.

## License

No license has been specified yet.
