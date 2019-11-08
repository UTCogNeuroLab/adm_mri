#!/bin/sh
for cohort in `ls /scratch/06089/mcm5324/xcp/cohorts/adm_cohort*`; do

jobname=$(basename "$cohort" .csv)
jobfile=/scratch/06089/mcm5324/xcp/xcp_cmd/launch_"$jobname"
cp xcp_cmd/empty.sh $jobfile
echo "#!/bin/sh" >> $jobfile

echo "#SBATCH -J fmriprep_adm    # Job name
#SBATCH -o "$jobname"_o       # Name of stdout output file
#SBATCH -e "$jobname"_e       # Name of stderr error file
#SBATCH -p normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 24:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=mcmahonmc@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Machine-learning-app       # Allocation name (req'd if you have more than 1)" >> $jobfile

echo "module load tacc-singularity" >> $jobfile

echo "singularity run \\
    -B $SCRATCH:$SCRATCH \\
    $SCRATCH/singularity/xcpEngine.simg \\
    -c $cohort \\
    -d $SCRATCH/xcp/fc-6p_scrub.dsn \\
    -o $SCRATCH/xcp/xcp_results \\
    -r $SCRATCH \\
    -i $SCRATCH/xcp/xcp_temp \\
    -t 2" >> $jobfile

chmod +x $jobfile
#sbatch $jobfile

done
