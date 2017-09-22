# ! /usr/bin/env bash
while :
do
    starts=$(date +'%s')
    curl --retry 3 http://localhost:8000/ping/b75bf531-f515-47ed-bc65-24f3489771ec 
    randomW=$(( ( RANDOM % 20 )  + 5 ))
    sleep 5
    ends=$(date +'%s')
    elapsed=$(($ends - $starts))
    echo "$elapsed">>monitor.log
    tail -n1 monitor.log | awk '{print $1}' | xargs -I {} echo "{} `date +%s%N`" | xargs -I {} curl -i -XPOST 'http://localhost:8086/write?db=localmetrics' --data-binary '5s_healthcheck_tat,host=krypton,region=us-west value={}'
done

