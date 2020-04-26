#!/usr/bin/env bash
cid=`curl https://pacpark.com/santa-monica-pier-live-cams/park/ 2>/dev/null | sed -rn  's/.*camera_doc:(.{18}).*/\1/p'`

p1="https://relay.ozolio.com/ses.api?cmd=init&oid="
p2="&ver=5&channel=0&control=1&document=https%3A%2F%2Fpacpark.com%2Fsanta-monica-pier-live-cams%2Fpark%2F"


url="${p1}${cid}${p2}"
#echo "$url"
sid=`curl "$url" 2>/dev/null | jq '.session.id'`
#echo $sid

q1="https://relay.ozolio.com/ses.api?cmd=open&oid="
q2="&output=1&format=M3U8"

lasturl="${q1}${sid}${q2}"
mediaurl=`curl "$lasturl" 2>/dev/null|jq -r '.output.source'`
echo $mediaurl
yq w -i /storage/homeassistant/share/hassio/homeassistant/packages/camera.yaml camera[0].input $mediaurl
