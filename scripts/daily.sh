if [ -z "$1" ]
then
  echo "Argument required having format yyyymmdd"
  exit 1
fi

files=$(find $PWD -maxdepth 3 -name "*.csv")

for file in $files
do
        intraday=$(echo "${file}" | cut -d / -f 8 | cut -d . -f 1 | sed 's/-//g')
        if [[ "$intraday" -le "$1" ]];
                then continue;
        fi

        echo "LOAD DATA LOCAL INFILE '${file}'
INTO TABLE daily
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(symbol, volume, open, close, high, low, @time, transactions)
SET date=DATE(FROM_UNIXTIME(@time/1000000000));" >> result.sql
done
