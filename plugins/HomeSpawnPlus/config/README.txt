HSP 2.0 now supports and prefers new separate config files in this config
directory rather than one monolithic config.yml like before. This makes it
easier to concentrate on what you are trying to change and not have to hunt
through a single large file.

In order to support painless upgrades for those coming from HSP 1.7 series,
HSP 2.0 also still supports the single large config.yml. If you have a
config.yml in the plugins/HomeSpawnPlus directory, HSP 2.0 will use that as
your primary config. In that case, the separate config files here in the
config directory serve as defaults if any values are missing from the
config.yml.

Long-term you should migrate your configs to the new-style separate configs,
which is as simple as cut & pasting the relevant sections into the new config
files and then deleting the large plugins/HomeSpawnPlus/config.yml file.
