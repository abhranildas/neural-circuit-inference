function [] = perform_gridsearch(idAnimal)
eval(['load data_' idAnimal '/result2D.mat Param_auto pnts_rhomb gridparam ratemap_representative']);
eval(['load data_' idAnimal '/result1D.mat Frate1D']);
eval(['load data_' idAnimal '/data_gridsearch.mat Alpha Theta Space']);
eval(['mkdir data_' idAnimal '/partial_data']);
mX1D = size(Frate1D{1},2);
strctData = struct('ratemapReg',ratemap_representative,'pnts_rhomb',pnts_rhomb,...
                   'gridparam',gridparam,'Frate1D',Frate1D,'mX1D',mX1D);
strctParams = struct('Alpha',Alpha,'Theta',Theta,'Space',Space);
perform_gridsearch_sub(x1,strctData,strctParams);

function [] = perform_gridsearch_sub(x1,strctData,strctParams)
maxNumCompThreads(1);
Alpha = strctParams.Alpha;
Theta = strctParams.Theta;
Space = strctParams.Space;
Frate1D = strctData.Frate1D;
Ncell = numel(Frate1D);
Ntr = size(Frate1D{1},1);

for trial = 1:Ntr
    tic;
    for gcell = 1:Ncell

        if trial == 1 && gcell == 1
            Params = nan(numel(Space)*numel(Theta)*numel(Alpha),6);
        end
        Ccoef_FR{gcell,trial} = nan(numel(Space)*numel(Theta)*numel(Alpha),1);

        cnt = 1;
        [trial gcell]
        for x2 = Space
            for theta = Theta
                for alpha = Alpha

                    absPhase = [x2/max(Space) x1/max(Space)];
                    strctPred1D = extract_slice_numerically(theta,alpha,absPhase,strctData);
                    slice1D = strctPred1D.slice1D;

                    Ccoef_FR{gcell,trial}(cnt,:) = corr(Frate1D{gcell}(trial,:)',slice1D');

                    if trial == 1 && gcell == 1
                        Params(cnt,:) = [strctPred1D.strpnt theta alpha strctPred1D.endpnt];
                    end
                    cnt = cnt + 1;
                end
            end
        end
    end
    toc;
end

if x1 < 10
    eval(['save data_' idAnimal '/partial_data/data_x0' num2str(x1) '.mat Params Ccoef_FR']);
else
    eval(['save data_' idAnimal '/partial_data/data_x' num2str(x1) '.mat Params Ccoef_FR']); 
end
