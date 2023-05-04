#!/usr/bin/env sh

if [[ $1 == "client" ]]; then
  trap : TERM INT; tail -f /dev/null & wait
  exit 0
fi

# Bootstrap the database if clamav is running for the first time
[ -f /clamav/main.cvd ] || freshclam

# Run the update daemon
freshclam -d -c 6

conf=/etc/clamav/clamd.conf

if touch $conf &>/dev/null; then 
  sed -i "s/^StreamMaxLength 10M$/StreamMaxLength ${STREAM_MAX_LENGTH:-10M}/g" $conf
  sed -i "s/^MaxScanSize 150M$/MaxScanSize ${MAX_SCAN_SIZE:-150M}/g" $conf
  sed -i "s/^MaxFileSize 30M$/MaxFileSize ${MAX_FILE_SIZE:-30M}/g" $conf
  sed -i "s/^MaxRecursion 10$/MaxRecursion ${MAX_RECURSION:-10}/g" $conf
  sed -i "s/^MaxFiles 15000$/MaxFiles ${MAX_FILES:-15000}/g" $conf
  sed -i "s/^MaxEmbeddedPE 10M$/MaxEmbeddedPE ${MAX_EMBEDDED_PE:-10M}/g" $conf
  sed -i "s/^MaxHTMLNormalize 10M$/MaxHTMLNormalize ${MAX_HTML_NORMALIZE:-10M}/g" $conf
  sed -i "s/^MaxHTMLNoTags 2M$/MaxHTMLNoTags ${MAX_HTML_NO_TAGS:-2M}/g" $conf
  sed -i "s/^MaxScriptNormalize 5M$/MaxScriptNormalize ${MAX_SCRIPT_NORMALIZE:-5M}/g" $conf
  sed -i "s/^MaxZipTypeRcg 1M$/MaxZipTypeRcg ${MAX_ZIP_TYPE_RCG:-1M}/g" $conf
  sed -i "s/^MaxPartitions 128$/MaxPartitions ${MAX_PARTITIONS:-128}/g" $conf
  sed -i "s/^MaxIconsPE 200$/MaxIconsPE ${MAX_ICONS_PE:-200}/g" $conf
  sed -i "s/^PCREMatchLimit 10000$/PCREMatchLimit ${PCRE_MATCH_LIMIT:-10000}/g" $conf
  sed -i "s/^PCRERecMatchLimit 10000$/PCRERecMatchLimit ${PCRE_REC_MATCH_LIMIT:-10000}/g" $conf
fi

# Run clamav
exec clamd
