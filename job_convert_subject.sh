#!/bin/bash
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

set -e

# Require one subject argument.
if [ "$#" -ne 1 ]; then
    echo "Usage: sbatch job_convert_subject.sh SUBJECT" >&2
    exit 1
fi

SUBJECT="$1"

# Set input and output locations.
DICOM_DIR="$HOME/psych514-practice/lesson7/FruitScans/$SUBJECT/ses-Cornucopia/dicom"
ANAT_DIR="$HOME/psych514-practice/lesson7/Cornucopia/$SUBJECT/ses-Cornucopia/anat"

# Find the T1 and T2 input directories.
shopt -s nullglob
T1_DIRS=("$DICOM_DIR"/t1*/)
    #had to edit this from the original script because the HHM files actually started with t2
T2_DIRS=("$DICOM_DIR"/t2*/)

#check to see if the t1 and 2 directories exist, if not, output error into file
if [ "${#T1_DIRS[@]}" -ne 1 || "${#T2_DIRS[@]}" -ne 1]; then
	echo "Expected one T1 and one HHR directory for $SUBJECT" >&2
fi

#make the output dir
mkdir -p "$ANAT_DIR"

echo "Converting $SUBJECT"
hostname
date

# Convert the T1-weighted scan.
dcm2niix -b y -ba y -z i -o "$ANAT_DIR" \
    -f "${SUBJECT}_ses-Cornucopia_T1w" "${T1_DIRS[0]}"

# Convert the T2-weighted scan.
dcm2niix -b y -ba y -z i -o "$ANAT_DIR" \
    -f "${SUBJECT}_ses-Cornucopia_T2w" "${T2_DIRS[0]}"

echo "Conversion commands completed for $SUBJECT"
date
