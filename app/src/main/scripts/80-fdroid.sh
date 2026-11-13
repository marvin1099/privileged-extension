#!/sbin/sh
#
# ADDOND_VERSION=2
#
# /system/addon.d/80-fdroid.sh
# During a system upgrade, this script backs up F-Droid client and privext,
# /system is formatted and reinstalled, then the files are restored.
#

# addon.d-v1 exposes the helper functions in /tmp. On addon.d-v2 A/B
# updates they are exposed under /postinstall/tmp instead (as in Magisk's
# survival script). Prefer v1 when both locations are available.
V1_FUNCS=/tmp/backuptool.functions
V2_FUNCS=/postinstall/tmp/backuptool.functions
if [ -f "$V1_FUNCS" ]; then
  . "$V1_FUNCS"
elif [ -f "$V2_FUNCS" ]; then
  . "$V2_FUNCS"
else
  exit 1
fi

list_files() {
cat <<EOF
app/F-Droid.apk
app/F-Droid/F-Droid.apk
etc/permissions/permissions_org.fdroid.fdroid.privileged.xml
priv-app/F-DroidPrivilegedExtension.apk
priv-app/F-DroidPrivilegedExtension/F-DroidPrivilegedExtension.apk
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
