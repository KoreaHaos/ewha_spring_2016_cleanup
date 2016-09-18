
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
    set_log_directory_name;
    set_log_directory_name_and_path;
    set_short_log_name;
    set_long_log_name;
    set_temp_file_name;
    set_zipped_list_name;
    
    clone_clean_up_repo;
    zip_up_workspace_and_put_it_in_repo_directory_and_update_log;
    fill_logs_pre_push;
    
    pre_add_commit_push_changes;
    fill_logs_post_push;
    post_add_commit_push_changes;
    
    timestamp_script_and_echo "FINAL";
}



function say_hello(){
    echo "Hello!";
}
function get_current_time_nano_seconds_since_epoch(){
    echo $(date +%s%N);
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

function output_timers_long(){
    echo_timestamp_zip;
    echo_timestamp_clone;
    echo_timestamp_add_commit_push;
    timestamp_script_and_echo;
: <<'END'    
    echo "$scripted_clean_up_start_time = clean up script start = $(prettify_date "$scripted_clean_up_start_time")."
    echo "$scripted_clean_up_end_time = scripted clean up end = $(prettify_date "$scripted_clean_up_end_time")."
    echo "$scripted_repo_clone_start = scripted clone start time = $(prettify_date "$scripted_repo_clone_start")."
    echo "$scripted_repo_clone_end = scripted clone end time = $(prettify_date "$scripted_repo_clone_end")."
    echo "$zip_script_start = scripted zip start time = $(prettify_date "$zip_script_start")."
    echo "$zip_script_end = scripted zip end time = $(prettify_date "$zip_script_end")."
    echo "$start_scripted_repo_add_commit_push = scripted add-commit-push start time = $(prettify_date "$start_scripted_repo_add_commit_push")."
    echo "$end_scripted_repo_add_commit_push = scripted add-commit-push end time = $(prettify_date "$end_scripted_repo_add_commit_push")."
    echo "$(datediff "$scripted_clean_up_start_time" "$scripted_clean_up_end_time") = total run time = xxx min xxx sex xxx ns"
    echo ""
    timestamp_script
END
}


function timestamp_script_and_echo(){
    set_script_end_time;
    echo "SCRIPT STAMP : $1"
    echo_time_stamp "$scripted_clean_up_start_time" "$scripted_clean_up_end_time" "script"
}

function echo_timestamp_zip(){
    echo_time_stamp "$zip_script_start" "$zip_script_end" "scripted zip"
}

function echo_timestamp_clone(){
    echo_time_stamp "$scripted_repo_clone_start" "$scripted_repo_clone_end" "scripted clone"
}

function echo_timestamp_add_commit_push(){
    echo_time_stamp "$start_scripted_repo_add_commit_push" "$end_scripted_repo_add_commit_push" "scripted add-commit-push"
}


function echo_line_break(){
    echo ""
    echo "---------------------------$1---------------------------"
    echo ""
}

function echo_time_stamp(){
    time_start="$1"
    time_end="$2"
    stamp_id="$3"
    
    run_time="$(datediff "$time_start" "$time_end")"
    
    
    echo "$time_start = $stamp_id start time = $(prettify_date "$time_start")."
    echo "$time_end = $stamp_id end time = $(prettify_date "$time_end")."
    echo "$run_time = $stamp_id total run time = xxx min xxx sex xxx ns"
    
    echo_line_break "*TS*";

}

function set_script_end_time(){
    scripted_clean_up_end_time=$(get_current_time_nano_seconds_since_epoch);
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

function set_log_directory_name(){
    log_directory="c9_vm_zips"
}

function set_log_directory_name_and_path(){
    log_directory_name_and_path="$cleanup_repo_directory_name_and_path"/"c9_vm_zips/logs"
}

function set_short_log_name(){
    short_log_name="c9_cleanup_abbreviated_log.txt"
}

function set_long_log_name(){
    long_log_name="c9_cleanup_long_log.txt"
}

function set_zipped_list_name(){
    zipped_machines_log_name="c9_zipped_vm_shortlist.txt"
}

function set_temp_file_name(){
    temp_log_file_name="temp_log_file.txt"
    #echo -n "" > /tmp/filename
}

# ToDo : Make it terminate if the authentication fails!
function clone_clean_up_repo(){
    temp_out=$(mktemp /tmp/output.XXX) || { echo "Failed to create temp file"; exit 1; }
    scripted_repo_clone_start=$(get_current_time_nano_seconds_since_epoch)
    echo_line_break "CS" > $temp_out;
    git config --global credential.helper cache
    git clone -v --progress "$clean_up_repo_url" "$cleanup_repo_directory_name_and_path" >>$temp_out  2>&1;
    scripted_repo_clone_end=$(get_current_time_nano_seconds_since_epoch)
    echo_line_break "CF" >> $temp_out;
    cat $temp_out >> "$log_directory_name_and_path"/"$temp_log_file_name";
}

function zip_up_workspace_and_put_it_in_repo_directory_and_update_log(){
    cd $GOPATH;
    cd ..;
    zip_script_start=$(get_current_time_nano_seconds_since_epoch);
    zip -r "$cleanup_repo_directory_name_and_path/c9_vm_zips/$zip_file_name" "workspace"* >> "$log_directory_name_and_path"/"$temp_log_file_name";
    zip_script_end=$(get_current_time_nano_seconds_since_epoch);
}

function fill_logs_pre_push(){
    cd $GOPATH;
    cd ..;
    
    echo_line_break "PrePS" >> "$log_directory_name_and_path"/"$long_log_name";
    timestamp_script_and_echo "PrePush" >> "$log_directory_name_and_path"/"$long_log_name";
    echo_timestamp_zip >>  "$log_directory_name_and_path"/"$long_log_name";
    echo_timestamp_clone >>  "$log_directory_name_and_path"/"$long_log_name";
    echo_line_break >> "$log_directory_name_and_path"/"$long_log_name";
    cat "$log_directory_name_and_path"/"$temp_log_file_name" >> "$log_directory_name_and_path"/"$long_log_name";
    echo_line_break "PrePF" >> "$log_directory_name_and_path"/"$long_log_name";
}

function fill_logs_post_push(){
    cd $GOPATH;
    cd ..;
    
    echo_line_break "PostPS" >> "$log_directory_name_and_path"/"$long_log_name";
    #echo_timestamp_zip >>  "$log_directory_name_and_path"/"$long_log_name";
    #echo_timestamp_clone >>  "$log_directory_name_and_path"/"$long_log_name";
    echo_timestamp_add_commit_push  >> "$log_directory_name_and_path"/"$long_log_name";
    echo_line_break >> "$log_directory_name_and_path"/"$long_log_name";
    cat "$log_directory_name_and_path"/"$temp_log_file_name" >> "$log_directory_name_and_path"/"$long_log_name";
    echo $C9_PROJECT >> "$log_directory_name_and_path"/"$zipped_machines_log_name";
    timestamp_script_and_echo "PostPush" >> "$log_directory_name_and_path"/"$long_log_name";
    echo_line_break "PostPF" >> "$log_directory_name_and_path"/"$long_log_name";
}

function pre_add_commit_push_changes(){
    cd $cleanup_repo_directory_name_and_path;
    start_scripted_repo_add_commit_push=$(get_current_time_nano_seconds_since_epoch);
    git add --all;
    git commit -m "testing PRE";
    git push --all;
    end_scripted_repo_add_commit_push=$(get_current_time_nano_seconds_since_epoch);
}

function post_add_commit_push_changes(){
    cd $cleanup_repo_directory_name_and_path;
    #start_scripted_repo_add_commit_push=$(get_current_time_nano_seconds_since_epoch);
    git add --all;
    git commit -m "testing POST";
    git push --all;
    #end_scripted_repo_add_commit_push=$(get_current_time_nano_seconds_since_epoch);
}

run_script

