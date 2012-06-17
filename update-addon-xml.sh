#!/bin/bash -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Updating $script_dir/addons.xml"

addons_xml_content='<?xml version="1.0" encoding="UTF-8"?>\n\n<addons>'
for addon_dir in `ls -d1 $script_dir/repo/*/`; do
  addon_name=`basename $addon_dir`
  latest_zip=`find $addon_dir -maxdepth 1 -name "*.zip" | egrep "[a-zA-Z\.]+-[0-9]+\.[0-9]+\.[0-9]+\.zip" | sort -V | tail -1`
  if [ -n "$latest_zip" ]; then
    echo "Adding xml for addon `basename $latest_zip`"
    addon_xml_content=`unzip -p $latest_zip $addon_name/addon.xml | grep -v "<\?xml"`
    addons_xml_content="$addons_xml_content\n\n$addon_xml_content"
  fi
done
addons_xml_content="$addons_xml_content\n\n</addons>\n"
echo -e "$addons_xml_content" > $script_dir/addons.xml
md5sum $script_dir/addons.xml | cut -f1 -d ' ' > $script_dir/addons.xml.md5
echo "addons.xml updated successfully"
