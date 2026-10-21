# Psych-514-EC

job_convert_subject.sh
Takes the subject name and uses it to locate the DICOMs and give names to files.

wrap_convert_subjects.sh 
Goes through each subject file, passes the mane to the sbatch job script, and sets logs.

Required programs:
dcm2niix
