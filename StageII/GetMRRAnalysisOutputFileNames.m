function OutFileName = GetMRRAnalysisOutputFileNames(Directory,RelatedFileName,MetricID)
% function OutFileName = GetMRRAnalysisOutputFileNames()
% This function plots and saves the MRR to disk. This also saves the raw points to disk
%
% INPUTS
% Directory:            directory address of output files
% RelatedFileName:      slave file name related to outputs
% MetricID:             id of metric used to do MRR analysis
%
% OUTPUTS
% OutFileName:          structure containing output file names

Addr_ET = sprintf('%s\\%s_%s%d.csv',Directory,RelatedFileName(1:end-4),'ET',MetricID);
Addr_MRRPlot = sprintf('%s\\%s_%s%d.pdf',Directory,RelatedFileName(1:end-4),'MRRPlot',MetricID);
Addr_MRRPts = sprintf('%s\\%s_%s%d.csv',Directory,RelatedFileName(1:end-4),'MRRPts',MetricID);

OutFileName.ET = Addr_ET;
OutFileName.MRRPLot = Addr_MRRPlot;
OutFileName.MRRPts = Addr_MRRPts;

end