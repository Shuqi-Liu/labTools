function [trialMD,fileList,secFileList] = getTrialMetaData(info)
%getTrialMetaData  generates trialMetaData objects for each trial of a
%given experiment.
%
%INPUTS:
%info: structured array output from GetInfoGUI
%
%OUTPUT:
%trialMD: cell array of trialMetaData objects where the cell index corresponds
%to the trial number
%fileList: list of .c3d files containing kinematic and force data for a given experiment
%secFileList: list of files containing EMG data for a given experiment
%
%See also: trialMetaData

dirStr = info.dir_location;
basename = info.basename;

fileList={};
secFileList={};
trialMD={};


for cond = sort(info.cond) 
    for t = info.trialnums{cond}
        %there may be an easier way to do this, basically this assumes that
        %the .c3d files are named basename01, basename02,..., basename10,
        %basename11,...
        if t<10
            filename = [dirStr filesep basename  '0' num2str(t)];
            if info.perceptualTasks ==1
                filenameDatlog = [info.dir_location '\datlogs\Trial'  '0' num2str(t)];
                % Upload the datalog for the specifica condition   
                info.datlog{cond} = load([filenameDatlog '.mat']);
            end
        else
            filename = [dirStr filesep basename num2str(t)];
            if info.perceptualTasks ==1
                filenameDatlog = [info.dir_location '\datlogs\Trial' num2str(t)];
                % Upload the datalog for the specifica condition   
                info.datlog{cond} = load([filenameDatlog '.mat']);
            end
        end
        
        fileList{t}=filename;
               
        if ~isempty(info.secdir_location) %Pablo changed on 7/16/2015 to consider the case where there is EMG from a single file.
            if t<10
                secFileList{t} = [info.secdir_location filesep basename '0' num2str(t)];
            else
                secFileList{t} = [info.secdir_location filesep basename num2str(t)];
            end
        else
            secFileList{t}='';
        end       
        
        
        if ~isfield(info,'trialObs')
            info.trialObs=cell(info.numoftrials,1);
        end
        
         if info.perceptualTasks ==1
               % constructor: (name,desc,obs,refLeg,cond,filename,type)
            trialMD{t}=trialMetaData(info.conditionNames{cond},info.conditionDescriptions{cond},...
                info.trialObs{t},info.refLeg,cond,filename,info.type{cond},info.schenleyLab,info.perceptualTasks,info.datlog{cond});   
         else
            trialMD{t}=trialMetaData(info.conditionNames{cond},info.conditionDescriptions{cond},...
                info.trialObs{t},info.refLeg,cond,filename,info.type{cond},info.schenleyLab,info.perceptualTasks); 
         end
    end 
   
end