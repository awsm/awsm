: ${AWSM_SSH_USER=$(whoami)}
: ${FUZZY_FILTER="fzf"}

SSH_BIN=$(which ssh)

function stacks {
  local filter=$@
  local query='StackSummaries[][ StackName ]'
  aws cloudformation list-stacks \
    --stack-status                                    \
      CREATE_COMPLETE                                 \
      CREATE_FAILED                                   \
      CREATE_IN_PROGRESS                              \
      DELETE_FAILED                                   \
      DELETE_IN_PROGRESS                              \
      ROLLBACK_COMPLETE                               \
      ROLLBACK_FAILED                                 \
      ROLLBACK_IN_PROGRESS                            \
      UPDATE_COMPLETE                                 \
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS             \
      UPDATE_IN_PROGRESS                              \
      UPDATE_ROLLBACK_COMPLETE                        \
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS    \
      UPDATE_ROLLBACK_FAILED                          \
      UPDATE_ROLLBACK_IN_PROGRESS                     \
  --query "${query}"             \
  --output ${output:-"text"}     |
  sort                           |
  grep --color=never -i ${filter:-".*"}
}


function instances {
  local filter=$@
  local query='
    Reservations[].Instances[][
        InstanceId,
        ImageId,
        InstanceType,
        State.Name,
        [Tags[?Key==`Name`].Value][0][0],
        LaunchTime,
        Placement.AvailabilityZone
    ]
  '

  aws ec2 describe-instances   \
    --query "${query}"         \
    --output ${output:-"text"} |
  column -s$'\t' -t |
  grep --color=never -i ${filter:-".*"}
}

read_inputs() {
  echo $(read_stdin) $@ |
    sed -E 's/\ +$//'   |
    sed -E 's/^\ +//'
}

read_stdin() {
  [[ -t 0 ]] ||
    cat                  |
      awk '{ print $1 }' |
      tr '\n' ' '        |
      sed 's/\ $//'
}

function ssh {
  local instance_line=$(instances | $FUZZY_FILTER)
  local instance_id=$(echo $instance_line | read_inputs)

  if [ -n "$instance_id" ]; then
    $SSH_BIN $AWSM_SSH_USER@$instance_id
  fi
}

function asgs {
  local filter=$@
  local query='
    AutoScalingGroups[][
      {
        "AutoScalingGroupName": AutoScalingGroupName,
        "Name":       [Tags[?Key==`Name`].Value][0][0]
      }
    ][]
  '

  aws autoscaling describe-auto-scaling-groups \
     --query "${query}"                        \
     --output ${output:-"text"}                |
  sort                                         |
  column -s$'\t' -t                            |
  grep --color=never -i ${filter:-".*"}
}

function asg-capacity {
  local query='
    AutoScalingGroups[][
      [
        AutoScalingGroupName,
        MinSize,
        DesiredCapacity,
        MaxSize
      ]
    ][]
  '
  local asg_names=$@

  aws autoscaling describe-auto-scaling-groups \
     $([[ -n ${asg_names} ]] && echo --auto-scaling-group-names)   \
     $(for x in ${asg_names}; do echo $x; done)                    \
     --query "${query}"                        \
     --output ${output:-"text"}                |
  sort                                         |
  column -s$'\t' -t
}

function lambdas {
  local query='
    Functions[][
      [
        FunctionName,
        Runtime
      ]
    ][]
  '
  aws lambda list-functions \
    --output text           \
    --query "$query"        |
  sort                      |
  column -s$'\t' -t
}

function lambda-invoke {
  local lambda_line=$(lambdas | $FUZZY_FILTER)
  local lambda_id=$(echo $lambda_line | read_inputs)

  if [ -n "$lambda_id" ]; then
    local out_file="/tmp/awsm-lambda.log"
    aws lambda invoke --function-name $lambda_id \
      --invocation-type RequestResponse \
      --log-type Tail \
      --payload '{}' \
      $out_file > /dev/null
    local status=$?

    cat $out_file && rm $out_file

    exit $status
  fi
}

function cloudwatch-groups {
  local query='
    logGroups[][
      [
        logGroupName
      ]
    ][]
  '
  aws logs describe-log-groups \
    --output text           \
    --query "$query"        |
  sort
}

function cloudwatch-streams {
  local query='
    logStreams[][
      [
        logStreamName
      ]
    ][]
  '
  aws logs describe-log-streams --log-group-name $1 \
    --output text           \
    --query "$query"
}

function get-log-events {
  local query='
    events[][
      [
        message
      ]
    ][]
  '

  local endtime=${3:-$(($(date +"%s") * 1000))}
  aws logs get-log-events \
    --log-group-name $1   \
    --log-stream-name $2  \
    --end-time $endtime   \
    $([[ -n $4 ]] && echo --start-time $4) \
    --output text         \
    --query "$query"
}

function logs {
  local cwg_line=$(cloudwatch-groups | $FUZZY_FILTER)
  local cwg=$(echo $cwg_line | read_inputs)

  local cws_line=$(cloudwatch-streams $cwg | $FUZZY_FILTER)
  local cws=$(echo $cws_line | read_inputs)

  endtime=$(($(date +"%s") * 1000))
  get-log-events $cwg $cws

  while :
  do
    starttime=$endtime
    endtime=$(($(date +"%s") * 1000))
    get-log-events $cwg $cws $endtime $starttime
    sleep 1
  done

}
