#Cat SPS metrics

for file in `ls /Volumes/schnyer/Megan/NetMetrics_corr_ADM grep ""`; do PARTIC=`echo $file | cut -c 1-5`;
echo $PARTIC;
echo "$PARTIC"_net_metrics_corr_mean.csv;
awk -v dt="$PARTIC" 'BEGIN{FS=OFS=","}{$1=dt}1' $file > $PARTIC'__.csv'
done
awk 'FNR==1 && NR!=1{next;}{print}' *__.csv > netmetrics_corr_mean_cat.csv
find . -name "*__.csv" -delete
