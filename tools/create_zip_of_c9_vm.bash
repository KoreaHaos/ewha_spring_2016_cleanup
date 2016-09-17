echo "hello!"
zip_file_name="$C9_PROJECT.zip"
echo "$zip_file_name"
echo "$0"
cd $GOPATH
cd ..
zip -r "$GOPATH/$zip_file_name" "workspace"*
#zip -r "$GOPATH/$zip_file_name" "workspace"* -x *ewha_spring_2016_cleanup*
