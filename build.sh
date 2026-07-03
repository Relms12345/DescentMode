#!/bin/sh
set -e

cd "$(dirname "$0")"

[ -e ./.env ] && . .env

rm -rvf bin obj packages

export KSP_ROOT=${KSP_ROOT:-~/games/KSP-GOG/1.4.3/game}

# Detect managed path (KSP 1.8+ uses KSP_x64_Data, older uses KSP_Data)
if [ -d "$KSP_ROOT/KSP_x64_Data/Managed" ]; then
    KSPBT_MANAGED="$KSP_ROOT/KSP_x64_Data/Managed"
elif [ -d "$KSP_ROOT/KSP_Data/Managed" ]; then
    KSPBT_MANAGED="$KSP_ROOT/KSP_Data/Managed"
else
    echo "ERROR: KSP managed DLLs not found at $KSP_ROOT"
    echo "Set KSP_ROOT to a valid KSP install directory"
    exit 1
fi

dotnet build -c Release -p:KSPBT_ManagedPath="$KSPBT_MANAGED"

mkdir -pv packages
zip -r -v packages/DescentMode.zip GameData LICENSE.txt README.md
