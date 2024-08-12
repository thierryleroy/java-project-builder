export ENV=""
export RUN_DIR="/srv/run-directory"
export MODULE="com.example"
export PACKAGE="com.example"
export CLASS="Run"
export XMS="512m"
export XMX="$(($(free -m | awk '/^Mem:/{print $2}') - 512))m" # 512MB less than total memory