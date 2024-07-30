if [ -z "$1" ]
then
  echo "Argument required having format yyyymmdd"
  exit 1
fi

files=$(find $PWD -maxdepth 3 -name "*.csv")

for file in ${files}
do
        intraday=$(echo "${file}" | cut -d / -f 8 | cut -d . -f 1 | sed 's/-//g')
        if [[ "$intraday" -le "$1" ]];
                then continue;
        fi

        echo "CREATE TABLE intraday_${intraday} (
  symbol char(10) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  timestamp timestamp NOT NULL,
  open double NOT NULL,
  high double NOT NULL,
  low double NOT NULL,
  close double NOT NULL,
  volume bigint(20) NOT NULL,
  transactions int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;" >> result.sql

        echo "ALTER TABLE intraday_${intraday}
  ADD PRIMARY KEY (symbol,timestamp);" >> result.sql

        echo "LOAD DATA LOCAL INFILE '${file}'
INTO TABLE intraday_${intraday}
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(symbol, volume, open, close, high, low, @time, transactions)
SET timestamp=FROM_UNIXTIME(@time/1000000000);" >> result.sql
done
