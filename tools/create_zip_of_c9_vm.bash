echo "hello!"
zip_file_name="$C9_PROJECT.zip"
cleanup_directory="$C9_PROJECT""_CLEAN_UP_REPO"
echo "$zip_file_name"
echo "$cleanup_directory"
echo "$0"
cd $GOPATH
cd ..
git config --global credential.helper cache
#git clone https://github.com/KoreaHaos/ewha_spring_2016_cleanup.git "$C9_PROJECT_CLEAN_UP_DIR"
#zip -r "$GOPATH/$zip_file_name" "workspace"*
#zip -r "$GOPATH/$zip_file_name" "workspace"* -x *ewha_spring_2016_cleanup*
