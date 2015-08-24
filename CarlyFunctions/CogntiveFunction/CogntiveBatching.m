%CognitiveBatching 07/2015

cd('/Users/carlysombric/Desktop/Lab/GrantPrep2015/Cog Piloting Data')
subs={'forget01', 'Forget02', 'forget04', 'Forget05', 'Forget06', 'Forget07'};%, 'forget03'
%subs={'Forget02'};
%subs={'forget04'};
[RegenCog RegenLabels]=CognitiveCalculator( subs , 1);
%Do I want to save the figures?

%Then would want to save over the Cog data that is already in the files but
%only for the labels that I have recalculated
%cd('/Users/carlysombric/Desktop/UpdatedCode_6_2015/labTools-master/paramFiles')
cd('/Users/carlysombric/Desktop/Temp Storage/ParamFiles/Forget Subs/paramFiles')
h = waitbar(0,'Hold your horses...');
for i=1:length(subs)
    %need to get the current cog things for this person, or create them if
    %they are empty.
    load([subs{i} 'params.mat'])
    if isempty(adaptData.subData.cognitiveScores.labels)==1
        OldLabels=[];
        OldData=[];
    else
    OldLabels=adaptData.subData.cognitiveScores.labels;
    OldData=adaptData.subData.cognitiveScores.scores;
    end
    
    %Generate new matrices that I will alter based on what was regenerated
    NewLabels=OldLabels;
    NewData=OldData;
    
    %Then compare the current cog things to the new things that I just made
    for l=1:length(RegenLabels)
        %X=strcmp(RegenLabels{l}, OldLabels);%THIS ISN"T GOING TO WORK... need to use the thing Pablo showed me
        %X=cellfun(@(x) x==RegenLabels{l}, OldLabels, 'UniformOutput', 1);
        X=find(cellfun(@(x) strcmp(RegenLabels{i, l}, x), OldLabels));
        if isempty(X)==0
            %I will overwrite the current cog things if the label names match
            NewData(X)=RegenCog(i, l);
        else
            %If the label is new I will add it to the subject
            NewLabels=[NewLabels RegenLabels{i, l}];
            NewData=[NewData RegenCog(i, l)];
        end
    end
    %break
    %Then save the changes that I have made
    cogData=cognitiveData(NewLabels,NewData);
    adaptData.subData.cognitiveScores=cogData;
    save([subs{i} 'params'],'adaptData'); %Saving with same var name
    clearvars -except RegenCog RegenLabels subs h
    waitbar(i / length(subs))
end
close(h) 