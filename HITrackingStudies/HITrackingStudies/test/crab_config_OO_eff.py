
from CRABClient.UserUtilities import config

config = config()

config.General.requestName = 'OO_TrackingEfficiency'
config.General.workArea = 'CRAB_OO_TrackingEfficiency'
config.General.transferLogs = True
config.General.transferOutputs = True

config.JobType.pluginName = 'Analysis'
config.JobType.psetName = 'run_PPRef_cfg.py'
config.JobType.outputFiles = ['OO_trkEff_pixcut.root']
config.JobType.maxMemoryMB = 4000

config.Data.inputDataset = '/MinBias_OO_5p36TeV_hijing/HINOOSpring25Reco-NoPU_150X_mcRun3_2025_forOO_realistic_v7-v2/AODSIM'
config.Data.inputDBS = 'global'
config.Data.splitting = 'FileBased'
config.Data.unitsPerJob = 1
config.Data.totalUnits = 256

config.Data.outLFNDirBase = '/store/group/phys_heavyions/zzainula/OO_TrackingEfficiency'
config.Data.publication = False

config.Site.storageSite = 'T2_CH_CERN'

