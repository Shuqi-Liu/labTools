function MetaCorrelations(SMatrix, results,epoch1,param1,meta, groups,colorOrder)
%lm=MetaCorrelations(SMatrix, results,epoch1,param1,meta, groups,colorOrder)

% Set colors order
if nargin<8 || isempty(colorOrder) || size(colorOrder,2)~=3
    poster_colors;
    colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];
end
   
if length(param1)<=4 && length(meta)<=4
    figure
    hold on
    ah=optimizedSubPlot(length(param1)*length(meta), length(param1), length(meta));
    i=1;
end

for var=1:length(param1)
    if length(param1)>4 || length(meta)>4
    eval(['figure(' num2str(var) ')']);
    hold on
    ah=optimizedSubPlot(length(meta));
    i=1;
    end
    Y=results.(epoch1).indiv.(param1{var})(:,2);
    for cog=1:length(meta)
        %for g=1:length(groups)
            
            subjects=SMatrix.(groups{1}).ID;
            for s=1:length(subjects)
                load([subjects{s} 'params.mat'])
                %adaptData=SMatrix.(groups{g}).adaptData{s};
                if strcmp(meta, 'age')==1
                    X(s, 1)=eval(['adaptData.subData.' meta]);
                else
                    index=find(strcmp(adaptData.subData.cognitiveScores.labels, meta{cog})==1);
                    X(s, 1)=adaptData.subData.cognitiveScores.scores(index);
                end
            end
        %end
        
        groupKey=results.(epoch1).indiv.(param1{var})(:,1);
        groupNums=unique(groupKey);
        %i=var*cog;
        axes(ah(i)); hold on
        for g=groupNums'
            plot(X(groupKey==g),Y(groupKey==g),'.','markerSize',15,'color',colorOrder(g,:))
        end
        
        lm = fitlm(X,Y,'linear');
        Pslope=double(lm.Coefficients{2,4});
        Pintercept=double(lm.Coefficients{1,4});
        Y_fit=lm.Fitted;
        coef=double(lm.Coefficients{:,1});%Intercept=(1, 1), slop=(2,1)
        Rsquared=lm.Rsquared.Ordinary;
        R=corr(X, Y);
        Resid=lm.Residuals.Studentized;
        
        %Pearson Coefficient
        FullMeta=find(isnan(X)~=1);
        [RHO_Pearson,PVAL_Pearson] = corr(X(FullMeta),Y(FullMeta),'type', 'Pearson');
        
        %Spearman Coefficient
        [RHO_Spearman,PVAL_Spearman] = corr(X(FullMeta),Y(FullMeta),'type', 'Spearman');
              
        
        
        plot(X,Y_fit,'k');
        hold on
        
%         label1 = sprintf('r^2 = %0.2f, (p_{slope} = %0.2f) \n Pearson = %0.2f, (p = %0.2f) \n Spearman = %0.2f, (p = %0.2f) ',Rsquared,Pslope, RHO_Pearson, PVAL_Pearson,RHO_Spearman, PVAL_Spearman);
%         h=legend(groups,label1);
%         if length(param1)<=4 && length(meta)<=4
%              x1 = .5.*nanmax(X);
%         y1 = 1.*nanmean(Y);
%         else
         x1 = 1.*nanmax(X);
        y1 = 1.*nanmean(Y);
%         end
        label1 = sprintf('r = %0.2f, \n Pearson = %0.2f, \n  (p = %0.2f) ',R, RHO_Pearson, PVAL_Pearson);
         text(x1,y1,label1,'fontsize',14)
        
        ylabel({[epoch1]; [param1{var}(1:10)]},'fontsize',16)
        xlabel([meta{cog}],'fontsize',16)
        %title({[epoch1 ' ' param1{var} ' vs. ' meta{cog}] ; ['(n = ' num2str(length(subjects)) ')']},'fontsize',16)
        set(gca,'fontsize',14)
        
        axis equal
        axis tight
        axis square
        
        i=i+1;
    end
    
    if length(param1)<=4 && length(meta)<=4
        clearvars -except SMatrix results epoch1 param1 meta  groups colorOrder i ah
        set(gcf,'renderer','painters')
    else
        clearvars -except SMatrix results epoch1 param1 meta  groups colorOrder 
    end
end
set(gcf,'renderer','painters')
end