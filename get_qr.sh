

KEYS=$(cat user.csv | cut -f 1 -d ",")
for KEY in $KEYS
do
	echo $KEY
	wget -q "https://qrcode.online/img/?type=url&size=8&data=http://kasse.impro/$KEY" -O $KEY.png
done
