# Keeps PRODUCT_MANUFACTURER := Google ahead of the lineage common include in
# lineage_*.mk. repo sync resets those files, and without the line the Pixel
# guard in vendor/lineage/config/evolution.mk adds AppDataBackup, which trips
# pantah's generic-system artifact path enforcement at soong bootstrap.

for f in device/google/pantah/lineage_*.mk; do
    [[ -f "$f" ]] || continue
    grep -q '^PRODUCT_MANUFACTURER := Google$' "$f" && continue
    sed -i '/call inherit-product, vendor\/lineage\/config\/common_full_phone.mk/i\
PRODUCT_MANUFACTURER := Google' "$f"
    echo "patched $f: PRODUCT_MANUFACTURER := Google"
done
