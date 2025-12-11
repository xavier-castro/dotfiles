# README

## Run

The run script:

1. Executes each script in runs/ (01-brew, 02-dev-tools, 03-apps, 04-env, 05-fonts, 06-zsh) in order
2. Runs dev-env at the end to populate your configuration files

The script also respects the --dry flag, passing it through to dev-env so you can preview what would happen without making changes.
To use it:

# Full run
./dev/run

# Dry run to preview
./dev/run --dry

# Run only scripts matching a pattern (e.g., just brew)
./dev/run brew

