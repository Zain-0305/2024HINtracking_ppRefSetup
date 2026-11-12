#!/bin/bash
set -euo pipefail

JOBID=$1
CLUSTER=$2

CMSSW_DIR="/afs/cern.ch/user/z/zzainula/Traking/CMSSW_15_0_11"
TESTDIR="${CMSSW_DIR}/src/HITrackingStudies/HITrackingStudies/test"

EOS_DEST="root://eoscms.cern.ch//store/group/phys_heavyions/zzainula/OO_TrackingEfficiency"

echo "========================================"
echo "OO tracking efficiency job"
echo "Cluster: ${CLUSTER}"
echo "Job: ${JOBID}"
echo "========================================"

# Get the input file corresponding to this Condor job
INPUT=$(sed -n "$((JOBID + 1))p" "${TESTDIR}/mySample.txt")

if [[ -z "${INPUT}" ]]; then
    echo "ERROR: No input file found for job ${JOBID}"
    exit 1
fi

echo "Input: ${INPUT}"

# Set up CMSSW
source /cvmfs/cms.cern.ch/cmsset_default.sh
cd "${CMSSW_DIR}"
eval "$(scram runtime -sh)"

# Use worker-node scratch, not AFS, for temporary ROOT output
WORK="${_CONDOR_SCRATCH_DIR:-$PWD}/ooeff_${CLUSTER}_${JOBID}"
mkdir -p "${WORK}"
cd "${WORK}"

# Copy the configuration and one-file input list
cp "${TESTDIR}/run_PPRef_cfg.py" .
cp "${TESTDIR}/ppref.py" .
printf '%s\n' "${INPUT}" > mySample.txt

# Run the complete input file
cmsRun run_PPRef_cfg.py \
    sample="MC_RecoDebug" \
    n=-1 \
    usePixelTrks=False \
    runOverStreams=False

OUTPUT="OO_trkEff_pixcut.root"

if [[ ! -s "${OUTPUT}" ]]; then
    echo "ERROR: Output ROOT file missing or empty"
    exit 1
fi

# Copy the result to EOS
DEST="${EOS_DEST}/job_${CLUSTER}_${JOBID}.root"

echo "Copying output to ${DEST}"

xrdcp -f "${OUTPUT}" "${DEST}"

echo "Checking remote output..."
xrdfs root://eoscms.cern.ch stat \
    "/store/group/phys_heavyions/zzainula/OO_TrackingEfficiency/job_${CLUSTER}_${JOBID}.root"

echo "JOB ${JOBID} COMPLETED SUCCESSFULLY"
