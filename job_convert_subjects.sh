#!/bin/bash

set -e

#this is the assumed directory.
WORK_DIR="$HOME/psych514-practice/lesson7/Cornucopia"

mkdir -p "$WORK_DIR/logs"

cd "$HOME/psych514-practice/lesson7/FruitScans"

for SUBJECT in sub-*; do

    # Ignore matches that are not directories.
    [ -d "$SUBJECT" ] || continue

    ANAT_DIR="$WORK_DIR/$SUBJECT/ses-Cornucopia/anat"

    # Skip subjects with all four expected output files.
    if [ -s "$ANAT_DIR/${SUBJECT}_ses-Cornucopia_T1w.nii.gz" ] &&
       [ -s "$ANAT_DIR/${SUBJECT}_ses-Cornucopia_T1w.json" ] &&
       [ -s "$ANAT_DIR/${SUBJECT}_ses-Cornucopia_T2w.nii.gz" ] &&
       [ -s "$ANAT_DIR/${SUBJECT}_ses-Cornucopia_T2w.json" ]; then

        echo "Skipping $SUBJECT: expected output files already exist."
        continue
    fi

    echo "Submitting $SUBJECT"

    #submit sbatch job for particular subject, including setting specific output and error dirs.
    sbatch --job-name="convert-$SUBJECT" \
        --output="$WORK_DIR/logs/${SUBJECT}-%j.out" \
        --error="$WORK_DIR/logs/${SUBJECT}-%j.err" \
        "$WORK_DIR/code/job_convert_subject.sh" "$SUBJECT"

    #wait 1ms
    sleep 1
done
