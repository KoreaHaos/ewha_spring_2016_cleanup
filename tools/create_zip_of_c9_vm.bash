
function run_script(){
    say_hello;
    init_script;
}

function init_script(){
    echo "Script Initializing!";
    set_timers;
    set_github_user_id;
    set_clean_up_repo_name;
    set_clean_up_repo_url;
    set_clean_up_repo_local_directory_name;
    set_clean_up_repo_local_directory_name_and_path;
    set_zip_file_name;
    clone_clean_up_repo;
    
    output_timers;
}
function say_hello(){
    echo "Hello!";
}
function set_timers(){
    scripted_clean_up_start_time=$(get_current_time_nano_seconds_since_epoch);
    zip_script_start=$scripted_clean_up_start_time;
    zip_script_end=$scripted_clean_up_start_time;
    scripted_repo_clone_start=$scripted_clean_up_start_time;
    scripted_repo_clone_end=$scripted_clean_up_start_time;
    start_scripted_repo_add_commit_push=$scripted_clean_up_start_time;
    end_scripted_repo_add_commit_push=$scripted_clean_up_start_time;
    scripted_clean_up_end_time=$scripted_clean_up_start_time;
}
function get_current_time_nano_seconds_since_epoch(){
    echo $(date +%s%N);
}
function output_timers(){
    echo "$scripted_clean_up_start_time = clean up script start = $(prettify_date "$scripted_clean_up_start_time")."
    echo "$scripted_clean_up_end_time = scripted clean up end = $(prettify_date "$scripted_clean_up_end_time")."
    echo "$(datediff "$scripted_clean_up_start_time" "$scripted_clean_up_end_time") = total run time = xxx min xxx sex xxx ns"
}
function prettify_date(){
    echo $(date --date=@$((${1#*|}/1000000000 )))
}
function datediff() {
    start_time=$1
    end_time=$2
    time_diff=$(((end_time - start_time)/1000000000)).$(((end_time - start_time)%1000000000))
    echo "$time_diff = difference(ms)"
}
function set_github_user_id(){
    github_user_id="KoreaHaos"
}
function set_clean_up_repo_name(){
    clean_up_repo_name="ewha_spring_2016_cleanup.git"
}

function set_clean_up_repo_url(){
    clean_up_repo_url="https://github.com/$github_user_id/$clean_up_repo_name"
}

function set_clean_up_repo_local_directory_name(){
    cleanup_repo_directory_name="$C9_PROJECT""_CLEAN_UP_REPO"
}

function set_clean_up_repo_local_directory_name_and_path(){
    cd $GOPATH
    cd ..
    cleanup_repo_directory_name_and_path="$(pwd)"/"$cleanup_repo_directory_name"
}

function set_zip_file_name(){
    zip_file_name="$C9_PROJECT.zip"
}

function clone_clean_up_repo(){
    scripted_repo_clone_start=$(get_current_time_nano_seconds_since_epoch)
    git config --global credential.helper cache
    git clone "$clean_up_repo_url" "$cleanup_repo_directory_name_and_path"
    scripted_repo_clone_end=$(get_current_time_nano_seconds_since_epoch)
}

function zip_up_workspace_and_put_it_in_repo_directory_and_update_log(){
    cd $GOPATH;
    cd ..;
    zip -r "$cleanup_repo_directory_name_and_path/c9_vm_zips/$zip_file_name" "workspace"* >> "$cleanup_repo_directory_name_and_path/c9_vm_zips/c9_cleanup_log.txt";
}
run_script

: <<'END_OF_COMMENT'

function date_and_time_with_milliseconds(){
    echo $(date +%D:%T:%N);
}
repo_clone_start_time=$(date_and_time_with_milliseconds)
repo_clone_end_time=$(date_and_time_with_milliseconds)
echo "" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
echo "-----------------------------------------------------------" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
echo "Clean up of C9 VM : $C9_PROJECT started at $start_time" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
echo "" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
zip_start_time=$(date_and_time_with_milliseconds)
zip_end_time=$(date_and_time_with_milliseconds)
echo "" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
clean_up_end_time=$(date_and_time_with_milliseconds)
echo "Clean up of C9 VM : $C9_PROJECT finished at $clean_up_end_time" >> "$cleanup_directory/c9_vm_zips/c9_cleanup_log.txt"
#git add --all
#git commit -m "Scripted clean up of $C9_PROJECT"
#git push --all
#zip -r "$GOPATH/$zip_file_name" "workspace"* -x *ewha_spring_2016_cleanup*

#echo "Today is $(date)"
END_OF_COMMENT