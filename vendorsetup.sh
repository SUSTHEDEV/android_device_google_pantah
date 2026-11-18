# Drops AppDataBackup from lineage_*.mk in this tree. repo sync resets those
# files, and vendor/lineage/config/evolution.mk adds it to every product: its
# Pixel guard reads PRODUCT_MANUFACTURER at parse time, which inherit-product's
# deferred child-first evaluation always leaves unset for leaf files, so
# AppDataBackup lands in system/priv-app and trips pantah's generic-system
# artifact path enforcement at soong bootstrap. A leaf-level filter-out runs
# after all inherits and is the only position that works.

for f in device/google/pantah/lineage_*.mk; do
    [[ -f "$f" ]] || continue
    grep -q 'filter-out AppDataBackup' "$f" && continue
    printf '\nPRODUCT_PACKAGES := $(filter-out AppDataBackup,$(PRODUCT_PACKAGES))\n' >> "$f"
    echo "patched $f: drop AppDataBackup"
done
