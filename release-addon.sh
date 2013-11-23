#!/bin/bash -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

: ${1?:"You must supply git URL as the first param"}
: ${2?:"You must supply XBMC plugin ID as the second param"}
: ${3?:"You must supply the version to release as the third param"}

git_url=$1
plugin_id=$2
version=$3

work_dir=$script_dir/tmp
repo_dir=$script_dir/repo
addon_dir_name=$plugin_id
addon_dir=$work_dir/$addon_dir_name
plugin_zip_name=${plugin_id}-${version}.zip
plugin_zip=$work_dir/$plugin_zip_name

echo "Cloning git repo"
rm -rf $addon_dir
git clone $git_url $addon_dir

cd $addon_dir

echo "Updating version number in addon.xml"
sed -i "s/\"plugin.audio.rdio\" version=\"[0-9.]*\"/\"plugin.audio.rdio\" version=\"${version}\"/" addon.xml
git commit -a -m "Updated for version ${version}"

echo "Tagging git repo"
git tag -a "v${version}" -m "Tagged version $version"
git checkout v${version}

cd -

echo "Zipping the addon"
cd $work_dir
rm -f $plugin_zip
zip -rq ${plugin_zip_name} $addon_dir_name -x "${addon_dir_name}/.git"
cd -

echo "Adding to repo"
cd $script_dir
cp $plugin_zip $repo_dir/$plugin_id
git add $repo_dir/$plugin_id/$plugin_zip_name
$script_dir/update-addon-xml.sh
git commit -a -m "Updated for $plugin_id release $version"
cd -

echo "Pushing repo and addon to git master"
cd $addon_dir
git checkout master
git push
git push --tags
cd -
cd $script_dir
git push
cd -
