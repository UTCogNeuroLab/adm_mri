for i in `ls /work/06089/mcm5324/stampede2/BIDS2 | grep sub | head -50`; do

PARTIC=`echo $i | cut -f2 -d-`;
export PARTIC
jobname=fmr_"$PARTIC"
jobfile=/scratch/06089/mcm5324/fmr_cmd/"$jobname"
cp empty.sh $jobfile

echo "#SBATCH -J fmriprep_adm    # Job name
#SBATCH -o "$jobname"_o       # Name of stdout output file
#SBATCH -e "$jobname"_e       # Name of stderr error file
#SBATCH -p normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 8               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 24:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=mcmahonmc@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Machine-learning-app       # Allocation name (req'd if you have more than 1)" >> $jobfile

echo "module load tacc-singularity" >> $jobfile

echo "singularity run --cleanenv /work/06089/mcm5324/stampede2/singularity/fmriprep-latest.simg \
    /work/06089/mcm5324/stampede2/BIDS2 /scratch/06089/mcm5324/ \
    participant \
    --nthreads 8 --omp_nthreads 8  --mem_mb 32000 \
    --ignore slicetiming \
    --fs-no-reconall \
    --fs-license-file /work/04171/dpisner/stampede2/freesurfer/license.txt \
    -w /scratch/06089/mcm5324/ \
    --participant-label $PARTIC" >> $jobfile

chmod +x $jobfile
sbatch $jobfile

echo "$PARTIC $(date)" >> status.csv

done
