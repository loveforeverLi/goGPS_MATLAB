%   CLASS Command Interpreter
% =========================================================================
%
% DESCRIPTION
%   Interpreter of goGPS command instructions
%
% EXAMPLE
%   cmd = Command_Interpreter.getInstance();
%
% FOR A LIST OF CONSTANTs and METHODS use doc Command_Interpreter


%--------------------------------------------------------------------------
%               ___ ___ ___
%     __ _ ___ / __| _ | __|
%    / _` / _ \ (_ |  _|__ \
%    \__, \___/\___|_| |___/
%    |___/                    v 1.0 beta 4 ION
%
%--------------------------------------------------------------------------
%  Copyright (C) 2009-2019 Mirko Reguzzoni, Eugenio Realini
%  Written by:       Andrea Gatti
%  Contributors:     Andrea Gatti, ...
%  A list of all the historical goGPS contributors is in CREDITS.nfo
%--------------------------------------------------------------------------
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%--------------------------------------------------------------------------
% 01100111 01101111 01000111 01010000 01010011
%--------------------------------------------------------------------------

classdef Command_Interpreter < handle        
    %% PROPERTIES CONSTANTS
    % ==================================================================================================================================================
    properties (Constant, GetAccess = private)
        OK       = 0;    % No errors
        ERR_UNK  = 1;    % Command unknown
        ERR_NEI  = 2;    % Not Enough Input Parameters
        WRN_TMI  = -3;   % Too Many Inputs
        WRN_MPT  = -100; % Command empty
        
        STR_ERR = {'Commad unknown', ...
            'Not enough input parameters', ...
            'Too many input parameters'};
    end
    %
    %% PROPERTIES COMMAND CONSTANTS
    % ==================================================================================================================================================
    properties (GetAccess = public, SetAccess = private)
        % List of the supported commands
        
        CMD_LOAD        % Load data from the linked RINEX file into the receiver
        CMD_RENAME      % Rename a receiver        
        CMD_EMPTY       % Reset the receiver content
        CMD_EMPTYWORK   % Reset the receiver work space
        CMD_EMPTYOUT    % Reset the receiver output container
        CMD_AZEL        % Compute (or update) Azimuth and Elevation
        CMD_BASICPP     % Basic Point positioning with no correction (useful to compute azimuth and elevation)
        CMD_FIX_POS     % Fix (position) of a receiver
        CMD_PREPRO      % Pre-processing command
        CMD_CODEPP      % Code point positioning
        CMD_PPP         % Precise point positioning
        CMD_NET         % Network undifferenced solution
        CMD_PSRALIGN    % Pseudorange alignement
        CMD_SEID        % SEID processing (synthesise L2)
        CMD_SID         % SID processing (synthesise L2)
        CMD_REMIONO     % SEID processing (reduce L*)
        CMD_KEEP        % Function to keep just some observations into receivers (e.g. rate => constellation)
        CMD_SYNC        % Syncronization among multiple receivers (same rate)
        CMD_OUTDET      % Outlier and cycle-slip detection
        CMD_SHOW        % Display plots and images
        CMD_EXPORT      % Export results
        CMD_PUSHOUT     % push results in output
        CMD_REMSAT      % remove satellites from receivers
        CMD_REMOBS      % Remove some observations from the receiver (given the obs code)
        CMD_REMTMP      % Remove temporary data not used later for pushout
                    
        CMD_PINIT       % parallel request slaves
        CMD_PKILL       % parallel kill slaves
        
        KEY_FOR         % For each session keyword
        KEY_PAR         % For each target (parallel) keyword
        KEY_END         % For/Par marker end
        
        PAR_NAME        % Parameter marker name
        
        PAR_RATE        % Parameter select rate
        PAR_CUTOFF      % Parameter select cutoff
        PAR_SNRTHR      % Parameter select snrthr
        PAR_SS          % Parameter select constellation
        PAR_SYNC        % Parameter sync
        PAR_BAND        % Parameter of the band to be used in the adjustment

        PAR_EXPORT      % Export figure
        PAR_CLOSE       % Close figure after export
        
        PAR_SLAVE       % number of parallel slaves to request
        
        PAR_R_FROM_OUT  % Parameter to indicate to get data from Receiver Out
        PAR_R_FROM_WORK % Parameter to indicate to get data from Receiver Out
        
        PAR_R_FIX_APR   % Parameter to indicate to use position as approximate coordinate        
        
        PAR_M_UNCOMBINED  % Parameter to force the usage if the new uncombined engine
        
        PAR_M_IONO        % Parameter to estimate ionosphere
        PAR_M_CLK         % Parameter to estimate clock
        PAR_M_FREE_NET    % Parameter to let the network free
        
        PAR_M_SEID_PLANE  % Use old approach plane based        
        
        PAR_S_ALL       % show all plots
        PAR_S_DA        % Data availability
        PAR_S_ENU       % ENU positions
        PAR_S_PUP       % EN U positions (Planar Up)
        PAR_S_ENUBSL    % Baseline ENU positions
        PAR_S_PUPBSL    % Baseline EN U positions (Planar Up)
        PAR_S_XYZ       % XYZ positions
        PAR_S_MAP       % positions on map GoogleMaps background
        PAR_S_MAPG      % positions on map GoogleMaps background
        PAR_S_MAPDTM    % positions on map on DTM
        PAR_S_MAPL      % positions on map legacy (no borders)
        PAR_S_CK        % Clock Error
        PAR_S_CKW       % Clock Error of the last session
        PAR_S_SNR       % SNR Signal to Noise Ratio
        PAR_S_SNRI      % SNR Signal to Noise Ratio with Zerniche interpolation
        PAR_S_OSTAT      % Observation statistics
        PAR_S_PSTAT     % Processing statistics
        PAR_S_OCS       % Outliers and cycle slips
        PAR_S_OCSP      % Outliers and cycle slips (polar plot)
        PAR_S_RES       % Residuals cartesian
        PAR_S_RES_PSAT  % Residuals satellite per satellite
        PAR_S_RES_SKY   % Residuals sky plot
        PAR_S_RES_SKYP  % Residuals sky plot (polar plot)
        PAR_S_NSAT      % N. of satellites seen per epoch
        PAR_S_NSATSS    % N. of satellites seen constelation by constellation
        PAR_S_NSATSSS   % N. of satellites seen constelation by constellation (smooth)
        PAR_S_ZTD       % ZTD
        PAR_S_ZHD       % ZHD
        PAR_S_ZWD       % ZWD
        PAR_S_ZTD_VSH   % ZTD vs Height
        PAR_S_ZWD_VSH   % ZWD vs Height
        PAR_S_PWV       % PWV
        PAR_S_PTH       % PTH
        PAR_S_STD       % ZTD Slant
        PAR_S_RES_STD   % Slant Total Delay Residuals (polar plot)
              
        PAR_E_CORE_MAT  % Export core in .mat format
        PAR_E_PLAIN_MAT % Export computed results in simple mat format (no objects)
        PAR_E_REC_MAT   % Receiver export parameter MATLAB format
        PAR_E_REC_RIN   % Receiver export parameter RINEX format
        PAR_E_TROPO_SNX % Tropo export Parameter sinex format
        PAR_E_TROPO_MAT % Tropo export Parameter mat format
        PAR_E_TROPO_CSV % Tropo export Parameter csv format
        PAR_E_TROPO_HN % Tropo export Parameter hn format

        PAR_E_COO_CRD   % Coordinates in bernese crd format
        PAR_E_COO_CSV   % Coordinates in bernese crd format

        PAR_S_SAVE      % flage for saving                
                
        KEY_LIST = {'FOR', 'PAR', 'END'};
        CMD_LIST = {'PINIT', 'PKILL', 'LOAD', 'RENAME', 'EMPTY', 'EMPTYWORK', 'EMPTYOUT', 'AZEL', 'BASICPP', 'PREPRO', 'FIX_POS', 'CODEPP', 'PPP', 'NET', 'SEID', 'SID', 'REMIONO', 'KEEP', 'SYNC', 'OUTDET', 'SHOW', 'EXPORT', 'PUSHOUT', 'REMSAT', 'REMOBS', 'REMTMP', 'PSRALIGN'};
        PUSH_LIST = {'PPP','NET','CODEPP','AZEL'};
        VALID_CMD = {};
        CMD_ID = [];
        KEY_ID = [];
        % Struct containing cells are not created properly as constant => see init method
    end
    %
    %% PROPERTIES SINGLETON POINTERS
    % ==================================================================================================================================================
    properties % Utility Pointers to Singletons
        log
        core
    end
    %
    %% METHOD CREATOR
    % ==================================================================================================================================================
    methods (Static, Access = public)
        % Concrete implementation.  See Singleton superclass.
        function this = Command_Interpreter(varargin)
            % Core object creator
            this.log = Logger.getInstance();
            this.init(varargin{1});
        end
    end
    
    %
    %% METHODS INIT
    % ==================================================================================================================================================
    methods
        function init(this, core)
            % Define and fill the "CONSTANT" structures of the class
            % Due to MATLAB limits it is not possible to create cells into struct on declaration
            %
            % SYNTAX:
            %   this.init()
            
            % definition of parameters (ToDo: these should be converted into objects)
            % in the definition the character "$" indicate the parameter value
            
            if nargin == 2
                if iscell(core) && ~isempty(core) && ~isempty(core{1})
                    core = core{1};
                end
                if ~isempty(core)
                    this.core = core;
                end
            end
            
            this.PAR_NAME.name = 'Marker name';
            this.PAR_NAME.descr = 'NAME                Marker name';
            this.PAR_NAME.par = '.';

            this.PAR_RATE.name = 'rate';
            this.PAR_RATE.descr = '@<rate>            Processing rate in seconds (e.g. @30s, -r=30s)';
            this.PAR_RATE.par = '(\@)|(\-r\=)|(\-\-rate\=)'; % (regexp) parameter prefix: @ | -r= | --rate= 
            this.PAR_RATE.class = 'double';
            this.PAR_RATE.limits = [0.000001 900];
            this.PAR_RATE.accepted_values = [];
            
            this.PAR_CUTOFF.name = 'cut-off';
            this.PAR_CUTOFF.descr = '-e=<elevation>     Elevation in degree (e.g. -e=7)';
            this.PAR_CUTOFF.par = '(\-e\=)|(\-\-cutoff\=)'; % (regexp) parameter prefix: @ | -e= | --cutoff= 
            this.PAR_CUTOFF.class = 'double';
            this.PAR_CUTOFF.limits = [0 90];
            this.PAR_CUTOFF.accepted_values = [];

            this.PAR_SNRTHR.name = 'SNR threshold';
            this.PAR_SNRTHR.descr = '-q=<snrthr>        SNR threshold in dbHZ on L1 (e.g. -q=7)';
            this.PAR_SNRTHR.par = '(\-q\=)|(\-\-snrthr\=)'; % (regexp) parameter prefix: @ | -q= | --snrthr= 
            this.PAR_SNRTHR.class = 'double';
            this.PAR_SNRTHR.limits = [0 70];
            this.PAR_SNRTHR.accepted_values = [];

            this.PAR_SS.name = 'constellation';
            this.PAR_SS.descr = '-s=<sat_list>      Active constellations (e.g. -s=GRE)';
            this.PAR_SS.par = '(\-s\=)|(\-\-constellation\=)'; % (regexp) parameter prefix: -s --constellation
            this.PAR_SS.class = 'char';
            this.PAR_SS.limits = [];
            this.PAR_SS.accepted_values = [];
            
            this.PAR_SYNC.name = 'sync results';
            this.PAR_SYNC.descr = '--sync             Use syncronized time only';
            this.PAR_SYNC.par = '(\-\-sync)';
            this.PAR_SYNC.class = '';
            this.PAR_SYNC.limits = [];
            this.PAR_SYNC.accepted_values = [];
            
            this.PAR_SLAVE.name = '(MANDATORY) Number of slaves';
            this.PAR_SLAVE.descr = '-n=<num_slaves>    minimum number of parallel slaves to request';
            this.PAR_SLAVE.par = '(N)|(-n\=)';
            this.PAR_SLAVE.class = 'double';
            this.PAR_SLAVE.limits = [1 1000];
            this.PAR_SLAVE.accepted_values = [];
                                    
            this.PAR_BAND.name = 'band';
            this.PAR_BAND.descr = 'L<band>            band to be used for single frequency adjustment';
            this.PAR_BAND.par = '(\-L\=)|(L[0-9])'; % (regexp) parameter prefix: @ | -r= | --rate= 
            this.PAR_BAND.class = 'double';
            this.PAR_BAND.limits = [1 5];
            this.PAR_BAND.accepted_values = [];

            this.PAR_EXPORT.name = 'export';
            this.PAR_EXPORT.descr = '-e=<"name">        Export with name_prefix';
            this.PAR_EXPORT.par = '(\-e)|(\-e\=)|(\-\-export\=)'; % (regexp) parameter prefix: -e --export
            this.PAR_EXPORT.class = 'char';
            this.PAR_EXPORT.limits = [];
            this.PAR_EXPORT.accepted_values = [];

            this.PAR_CLOSE.name = 'close';
            this.PAR_CLOSE.descr = '-c                 Close figure after export (valid only if export is present)';
            this.PAR_CLOSE.par = '(\-c)|(\-\-close)'; % (regexp) parameter prefix: -c --close
            this.PAR_CLOSE.class = '';
            this.PAR_CLOSE.limits = [];
            this.PAR_CLOSE.accepted_values = [];

            %  Method parameter
            
            this.PAR_M_UNCOMBINED.name = 'Use the Uncombined new experimental engine';
            this.PAR_M_UNCOMBINED.descr = '-u                 (flag) use the new (experimental) uncombined engine';
            this.PAR_M_UNCOMBINED.par = '(-u)|(-U)|(--uncombined)|(--UNCOMBINED)';
            this.PAR_M_UNCOMBINED.class = '';
            this.PAR_M_UNCOMBINED.limits = [];
            this.PAR_M_UNCOMBINED.accepted_values = [];

            this.PAR_M_FREE_NET.name = 'Free network';
            this.PAR_M_FREE_NET.descr = '--free              Let the network free';
            this.PAR_M_FREE_NET.par = '(-f)(--free)|(--FREE)';
            this.PAR_M_FREE_NET.class = '';
            this.PAR_M_FREE_NET.limits = [];
            this.PAR_M_FREE_NET.accepted_values = [];
        
            this.PAR_M_IONO.name = 'Reduce for ionosphere delay';
            this.PAR_M_IONO.descr = '--iono             Reduce for ionosphere delay';
            this.PAR_M_IONO.par = '(-i)|(-I)|(--iono)|(--IONO)';
            this.PAR_M_IONO.class = '';
            this.PAR_M_IONO.limits = [];
            this.PAR_M_IONO.accepted_values = [];
            
            this.PAR_M_CLK.name = 'Export clock';
            this.PAR_M_CLK.descr = '--clk              Export common Parameter in network';
            this.PAR_M_CLK.par = '(-c)|(-C)|(--clk)|(--Clk)|(--CLK)';
            this.PAR_M_CLK.class = '';
            this.PAR_M_CLK.limits = [];
            this.PAR_M_CLK.accepted_values = [];

            this.PAR_M_SEID_PLANE.name = 'Use original plane based SEID';
            this.PAR_M_SEID_PLANE.descr = 'PLANE              (flag) use a plane for the interpolation of the geometry free';
            this.PAR_M_SEID_PLANE.par = '(PLANE)|(plane)|(OLD)|(old)';
            this.PAR_M_SEID_PLANE.class = '';
            this.PAR_M_SEID_PLANE.limits = [];
            this.PAR_M_SEID_PLANE.accepted_values = [];
            
            % Receiver parameter
            
            this.PAR_R_FROM_OUT.name = 'From OUT';
            this.PAR_R_FROM_OUT.descr = 'FROM_OUT           (flag) use data from Receiver Output object';
            this.PAR_R_FROM_OUT.par = '(FROM_OUT)|(from_out)';

            this.PAR_R_FROM_WORK.name = 'From WORK';
            this.PAR_R_FROM_WORK.descr = 'FROM_WORK          (flag) use data from Work Space (current session)';
            this.PAR_R_FROM_WORK.par = '(FROM_WORK)|(from_work)';
            
            this.PAR_R_FIX_APR.name = 'Approximate position';
            this.PAR_R_FIX_APR.descr = 'AS_APR           (flag) use position as a new a-priori position (not as fixed)';
            this.PAR_R_FIX_APR.par = '(AS_APR)|(AS_APPROXIMATE)|(as_approximate)';
            
            % Show plots

            this.PAR_S_ALL.name = 'Show all the plots';
            this.PAR_S_ALL.descr = 'SHOWALL';
            this.PAR_S_ALL.par = '(ALL)|(all)';
            this.PAR_S_ALL.class = '';
            this.PAR_S_ALL.limits = [];
            this.PAR_S_ALL.accepted_values = [];
            
            this.PAR_S_DA.name = 'Data availability';
            this.PAR_S_DA.descr = 'DA                 Data Availability';
            this.PAR_S_DA.par = '(DA)|(\-\-dataAvailability)|(da)';
            this.PAR_S_DA.class = '';
            this.PAR_S_DA.limits = [];
            this.PAR_S_DA.accepted_values = [];

            this.PAR_S_ENU.name = 'ENU positions';
            this.PAR_S_ENU.descr = 'ENU                East Nord Up positions';
            this.PAR_S_ENU.par = '(ENU)|(enu)';
            this.PAR_S_ENU.class = '';
            this.PAR_S_ENU.limits = [];
            this.PAR_S_ENU.accepted_values = [];

            this.PAR_S_PUP.name = 'Planar Up positions';
            this.PAR_S_PUP.descr = 'PUP                Planar Up positions';
            this.PAR_S_PUP.par = '(PUP)|(pup)';
            this.PAR_S_PUP.class = '';
            this.PAR_S_PUP.limits = [];
            this.PAR_S_PUP.accepted_values = [];

            this.PAR_S_ENUBSL.name = 'ENU baseline';
            this.PAR_S_ENUBSL.descr = 'ENUBSL             East Nord Up baseline';
            this.PAR_S_ENUBSL.par = '(ENUBSL)|(enu_base)';
            this.PAR_S_ENUBSL.class = '';
            this.PAR_S_ENUBSL.limits = [];
            this.PAR_S_ENUBSL.accepted_values = [];

            this.PAR_S_PUPBSL.name = 'Planar Up baseline';
            this.PAR_S_PUPBSL.descr = 'PUPBSL             Planar Up baseline';
            this.PAR_S_PUPBSL.par = '(PUPBSL)|(pup_base)';
            this.PAR_S_PUPBSL.class = '';
            this.PAR_S_PUPBSL.limits = [];
            this.PAR_S_PUPBSL.accepted_values = [];

            this.PAR_S_XYZ.name = 'XYZ positions';
            this.PAR_S_XYZ.descr = 'XYZ                XYZ Earth Fixed Earth centered positions';
            this.PAR_S_XYZ.par = '(XYZ)|(xyz)';
            this.PAR_S_XYZ.class = '';
            this.PAR_S_XYZ.limits = [];
            this.PAR_S_XYZ.accepted_values = [];

            this.PAR_S_MAP.name = 'Map of Receiver locations';
            this.PAR_S_MAP.descr = 'MAP                Map of station coordinates (Google Maps Background)';
            this.PAR_S_MAP.par = '(MAP)|(map)';
            this.PAR_S_MAP.class = '';
            this.PAR_S_MAP.limits = [];
            this.PAR_S_MAP.accepted_values = [];

            this.PAR_S_MAPG.name = 'Map of Receiver locations';
            this.PAR_S_MAPG.descr = 'G_MAP              Map of station coordinates (Google Maps Background)';
            this.PAR_S_MAPG.par = '(G_MAP)|(g_map)';
            this.PAR_S_MAPG.class = '';
            this.PAR_S_MAPG.limits = [];
            this.PAR_S_MAPG.accepted_values = [];

            this.PAR_S_MAPDTM.name = 'Map of Receiver locations';
            this.PAR_S_MAPDTM.descr = 'DTM_MAP            Map of station coordinates (DTM background)';
            this.PAR_S_MAPDTM.par = '(DTM_MAP)|(dtm_map)';
            this.PAR_S_MAPDTM.class = '';
            this.PAR_S_MAPDTM.limits = [];
            this.PAR_S_MAPDTM.accepted_values = [];

            this.PAR_S_MAPL.name = 'Map of Receiver locations';
            this.PAR_S_MAPL.descr = 'L_MAP              Legacy map of station coordinates (Google Maps background)';            
            this.PAR_S_MAPL.par = '(L_MAP)|(l_map)';
            this.PAR_S_MAPL.class = '';
            this.PAR_S_MAPL.limits = [];
            this.PAR_S_MAPL.accepted_values = [];
            
            this.PAR_S_CK.name = 'Clock Error';
            this.PAR_S_CK.descr = 'CK                 Clock errors';
            this.PAR_S_CK.par = '(ck)|(CK)';
            this.PAR_S_CK.class = '';
            this.PAR_S_CK.limits = [];
            this.PAR_S_CK.accepted_values = [];

            this.PAR_S_CKW.name = 'Clock Error of the last session (work-space)';
            this.PAR_S_CKW.descr = 'CKW                Clock errors of the last session';
            this.PAR_S_CKW.par = '(ckw)|(CKW)';
            this.PAR_S_CKW.class = '';
            this.PAR_S_CKW.limits = [];
            this.PAR_S_CKW.accepted_values = [];

            this.PAR_S_SNR.name = 'SNR Signal to Noise Ratio';
            this.PAR_S_SNR.descr = 'SNR                Signal to Noise Ratio (polar plot)';
            this.PAR_S_SNR.par = '(snr)|(SNR)';
            this.PAR_S_SNR.class = '';
            this.PAR_S_SNR.limits = [];
            this.PAR_S_SNR.accepted_values = [];
            
            this.PAR_S_SNRI.name = 'SNRI Signal to Noise Ratio Interpolated Map';
            this.PAR_S_SNRI.descr = 'SNRI               Signal to Noise Ratio (polar plot, interpolated map)';
            this.PAR_S_SNRI.par = '(snri)|(SNRI)';
            this.PAR_S_SNRI.class = '';
            this.PAR_S_SNRI.limits = [];
            this.PAR_S_SNRI.accepted_values = [];

            this.PAR_S_OSTAT.name = 'Observation statistics';
            this.PAR_S_OSTAT.descr = 'OSTAT              Observation stats (last session)';
            this.PAR_S_OSTAT.par = '(ostat)|(OSTAT)|(o_stat)|(O_STAT)|(obs_stat)|(OBS_STAT)';
            this.PAR_S_OSTAT.class = '';
            this.PAR_S_OSTAT.limits = [];
            this.PAR_S_OSTAT.accepted_values = [];

            this.PAR_S_PSTAT.name = 'Processing statistics';
            this.PAR_S_PSTAT.descr = 'PSTAT              Processing stats (multi-session)';
            this.PAR_S_PSTAT.par = '(pstat)|(PSTAT)|(p_stat)|(P_STAT)|(pro_stat)|(PRO_STAT)';
            this.PAR_S_PSTAT.class = '';
            this.PAR_S_PSTAT.limits = [];
            this.PAR_S_PSTAT.accepted_values = [];
            
            this.PAR_S_OCS.name = 'Outliers and cycle slips';
            this.PAR_S_OCS.descr = 'OCS                Outliers and cycle slips';
            this.PAR_S_OCS.par = '(ocs)|(OCS)';
            this.PAR_S_OCS.class = '';
            this.PAR_S_OCS.limits = [];
            this.PAR_S_OCS.accepted_values = [];
            
            this.PAR_S_OCSP.name = 'Outliers and cycle slips (polar plot)';
            this.PAR_S_OCSP.descr = 'OCSP               Outliers and cycle slips (polar plot)';
            this.PAR_S_OCSP.par = '(ocsp)|(OCSP)';
            this.PAR_S_OCSP.class = '';
            this.PAR_S_OCSP.limits = [];
            this.PAR_S_OCSP.accepted_values = [];
            
            this.PAR_S_RES.name = 'Residuals plot';
            this.PAR_S_RES.descr = 'RES                Residual plot';
            this.PAR_S_RES.par = '(res)|(RES)';
            this.PAR_S_RES.class = '';
            this.PAR_S_RES.limits = [];
            this.PAR_S_RES.accepted_values = [];

            this.PAR_S_RES_PSAT.name = 'Residuals per satellite (colored)';
            this.PAR_S_RES_PSAT.descr = 'RES_PSAT           Residuals per satellite';
            this.PAR_S_RES_PSAT.par = '(res_psat)|(RES_PSAT)';
            this.PAR_S_RES_PSAT.class = '';
            this.PAR_S_RES_PSAT.limits = [];
            this.PAR_S_RES_PSAT.accepted_values = [];
            
            this.PAR_S_RES_SKY.name = 'Residuals sky plot';
            this.PAR_S_RES_SKY.descr = 'RES_SKY            Residual sky plot';
            this.PAR_S_RES_SKY.par = '(res_sky)|(RES_SKY)';
            this.PAR_S_RES_SKY.class = '';
            this.PAR_S_RES_SKY.limits = [];
            this.PAR_S_RES_SKY.accepted_values = [];

            this.PAR_S_RES_SKYP.name = 'Residuals sky plot (polar plot)';
            this.PAR_S_RES_SKYP.descr = 'RES_SKYP           Residual sky plot (polar plot)';
            this.PAR_S_RES_SKYP.par = '(res_skyp)|(RES_SKYP)';
            this.PAR_S_RES_SKYP.class = '';
            this.PAR_S_RES_SKYP.limits = [];
            this.PAR_S_RES_SKYP.accepted_values = [];

            this.PAR_S_NSAT.name = 'Number of satellites used per epoch';            
            this.PAR_S_NSAT.descr = 'NSAT               Number of satellite used (multi-receiver)';
            this.PAR_S_NSAT.par = '(nsat)|(NSAT)';
            this.PAR_S_NSAT.class = '';
            this.PAR_S_NSAT.limits = [];
            this.PAR_S_NSAT.accepted_values = [];

            this.PAR_S_NSATSS.name = 'Number of satellites used per epoch System by System';            
            this.PAR_S_NSATSS.descr = 'NSATSS             Number of satellite used (sys by sys)';
            this.PAR_S_NSATSS.par = '(nsatss)|(NSATSS)';
            this.PAR_S_NSATSS.class = '';
            this.PAR_S_NSATSS.limits = [];
            this.PAR_S_NSATSS.accepted_values = [];
            
            this.PAR_S_NSATSSS.name = 'Number of satellites used per epoch System by System (smooth)';            
            this.PAR_S_NSATSSS.descr = 'NSATSSS            Smoothed number of satellite used (sys by sys)';
            this.PAR_S_NSATSSS.par = '(nsatsss)|(NSATSSS)';
            this.PAR_S_NSATSSS.class = '';
            this.PAR_S_NSATSSS.limits = [];
            this.PAR_S_NSATSSS.accepted_values = [];

            this.PAR_S_ZTD.name = 'ZTD';
            this.PAR_S_ZTD.descr = 'ZTD                Zenith Total Delay';
            this.PAR_S_ZTD.par = '(ztd)|(ZTD)';
            this.PAR_S_ZTD.class = '';
            this.PAR_S_ZTD.limits = [];
            this.PAR_S_ZTD.accepted_values = [];

            this.PAR_S_ZTD_VSH.name = 'ZTD_VSH';
            this.PAR_S_ZTD_VSH.descr = 'ZTD_VSH            Zenith Total Delay vs Height';
            this.PAR_S_ZTD_VSH.par = '(ztd_vsh)|(ZTD_VSH)';
            this.PAR_S_ZTD_VSH.class = '';
            this.PAR_S_ZTD_VSH.limits = [];
            this.PAR_S_ZTD_VSH.accepted_values = [];

            this.PAR_S_ZHD.name = 'ZHD';
            this.PAR_S_ZHD.descr = 'ZHD                Zenith Hydrostatic Delay';
            this.PAR_S_ZHD.par = '(zhd)|(ZHD)';
            this.PAR_S_ZHD.class = '';
            this.PAR_S_ZHD.limits = [];
            this.PAR_S_ZHD.accepted_values = [];

            this.PAR_S_ZWD.name = 'ZWD';
            this.PAR_S_ZWD.descr = 'ZWD                Zenith Wet Delay';
            this.PAR_S_ZWD.par = '(zwd)|(ZWD)';
            this.PAR_S_ZWD.class = '';
            this.PAR_S_ZWD.limits = [];
            this.PAR_S_ZWD.accepted_values = [];

            this.PAR_S_ZWD_VSH.name = 'ZWD_VSH';
            this.PAR_S_ZWD_VSH.descr = 'ZWD_VSH            Zenith Wet Delay vs Height';
            this.PAR_S_ZWD_VSH.par = '(zwd_vsh)|(ZWD_VSH)';
            this.PAR_S_ZWD_VSH.class = '';
            this.PAR_S_ZWD_VSH.limits = [];
            this.PAR_S_ZWD_VSH.accepted_values = [];

            this.PAR_S_PWV.name = 'PWV';
            this.PAR_S_PWV.descr = 'PWV                Precipitable Water Vapour';
            this.PAR_S_PWV.par = '(pwv)|(PWV)';
            this.PAR_S_PWV.class = '';
            this.PAR_S_PWV.limits = [];
            this.PAR_S_PWV.accepted_values = [];

            this.PAR_S_PTH.name = 'PTH';
            this.PAR_S_PTH.descr = 'PTH                Pressure / Temperature / Humidity';
            this.PAR_S_PTH.par = '(pth)|(PTH)';
            this.PAR_S_PTH.class = '';
            this.PAR_S_PTH.limits = [];
            this.PAR_S_PTH.accepted_values = [];

            this.PAR_S_STD.name = 'ZTD Slant';
            this.PAR_S_STD.descr = 'STD                Zenith Total Delay with slants';
            this.PAR_S_STD.par = '(std)|(STD)';
            this.PAR_S_STD.class = '';
            this.PAR_S_STD.limits = [];
            this.PAR_S_STD.accepted_values = [];

            this.PAR_S_RES_STD.name = 'Slant Total Delay Residuals (polar plot)';
            this.PAR_S_RES_STD.descr = 'RES_STD            Slants Total Delay residuals (polar plot)';
            this.PAR_S_RES_STD.par = '(res_std)|(RES_STD)';
            this.PAR_S_RES_STD.class = '';
            this.PAR_S_RES_STD.limits = [];
            this.PAR_S_RES_STD.accepted_values = [];

            this.PAR_E_CORE_MAT.name = 'CORE MATLAB format';
            this.PAR_E_CORE_MAT.descr = 'CORE_MAT           Save the core as .mat file';
            this.PAR_E_CORE_MAT.par = '(core_mat)|(CORE_MAT)';
            this.PAR_E_CORE_MAT.class = '';
            this.PAR_E_CORE_MAT.limits = [];
            this.PAR_E_CORE_MAT.accepted_values = {};
            
            this.PAR_E_PLAIN_MAT.name = 'Output in plain MATLAB format';
            this.PAR_E_PLAIN_MAT.descr = 'PLAIN_MAT          Save the receiver as plain .mat files (no objects)';
            this.PAR_E_PLAIN_MAT.par = '(plain_mat)|(PLAIN_MAT)';
            this.PAR_E_PLAIN_MAT.class = '';
            this.PAR_E_PLAIN_MAT.limits = [];
            this.PAR_E_PLAIN_MAT.accepted_values = {};

            this.PAR_E_REC_MAT.name = 'Receiver MATLAB format';
            this.PAR_E_REC_MAT.descr = 'REC_MAT            Receiver object as .mat file';
            this.PAR_E_REC_MAT.par = '(rec_mat)|(REC_MAT)';
            this.PAR_E_REC_MAT.class = '';
            this.PAR_E_REC_MAT.limits = [];
            this.PAR_E_REC_MAT.accepted_values = {};

            this.PAR_E_REC_RIN.name = 'RINEX v3';
            this.PAR_E_REC_RIN.descr = 'REC_RIN            Rinex file containing the actual data stored in rec.work';
            this.PAR_E_REC_RIN.par = '(REC_RIN)|(rec_rin)|(rin3)|(RIN3)';
            this.PAR_E_REC_RIN.class = '';
            this.PAR_E_REC_RIN.limits = [];
            this.PAR_E_REC_RIN.accepted_values = {};

            this.PAR_E_TROPO_SNX.name = 'TROPO Sinex';
            this.PAR_E_TROPO_SNX.descr = 'TRP_SNX            Tropo parameters as SINEX file';
            this.PAR_E_TROPO_SNX.par = '(trp_snx)|(TRP_SNX)';
            this.PAR_E_TROPO_SNX.class = '';
            this.PAR_E_TROPO_SNX.limits = [];
            this.PAR_E_TROPO_SNX.accepted_values = {'ZTD','GN','GE','ZWD','PWV','P','T','H'};

            this.PAR_E_TROPO_MAT.name = 'TROPO MATLAB format';
            this.PAR_E_TROPO_MAT.descr = 'TRP_MAT            Tropo parameters MATLAB as .mat file';
            this.PAR_E_TROPO_MAT.par = '(trp_mat)|(TRP_MAT)';
            this.PAR_E_TROPO_MAT.class = '';
            this.PAR_E_TROPO_MAT.limits = [];
            this.PAR_E_TROPO_MAT.accepted_values = {};
            
            this.PAR_E_TROPO_HN.name = 'TROPO HydroNet format';
            this.PAR_E_TROPO_HN.descr = 'TRP_HN             Tropo parameters as a hydroNet (CSV like) file';
            this.PAR_E_TROPO_HN.par = '(trp_hn)|(TRP_HN)';
            this.PAR_E_TROPO_HN.class = '';
            this.PAR_E_TROPO_HN.limits = [];
            this.PAR_E_TROPO_HN.accepted_values = {};
            
            this.PAR_E_TROPO_CSV.name = 'TROPO CSV format';
            this.PAR_E_TROPO_CSV.descr = 'TRP_CSV            Tropo parameters MATLAB as .csv file';
            this.PAR_E_TROPO_CSV.par = '(trp_csv)|(TRP_CSV)';
            this.PAR_E_TROPO_CSV.class = '';
            this.PAR_E_TROPO_CSV.limits = [];
            this.PAR_E_TROPO_CSV.accepted_values = {};
                                    
            this.PAR_E_COO_CRD.name = 'Coordinates bernese CRD format';
            this.PAR_E_COO_CRD.descr = 'COO_CRD            Coordinates Bernese .CRD file';
            this.PAR_E_COO_CRD.par = '(coo_crd)|(COO_CRD)';
            this.PAR_E_COO_CRD.class = '';
            this.PAR_E_COO_CRD.limits = [];
            this.PAR_E_COO_CRD.accepted_values = {};
            
            this.PAR_E_COO_CSV.name = 'Coordinates CSV format';
            this.PAR_E_COO_CSV.descr = 'COO_CSV            Coordinates .csv file';
            this.PAR_E_COO_CSV.par = '(coo_csv)|(COO_CSV)';
            this.PAR_E_COO_CSV.class = '';
            this.PAR_E_COO_CSV.limits = [];
            this.PAR_E_COO_CSV.accepted_values = {};
            
            % definition of commands
            
            new_line = [char(10) '             ']; %#ok<CHARTEN>
            this.CMD_LOAD.name = {'LOAD', 'load'};
            this.CMD_LOAD.descr = 'Import the RINEX file linked with this receiver';
            this.CMD_LOAD.rec = 'T';
            this.CMD_LOAD.par = [this.PAR_SS, this.PAR_RATE];

            this.CMD_RENAME.name = {'RENAME', 'rename', 'ren'};
            this.CMD_RENAME.descr = ['Rename a receiver (change marker name)' new_line 'WARNING: Every load will reset this name' new_line 'Useful for final plots'];
            this.CMD_RENAME.rec = 'T';
            this.CMD_RENAME.par = [this.PAR_NAME];

            this.CMD_EMPTY.name = {'EMPTY', 'empty'};
            this.CMD_EMPTY.descr = 'Empty the entire receiver';
            this.CMD_EMPTY.rec = 'T';
            this.CMD_EMPTY.par = [];

            this.CMD_EMPTYWORK.name = {'EMPTYWORK', 'emptywork'};
            this.CMD_EMPTYWORK.descr = 'Empty the receiver work space object';
            this.CMD_EMPTYWORK.rec = 'T';
            this.CMD_EMPTYWORK.par = [];

            this.CMD_EMPTYOUT.name = {'EMPTYOUT', 'emptyout'};
            this.CMD_EMPTYOUT.descr = 'Empty the receiver output object';
            this.CMD_EMPTYOUT.rec = 'T';
            this.CMD_EMPTYOUT.par = [];

            this.CMD_AZEL.name = {'AZEL', 'UPDATE_AZEL', 'update_azel', 'azel'};
            this.CMD_AZEL.descr = 'Compute Azimuth and elevation ';
            this.CMD_AZEL.rec = 'T';
            this.CMD_AZEL.par = [];

            this.CMD_BASICPP.name = {'BASICPP', 'PP', 'basic_pp', 'pp'};
            this.CMD_BASICPP.descr = 'Basic Point positioning with no correction';
            this.CMD_BASICPP.rec = 'T';
            this.CMD_BASICPP.par = [this.PAR_RATE this.PAR_SS];

            this.CMD_PREPRO.name = {'PREPRO', 'pre_processing'};
            this.CMD_PREPRO.descr = ['Code positioning, computation of satellite positions and various' new_line 'corrections'];
            this.CMD_PREPRO.rec = 'T';
            this.CMD_PREPRO.par = [this.PAR_RATE this.PAR_SS];
            
            this.CMD_FIX_POS.name = {'FIXPOS', 'fixpos'};
            this.CMD_FIX_POS.descr = 'Fix position';
            this.CMD_FIX_POS.rec = 'T';
            this.CMD_FIX_POS.par = [this.PAR_R_FROM_WORK this.PAR_R_FROM_OUT this.PAR_R_FIX_APR];
            
            this.CMD_CODEPP.name = {'CODEPP', 'ls_code_point_positioning'};
            this.CMD_CODEPP.descr = 'Code positioning';
            this.CMD_CODEPP.rec = 'T';
            this.CMD_CODEPP.par = [this.PAR_RATE this.PAR_SS];
            
            this.CMD_PPP.name = {'PPP', 'precise_point_positioning'};
            this.CMD_PPP.descr = 'Precise Point Positioning using carrier phase observations';
            this.CMD_PPP.rec = 'T';
            this.CMD_PPP.par = [this.PAR_RATE this.PAR_SS this.PAR_SYNC this.PAR_M_UNCOMBINED];
            
            this.CMD_NET.name = {'NET', 'network'};
            this.CMD_NET.descr = 'Network solution using undifferenced carrier phase observations';
            this.CMD_NET.rec = 'TR';
            this.CMD_NET.par = [this.PAR_RATE this.PAR_SS this.PAR_SYNC this.PAR_E_COO_CRD this.PAR_M_IONO this.PAR_M_CLK this.PAR_BAND this.PAR_M_FREE_NET this.PAR_M_UNCOMBINED];
            
            this.CMD_PSRALIGN.name = {'PSRALIGN', 'pseudorange_align'};
            this.CMD_PSRALIGN.descr = 'Align pseudorange of a network to the best observables';
            this.CMD_PSRALIGN.rec = 'T';
            this.CMD_PSRALIGN.par = [];
            
            this.CMD_SEID.name = {'SEID', 'synthesise_L2'};
            this.CMD_SEID.descr = ['Generate a Synthesised L2 on a target receiver ' new_line 'using n (dual frequencies) reference stations' new_line 'SEID (Satellite specific Epoch differenced Ionospheric Delay model)'];
            this.CMD_SEID.rec = 'RT';
            this.CMD_SEID.par = [this.PAR_M_SEID_PLANE];

            this.CMD_SID.name = {'SID', 'synthesise_L2'};
            this.CMD_SID.descr = ['Generate a Synthesised L2 on a target receiver ' new_line 'using n (dual frequencies) reference stations' new_line 'SID (Satellite specific Ionospheric Delay model)' new_line 'New SEID approch based on a joint Least Squares estimation instead of time differenciation'];
            this.CMD_SID.rec = 'RT';
            this.CMD_SID.par = [];

            this.CMD_REMIONO.name = {'REMIONO', 'remove_iono'};
            this.CMD_REMIONO.descr = ['Remove ionosphere from observations on a target receiver' new_line 'using n (dual frequencies) reference stations' new_line 'Sligthly different approach w.r.t. SEID'];
            this.CMD_REMIONO.rec = 'RT';
            this.CMD_REMIONO.par = [];
            
            this.CMD_KEEP.name = {'KEEP'};
            this.CMD_KEEP.descr = ['Keep in the object the data of a certain constallation' new_line 'at a certain rate'];
            this.CMD_KEEP.rec = 'T';
            this.CMD_KEEP.par = [this.PAR_RATE this.PAR_SS this.PAR_CUTOFF this.PAR_SNRTHR];
            
            this.CMD_SYNC.name = {'SYNC'};
            this.CMD_SYNC.descr = ['Syncronize all the receivers at the same rate ' new_line '(with the minimal data span)'];
            this.CMD_SYNC.rec = 'T';
            this.CMD_SYNC.par = [this.PAR_RATE];
            
            this.CMD_OUTDET.name = {'OUTDET', 'outlier_detection', 'cycle_slip_detection'};
            this.CMD_OUTDET.descr = 'Force outlier and cycle slip detection';
            this.CMD_OUTDET.rec = 'T';
            this.CMD_OUTDET.par = [];

            this.CMD_SHOW.name = {'SHOW'};
            this.CMD_SHOW.descr = 'Display various plots / images';
            this.CMD_SHOW.rec = 'T';
            this.CMD_SHOW.par = [this.PAR_SS this.PAR_EXPORT this.PAR_CLOSE this.PAR_S_MAP this.PAR_S_MAPL this.PAR_S_MAPDTM this.PAR_S_DA this.PAR_S_ENU this.PAR_S_PUP this.PAR_S_ENUBSL this.PAR_S_PUPBSL this.PAR_S_XYZ this.PAR_S_CKW this.PAR_S_CK this.PAR_S_SNR this.PAR_S_SNRI this.PAR_S_OSTAT this.PAR_S_PSTAT this.PAR_S_OCS this.PAR_S_OCSP this.PAR_S_RES this.PAR_S_RES_PSAT this.PAR_S_RES_SKY this.PAR_S_RES_SKYP this.PAR_S_PTH this.PAR_S_NSAT this.PAR_S_NSATSS this.PAR_S_NSATSSS this.PAR_S_ZTD this.PAR_S_ZTD_VSH this.PAR_S_ZHD this.PAR_S_ZWD this.PAR_S_ZWD_VSH this.PAR_S_PWV this.PAR_S_STD this.PAR_S_RES_STD];

            this.CMD_EXPORT.name = {'EXPORT', 'export'};
            this.CMD_EXPORT.descr = 'Export';
            this.CMD_EXPORT.rec = 'T';
            this.CMD_EXPORT.par = [this.PAR_E_CORE_MAT this.PAR_E_PLAIN_MAT this.PAR_E_REC_MAT this.PAR_E_REC_RIN this.PAR_E_COO_CRD this.PAR_E_TROPO_SNX this.PAR_E_TROPO_MAT this.PAR_E_TROPO_CSV this.PAR_E_TROPO_HN];
            
            this.CMD_PUSHOUT.name = {'PUSHOUT', 'pushout'};
            this.CMD_PUSHOUT.descr = ['Push results in output' new_line 'when used it disables automatic push'];
            this.CMD_PUSHOUT.rec = 'T';
            this.CMD_PUSHOUT.par = [];

            this.CMD_PINIT.name = {'PINIT', 'pinit'};
            this.CMD_PINIT.descr = 'Parallel init => r n slaves';
            this.CMD_PINIT.rec = '';
            this.CMD_PINIT.par = [this.PAR_SLAVE];

            this.CMD_PKILL.name = {'PKILL', 'pkill'};
            this.CMD_PKILL.descr = 'Parallel kill all the slaves';
            this.CMD_PKILL.rec = '';
            
            this.CMD_PKILL.par = [];
            
            this.CMD_REMSAT.name = {'REMSAT', 'remsat'};
            this.CMD_REMSAT.descr = ['Remove satellites, format: <1ch sat. sys. (GREJCI)><2ch sat. prn>' new_line 'e.g. REMSAT T1 G04,G29,J04'];
            this.CMD_REMSAT.rec = 'T';
            this.CMD_REMSAT.key = 'S'; % fake not used key, indicate thet there's one mandatory parameter
            this.CMD_REMSAT.par = [];

            this.CMD_REMOBS.name = {'REMOBS', 'remobs'};
            this.CMD_REMOBS.descr = ['Remove observation, format: <1ch obs. type (CPDS)><1ch freq><1ch tracking>' new_line 'e.g. REMOBS T1 D,S2,L2C'];
            this.CMD_REMOBS.rec = 'T';
            this.CMD_REMOBS.key = 'O'; % fake not used key, indicate thet there's one mandatory parameter
            this.CMD_REMOBS.par = [];

            this.CMD_REMTMP.name = {'REMTMP', 'remtmp'};
            this.CMD_REMTMP.descr = ['Remove data used during computation but no more necessary to push the results out'];
            this.CMD_REMTMP.rec = 'T';
            this.CMD_REMTMP.key = '';
            this.CMD_REMTMP.par = [];
            
            this.KEY_FOR.name = {'FOR', 'for'};
            this.KEY_FOR.descr = 'For session loop start';
            this.KEY_FOR.rec = '';
            this.KEY_FOR.key = 'ST';
            this.KEY_FOR.par = [];

            this.KEY_PAR.name = {'PAR', 'par'};
            this.KEY_PAR.descr = ['Parallel section start (run on targets)' new_line 'use T$ as target in this section'];
            this.KEY_PAR.rec = '';
            this.KEY_PAR.key = 'STP';
            this.KEY_PAR.par = [];

            this.KEY_END.name = {'END', 'end', 'ENDFOR', 'END_FOR', 'end_for', 'ENDPAR', 'END_PAR', 'end_par'};
            this.KEY_END.descr = 'For loop end or Parallel section end';
            this.KEY_END.rec = '';
            this.KEY_END.key = '';
            this.KEY_END.par = [];

            % When adding a command remember to add it to the valid_cmd list
            % Create the launcher exec function
            % and modify the method exec to allow execution
            this.VALID_CMD = {};
            this.CMD_ID = [];
            this.KEY_ID = [];
            for c = 1 : numel(this.CMD_LIST)
                this.VALID_CMD = [this.VALID_CMD(:); this.(sprintf('CMD_%s', this.CMD_LIST{c})).name(:)];
                this.CMD_ID = [this.CMD_ID, c * ones(size(this.(sprintf('CMD_%s', this.CMD_LIST{c})).name))];
                this.(sprintf('CMD_%s', this.CMD_LIST{c})).id = c;
            end
            for c = 1 : numel(this.KEY_LIST)
                this.VALID_CMD = [this.VALID_CMD(:); this.(sprintf('KEY_%s', this.KEY_LIST{c})).name(:)];
                this.CMD_ID = [this.CMD_ID, (c + numel(this.CMD_LIST)) * ones(size(this.(sprintf('KEY_%s', this.KEY_LIST{c})).name))];
                this.KEY_ID = [this.KEY_ID, (c + numel(this.CMD_LIST)) * ones(size(this.(sprintf('KEY_%s', this.KEY_LIST{c})).name))];
                this.(sprintf('KEY_%s', this.KEY_LIST{c})).id = (c + numel(this.CMD_LIST));
            end            
        end
        
        function str = getHelp(this)
            % Get a string containing the "help" description to all the supported commands
            %
            % SYNTAX:
            %   str = this.getHelp()
            str = sprintf('Accepted commands:\n');
            str = sprintf('%s==============================================================================================\n', str);
            for c = 1 : numel(this.CMD_LIST)
                cmd_name = this.(sprintf('CMD_%s', this.CMD_LIST{c})).name{1};
                str = sprintf('%s - %s\n', str, cmd_name);
            end
            
            str = sprintf('%s\n----------------------------------------------------------------------------------------------\n', str);
            str = sprintf(['%s   NOTE: "T" refers to Target receiver' ...
                '\n         "R" refers to reference receiver' ...
                '\n         "P" refers to "passed" receiver\n' ...
                '\n          - Receivers can be identified with their id number (as defined in "obs_name")' ...
                '\n          - It is possible to provide multiple receivers (e.g. T* or T1:4 or T1,3:5)' ...
                '\n          - "END" can be used to select some Receivers / Sessions (e.g T1,3:END)' ...
                '\n          - Whitin a FOR T loop "$" identify the current receiver in the execution\n' ...
                ], str);
            str = sprintf('%s----------------------------------------------------------------------------------------------\n', str);
            str = sprintf('%s\nCommands description:\n', str);
            str = sprintf('%s==============================================================================================\n', str);
            for c = 1 : numel(this.CMD_LIST)
                cmd = this.(sprintf('CMD_%s', this.CMD_LIST{c}));
                str = sprintf('%s - %s%s%s\n', str, cmd.name{1}, ones(1, 10 - numel(cmd.name{1})) * ' ', cmd.descr);
                if ~isempty(cmd.rec)
                    str = sprintf('%s\n%s%s', str, ones(1, 13) * ' ', 'Mandatory receivers:');
                    if numel(cmd.rec) > 1
                        rec_par = sprintf('%c%s', cmd.rec(1), sprintf(', %c', cmd.rec(2:end)));
                    else
                        rec_par = cmd.rec(1);
                    end
                    str = sprintf('%s %s\n', str, rec_par);
                end
                
                if ~isempty(cmd.par)
                    str = sprintf('%s\n%s%s\n', str, ones(1, 13) * ' ', 'Parameters:');
                    for p = 1 : numel(cmd.par)
                        str = sprintf('%s%s%s\n', str, ones(1, 15) * ' ', cmd.par(p).descr);
                    end
                end
                str = sprintf('%s\n----------------------------------------------------------------------------------------------\n', str);
            end
            for c = 1 : numel(this.KEY_LIST)
                cmd = this.(sprintf('KEY_%s', this.KEY_LIST{c}));
                str = sprintf('%s - %s%s%s\n', str, cmd.name{1}, ones(1, 10-numel(cmd.name{1})) * ' ', cmd.descr);
                if ~isempty(cmd.rec)
                    str = sprintf('%s\n%s%s', str, ones(1, 13) * ' ', 'Mandatory receivers:');
                    if numel(cmd.rec) > 1
                        rec_par = sprintf('%c%s', cmd.rec(1), sprintf(', %c', cmd.rec(2:end)));
                    else
                        rec_par = cmd.rec(1);
                    end
                    str = sprintf('%s %s\n', str, rec_par);
                end
                
                if ~isempty(cmd.key)
                    str = sprintf('%s\n%s%s', str, ones(1, 13) * ' ', 'Mandatory session:');
                    if numel(cmd.key) > 1
                        rec_par = sprintf('%c%s', cmd.key(1), sprintf(', %c', cmd.key(2:end)));
                    else
                        rec_par = cmd.key(1);
                    end
                    str = sprintf('%s %s\n', str, rec_par);
                end
                
                if ~isempty(cmd.par)
                    str = sprintf('%s\n%s%s\n', str, ones(1, 13) * ' ', 'Optional parameters:');
                    for p = 1 : numel(cmd.par)
                        str = sprintf('%s%s%s\n', str, ones(1, 15) * ' ', cmd.par(p).descr);
                    end
                end
                str = sprintf('%s\n----------------------------------------------------------------------------------------------\n', str);
            end                        
        end
        
        function str = getExamples(this)
            % Get a string containing the "examples" of processing
            %
            % SYNTAX:
            %   str = this.getHelp()
            str = sprintf(['# PPP processing', ...
                '\n# @5 seconds rate GPS GALILEO', ...
                '\n\n FOR S*' ...
                '\n    FOR T*' ...
                '\n       LOAD T$ @5s -s=GE', ...
                '\n       PREPRO T$', ...
                '\n       PPP T$', ...
                '\n    END', ...
                '\n    PUSHOUT T*', ...                
                '\n END', ...
                '\n SHOW T* ZTD', ...
                '\n EXPORT T* TRP_SNX', ...
                '\n\n# Network undifferenced processing', ...
                '\n# @30 seconds rate GPS only', ...
                '\n# processing all sessions', ...
                '\n# using receivers 1,2 as reference\n# for the mean', ...                
                '\n\n FOR S*' ...
                '\n    FOR T*' ...
                '\n       LOAD T$ @30s -s=G', ...
                '\n       PREPRO T$', ...
                '\n    END', ...
                '\n    PPP T1:2', ...
                '\n    NET T* R1,2', ...
                '\n    PUSHOUT T*', ...
                '\n END', ...
                '\n SHOW T* MAP', ...
                '\n SHOW T* ENUBSL', ...
                '\n\n# Parallel Baseline solution with 16 slaves\n# The reference is the receiver 1', ...
                '\n\n PINIT N16' ...
                '\n FOR S*' ...
                '\n    LOAD T1' ...
                '\n    PREPRO T1' ...
                '\n    PAR T2:17 P1' ...
                '\n       OUTDET T1' ...
                '\n       LOAD T$' ...
                '\n       PREPRO T$' ...
                '\n       NET T1,$ R1' ...
                '\n    END' ...
                '\n    PUSHOUT T*', ...                
                '\n END' ...
                '\n\n# Parallel PPP with 3 slaves\n# killing workers at the end\n# of processing', ...
                '\n\n PINIT -n=3' ...
                '\n FOR S*' ...
                '\n    PAR T*' ...
                '\n       LOAD T$ @30s -s=G', ...
                '\n       PREPRO T$', ...
                '\n       PPP T$', ...
                '\n    END' ...                
                '\n    PUSHOUT T*', ...                
                '\n END', ...
                '\n PKILL', ...
                '\n SHOW T* ZWD', ...
                '\n\n# PPP + SID processing', ...
                '\n# 4 reference stations \n# + one L1 target', ...
                '\n# @30 seconds rate GPS', ...
                '\n\n FOR S*' ...
                '\n    FOR T*' ...
                '\n       LOAD T$ @30s -s=G', ...
                '\n       PREPRO T$', ...
                '\n    END', ...
                '\n    PPP T1:4', ...
                '\n    SID R1:4 T5', ...
                '\n    PPP T5', ...
                '\n    PUSHOUT T*', ...
                '\n END', ...
                '\n SHOW T* ZTD']);
        end
    end
    %
    %% METHODS EXECUTE
    % ==================================================================================================================================================
    % methods to execute a set of goGPS Commands
    methods         
        function ex_list = exec(this, core, cmd_list, level_add)
            % run a set of commands (divided in cells of cmd_list)
            %
            % SYNTAX:
            %   this.exec(rec, core, cmd_list)
            
            ex_number = 0;
            ex_list = {};
            if nargin < 3
                state = Core.getState();
                cmd_list = state.getCommandList();
            end
            if ~iscell(cmd_list)
                cmd_list = {cmd_list};
            end
            if nargin < 4
                level_add = 0;
            end
            
            t0 = tic();
             try
                cur_session = core.getCurrentSession;
                [cmd_list, err_list, execution_block, sss_list, trg_list, level, flag_push, flag_parallel] = this.fastCheck(cmd_list);
                level = level + level_add;
                % for each command
                l = 0;
                while l < numel(cmd_list)
                    l = l + 1;
                    
                    tok = regexp(cmd_list{l},'[^ ]*', 'match'); % get command tokens
                    
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Executing: %s', cmd_list{l}));
                    t1 = tic;
                    this.log.simpleSeparator([], [0.4 0.4 0.4]);
                    
                    % Init parallel controller when a parallel section is found
                    skip_line = false;
                    switch tok{1}
                        % Parallel execution ---------------------------------------------------------------------------------------------------
                        case this.KEY_PAR.name
                            [id_pass, found] = this.getMatchingRec(core.rec, tok, 'P');
                            [~, flag_par_target] = this.getMatchingRec(core.rec, tok, 'T');
                            [id_sss, flag_par_session] = this.getMatchingSession(tok);
                            
                            if flag_par_target || flag_par_session
                                if ~found
                                    id_pass = [];
                                end
                                this.core.activateParallelWorkers(flag_par_target, id_pass);
                            else
                                this.log.addWarning('A parallel section have been requested\n but no targets or sessions are specified');
                            end
                            % For loop -------------------------------------------------------------------------------------------------------------
                        case this.KEY_FOR.name
                            [id_trg, flag_par_target] = this.getMatchingRec(core.rec, tok, 'T');
                            [id_sss, flag_par_session] = this.getMatchingSession(tok);
                            
                            sid = l;
                            l = l + find(execution_block(l:end) < execution_block(l), 1, 'first') - 1;
                            if isempty(l)
                                l = numel(execution_block);
                            end
                            if flag_par_target
                                % for loop on each target
                                for t = id_trg
                                    cmd_list_loop = cmd_list(sid : l-1);
                                    cmd_list_loop(1) = [];
                                    for c = 1 : numel(cmd_list_loop)
                                        % substitute $ with the current target
                                        cmd_list_loop{c} = strrep(cmd_list_loop{c},'$', num2str(t));
                                    end
                                    this.exec(core, cmd_list_loop, level(sid + 1));
                                end
                                
                                % Auto-push if no parallel sessions are present
                                % and if there are not push command
                                if flag_push(sum(diff(execution_block) < 0) + 1) && ~any(flag_parallel == 1)
                                    for r = 1 : length(core.rec)
                                        % if requested push results
                                        core.rec(r).work.pushResult();
                                    end
                                end
                                skip_line = true;
                            elseif flag_par_session
                                % Get all the commands in this session for
                                id = find(execution_block > execution_block(l),1,'first');
                                lev0 = level(id);
                                id_list = [];
                                i = id + 1;
                                while i <= numel(cmd_list) && (level(i) >= lev0)
                                    id_list = [id_list; i]; %#ok<AGROW>
                                    i = i + 1;
                                end
                                
                                % for loop on each session
                                last_sss = 0;
                                for s = id_sss
                                    if s ~= last_sss
                                        is_empty = core.prepareSession(s);
                                    end
                                    
                                    last_sss = s;
                                    if ~is_empty
                                        cmd_list_loop = cmd_list(id_list);
                                        for c = 1 : numel(cmd_list_loop)
                                            % substitute § with the current session
                                            cmd_list_loop{c} = strrep(cmd_list_loop{c},'§', num2str(s));
                                        end
                                        this.exec(core, cmd_list_loop, level(id_list(1)));
                                        
                                        if flag_push(sum(diff(execution_block) < 0) + 1)
                                            for r = 1 : length(core.rec)
                                                % if requested push results
                                                core.rec(r).work.pushResult();
                                            end
                                        end
                                        
                                    end
                                end
                                l = id_list(end);
                                skip_line = true;
                            else
                                this.log.addWarning('A loop section have been requested\n but no targets or sessions are specified');
                            end
                        otherwise
                            flag_par_target = false;
                            flag_par_session = false;
                    end
                    
                    if ~skip_line
                        n_workers = 0;
                        if flag_par_target || flag_par_session
                            % The user wants to go parallel, but are workers active?
                            gom = Parallel_Manager.getInstance;
                            n_workers = gom.getNumWorkers;
                            if n_workers == 0
                                this.log.addWarning('No parallel workers have been found\n Launch some slaves!!!\nrunning in serial mode');
                            end
                        end
                        % go parallel
                        % Get the section target => remove not available targets
                        tmp = trg_list{l};
                        trg_list{l} = tmp(tmp <= numel(core.rec));
                        
                        % find the last command of this block
                        %last_par_id = find(execution_block == execution_block(l), 1, 'last');
                        %if isempty(last_par_id)
                        %    last_par_id = numel(execution_block);
                        %else
                        %    last_par_id = last_par_id + l - 2;
                        %end
                        %par_cmd_id = (l + 1) : last_par_id;
                        
                        % find the last command of this section
                        last_par_id = find((level(l : end) - level(l)) < 0, 1, 'first');
                        if isempty(last_par_id)
                            last_par_id = numel(level);
                        else
                            last_par_id = last_par_id + l - 2;
                        end
                        par_cmd_id = (l + 1) : last_par_id;
                        
                        if n_workers > 0
                            par_cmd_list = cmd_list(par_cmd_id); % command list for the parallel worker
                            
                            if flag_parallel(l) == 1 % it means parallel session (2 is parallel targets)
                                gom.orderProcessing(par_cmd_list, 1, id_sss);
                                gom.importParallelSessions();
                                % And now I have to read the (ordered) sessions
                            elseif flag_parallel(l) == 2 % it means parallel targets
                                gom.orderProcessing(par_cmd_list, 2, trg_list{l});
                            end
                            l = par_cmd_id(end);
                        else
                             try
                                switch upper(tok{1})
                                    case this.CMD_PINIT.name                % PINIT
                                        this.runParInit(tok(2:end));
                                    case this.CMD_PKILL.name                % PKILL
                                        this.runParKill(tok(2:end));
                                    case this.CMD_EMPTY.name                % EMPTY
                                        this.runEmpty(core.rec, tok(2:end));
                                    case this.CMD_EMPTYWORK.name            % EMPTYW
                                        this.runEmptyWork(core.rec, tok(2:end));
                                    case this.CMD_EMPTYOUT.name             % EMPTYO
                                        this.runEmptyOut(core.rec, tok(2:end));
                                    case this.CMD_REMSAT.name               % REM SAT
                                        this.runRemSat(core.rec, tok(2:end));
                                    case this.CMD_REMOBS.name               % REM OBS
                                        this.runRemObs(core.rec, tok(2:end));
                                    case this.CMD_REMTMP.name               % REM TMP
                                        this.runRemTmp(core.rec, tok(2:end));
                                    case this.CMD_KEEP.name                 % KEEP
                                        this.runKeep(core.rec.getWork(), tok(2:end));
                                    case this.CMD_SHOW.name                 % SHOW
                                        this.runShow(core.rec, tok, level(l));
                                    case this.CMD_EXPORT.name               % EXPORT
                                        this.runExport(core.rec, tok, level(l));
                                    case this.CMD_PUSHOUT.name              % PUSHOUT
                                        this.runPushOut(core.rec, tok);
                                    case this.CMD_LOAD.name                 % LOAD
                                        this.runLoad(core.rec, tok(2:end));
                                    case this.CMD_FIX_POS.name              % FIX POS
                                        this.runFixPos(core.rec, tok(2:end));
                                end
                                if not(core.getCoreSky.isEmpty())
                                    switch upper(tok{1})
                                        case this.CMD_RENAME.name               % RENAME
                                            this.runRename(core.rec, tok(2:end));
                                        case this.CMD_AZEL.name                 % AZEL
                                            this.runUpdateAzEl(core.rec, tok(2:end));
                                        case this.CMD_BASICPP.name              % BASICPP
                                            this.runBasicPP(core.rec, tok(2:end));
                                        case this.CMD_PREPRO.name               % PREP
                                            this.runPrePro(core.rec, tok(2:end));
                                        case this.CMD_CODEPP.name               % CODEPP
                                            this.runCodePP(core.rec, tok(2:end));
                                        case this.CMD_PPP.name                  % PPP
                                            this.runPPP(core.rec, tok(2:end));
                                        case this.CMD_NET.name                  % NET
                                            this.runNet(core.rec, tok(2:end));
                                        case this.CMD_PSRALIGN.name             % Pseudorange align
                                            this.runPseudorangeAlign(core.rec, tok(2:end));
                                        case this.CMD_SEID.name                 % SEID
                                            this.runSEID(core.rec, tok(2:end));
                                        case this.CMD_SID.name                  % SID
                                            this.runSID(core.rec, tok(2:end));
                                        case this.CMD_REMIONO.name              % REMIONO
                                            this.runRemIono(core.rec, tok(2:end));
                                        case this.CMD_SYNC.name                 % SYNC
                                            this.runSync(core.rec, tok(2:end));
                                        case this.CMD_OUTDET.name               % OUTDET
                                            this.runOutDet(core.rec, tok);
                                    end
                                end
                            catch ex
                                this.log.addError(sprintf('Command "%s" failed with error message: %s\nDebug starting from Command_Interpreter.exec()', tok{1}, ex.message));
                                Core_Utils.printEx(ex);
                                ex_number = ex_number + 1;
                                ex_list{end + 1} = ex;
                            end
                        end
                    end
                end
            catch ex
                this.log.addError(sprintf('Command core.exec() failed to execute\n%s', ex.message));
                Core_Utils.printEx(ex);
                ex_number = ex_number + 1;
                ex_list{end + 1} = ex;
            end
            if (toc(t0) > 1) && (numel(cmd_list) > 1)
                this.log.smallSeparator()
                this.log.addMessage(this.log.indent(sprintf(' Command block execution done in %.3f seconds', toc(t0))));
                this.log.smallSeparator()
                this.log.newLine();
            end
            if ex_number > 0
                this.log.addError(sprintf('%d exceptions have been cought :-(', ex_number));
            end
            this.log.simpleSeparator([], [0.4 0.4 0.4]);
        end
    end
    %
    %% METHODS EXECUTE (PRIVATE)
    % ==================================================================================================================================================
    % methods to execute a set of goGPS Commands
    methods (Access = public)
        
        function runParInit(this, tok)
            % Load the RINEX file into the object
            %
            % SYNTAX
            %   this.runParInit(tok)
            
            [n_slaves, found] = this.getNumericPar(tok, this.PAR_SLAVE.par);
            Parallel_Manager.requestSlaves(round(n_slaves));
        end
        
        function runParKill(this, tok)
            % Load the RINEX file into the object
            %
            % SYNTAX
            %   this.runParKill(tok)
            Parallel_Manager.killAll();
        end
        
        function runLoad(this, rec, tok)
            % Load the RINEX file into the object
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.load(rec)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                state = Core.getState();
                if ~sys_found
                    sys_list = state.cc.getActiveSysChar;
                end
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Importing data for receiver %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    [rate, found] = this.getNumericPar(tok, this.PAR_RATE.par);
                    if ~found
                        rate = []; % get the rate of the RINEX
                    end
                    cur_session = Core.getCurrentSession();
                    if state.isRinexSession()
                        rec(r).importRinexLegacy(this.core.state.getRecPath(r, cur_session), rate, sys_list);
                        rec(r).work.loaded_session = this.core.getCurSession();
                    else
                        [session_limits, out_limits] = state.getSessionLimits(cur_session);
                        if out_limits.length < 2 || ~this.core.rin_list(r).hasObsInSession(out_limits.first, out_limits.last)
                            this.log.addWarning(sprintf('No observations are available for receiver %s in the interval of the session %d\n - %s\n - %s', rec(r).getMarkerName4Ch, cur_session, out_limits.first.toString, out_limits.last.toString));
                        else
                            rec(r).importRinexes(this.core.rin_list(r).getCopy(), session_limits.first, session_limits.last, rate, sys_list);
                            rec(r).work.loaded_session = cur_session;
                            rec(r).work.setOutLimits(out_limits.first, out_limits.last);
                        end
                    end
                end
            end
        end
        
        function runRename(this, rec, tok)
            % Change the marker name of a receiver
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.load(rec)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            elseif numel(tok) < 2
                this.log.addWarning('No name defined for rename');
            else
                for t = 2 : numel(tok) - 1
                    tok{t} = [tok{t} ' '];
                end
                name = [tok{2:end}];
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Renaming receiver %d: %s to %s', r, rec(r).getMarkerName(), tok{2}));
                    this.log.smallSeparator();
                    this.log.newLine();
                    rec(r).setMarkerName(name);
                end
            end
        end
        
        function runEmpty(this, rec, tok)
            % Reset (empty) the receiver
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.runEmpty(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Empty the receiver %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    rec(r).resetOut();
                    rec(r).work.resetWorkSpace();
                end
            end
        end
        
        function runEmptyWork(this, rec, tok)
            % Reset (empty) the receiver workspace
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.runEmptyWork(rec)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Empty the receiver work-space %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    rec(r).resetWork();
                end
            end
        end
        
        function runEmptyOut(this, rec, tok)
            % Reset (empty) the receiver out
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.runEmptyOut(rec)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Empty the receiver output %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    rec(r).resetOut();
                end
            end
        end
        
        function runPrePro(this, rec, tok)
            % Execute Pre processing
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runPrePro(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                for r = id_trg
                    if rec(r).work.loaded_session ~=  this.core.getCurSession()
                        this.log.addError(sprintf('Receiver %d: %s seems to be empty, pre-processing is not possible.', r, rec(r).getMarkerName()));
                    else
                        this.log.newLine();
                        this.log.addMarkedMessage(sprintf('Pre-processing on receiver %d: %s', r, rec(r).getMarkerName()));
                        this.log.smallSeparator();
                        this.log.newLine();
                        if sys_found
                            rec(r).work.preProcessing(sys_list);
                        else
                            rec(r).work.preProcessing();
                        end
                    end
                end
            end
        end
        
        function runFixPos(this, rec, tok)
            % Execute Fix pos
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runFixPos(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                
                mode = 'work'; % Take the position from work
                flag_apr = false; % do not use coordinates as a-priori (use them as fixed)
                for t = 1 : numel(tok)
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_R_FROM_OUT.par ')*$'], 'once'))
                        mode = 'out';
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_R_FROM_WORK.par ')*$'], 'once'))
                        mode = 'work';
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_R_FIX_APR.par ')*$'], 'once'))
                        flag_apr = true;
                    end
                end
                
                for r = id_trg
                    if ~isempty(mode)
                        try
                            rec(r).fixPos(mode);
                        catch ex
                            this.log.addError(sprintf('Command "FIX" failed on receiver %d - "%s"', ex.message, r, rec(r).getMarkerName()));
                            Core_Utils.printEx(ex);
                        end
                    end
                    
                    if flag_apr
                        try
                            rec(r).unFixPos();
                        catch ex
                            this.log.addError(sprintf('Command "FIX" failed on receiver %d - "%s"', ex.message, r, rec(r).getMarkerName()));
                            Core_Utils.printEx(ex);
                        end
                    end
                end
                
            end
        end
        
        function runUpdateAzEl(this, rec, tok)
            % Execute Computation of azimuth and elevation
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runUpdateAzEl(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Computing azimuth and elevation for receiver %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    if rec(r).isEmpty
                        if sys_found
                            state = Core.getCurrentSettings();
                            state.cc.setActive(sys_list);
                        end
                        rec(r).work.load();
                    end
                    rec(r).work.updateAzimuthElevation();
                    %rec(r).work.pushResult();
                end
            end
        end
        
        function runPushOut(this, rec, tok)
            % Execute Computation of azimuth and elevation
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runUpdateAzEl(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                for i = 1 : length(id_trg)
                    rec(id_trg(i)).work.pushResult();
                end
            end
        end
        
        function runBasicPP(this, rec, tok)
            % Execute Basic Point positioning with no correction (useful to compute azimuth and elevation)
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.basicPP(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Computing basic position for receiver %d: %s', r, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    %if rec(r).isEmpty
                    %    if sys_found
                    %        state = Core.getCurrentSettings();
                    %        state.cc.setActive(sys_list);
                    %    end
                    %    rec(r).load();
                    %end
                    if rec(r).work.loaded_session ~=  this.core.getCurSession()
                        this.log.addError(sprintf('Receiver %d: %s seems to be empty, basic positioning is not possible.', r, rec(r).getMarkerName()));
                    else
                        if sys_found
                            rec(r).computeBasicPosition(sys_list);
                        else
                            rec(r).computeBasicPosition();
                        end
                    end
                end
            end
        end
        
        function runPPP(this, rec, tok)
            % Execute Precise Point Positioning
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runPPP(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                
                flag_uncombined = false;
                for t = 1 : numel(tok)
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_UNCOMBINED.par ')*$'], 'once'))
                        % use the original plane based interpolation
                        flag_uncombined = true;
                    end
                end
                
                for r = id_trg
                    if rec(r).work.loaded_session ~=  this.core.getCurSession()
                        this.log.addError(sprintf('Receiver %d: %s seems to be empty, PPP is not possible.', r, rec(r).getMarkerName()));
                    elseif ~rec(r).work.isPreProcessed
                        this.log.addError(sprintf('Receiver %d: %s has not been pre-processed, PPP is not possible.', r, rec(r).getMarkerName()));
                    else
                        if rec(r).work.isStatic
                            this.log.newLine();
                            this.log.addMarkedMessage(sprintf('StaticPPP on receiver %d: %s', r, rec(r).getMarkerName()));
                            this.log.smallSeparator();
                            this.log.newLine();
                            if ~Core.getState.isPPPOnSF() && ~rec(r).work.isMultiFreq()
                                this.log.addWarning('PPP for single frequency receiver must be enabled\nin advanced settings:\nSet "flag_ppp_force_single_freq = 1" to enable it');
                            else
                                try
                                    if flag_uncombined
                                        this.log.addWarning('Experimental uncombined engine enabled');
                                        if sys_found
                                            rec(r).work.staticPPPNew(sys_list);
                                        else
                                            rec(r).work.staticPPPNew();
                                        end
                                    else
                                        if sys_found
                                            rec(r).work.staticPPP(sys_list);
                                        else
                                            rec(r).work.staticPPP();
                                        end
                                    end
                                catch ex
                                    this.log.addError(['Command_Interpreter - PPP solution failed:' ex.message]);
                                    Core_Utils.printEx(ex);
                                end
                            end
                        else
                            this.log.addError('PPP for moving receiver not yet implemented :-(');
                        end
                    end
                end
            end
        end
        
        function runNet(this, rec, tok)
            % Execute Network undifferenced solution
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runNET(rec, tok)
            
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            %             if true
            %                 rec(id_trg).netPrePro();
            %             end
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                [id_ref, found_ref] = this.getMatchingRec(rec, tok, 'R');
                if ~found_ref
                    id_ref = id_trg; % Use all the receiver as mean reference
                end
                [id_ref] = intersect(id_trg, id_ref);
                if isempty(id_ref)
                    this.log.addWarning('No reference have been found, using the mean of the receiver for the computation');
                end
                net = this.core.getNetwork(id_trg, rec);
                net.reset();
                flag_iono_reduce = false;
                flag_clk_export = false;
                flag_uncombined = false;
                flag_free_network = false;
                coo_rate = [];
                fr_id = 1;
                [rate, found] = this.getNumericPar(tok, this.PAR_RATE.par);
                
                if found
                    coo_rate = rate;
                end
                for t = 1 : numel(tok)
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_IONO.par ')*$'], 'once'))
                        flag_iono_reduce = true;
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_CLK.par ')*$'], 'once'))
                        flag_clk_export = true;
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_FREE_NET.par ')*$'], 'once'))
                        flag_free_network = true;
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_UNCOMBINED.par ')*$'], 'once'))
                        % use the original plane based interpolation
                        flag_uncombined = true;
                    end
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_BAND.par ')*$'], 'once'))
                        fr_id  = regexp(tok{t}, ['^(' this.PAR_BAND.par ')*$'], 'once');
                        fr_id = str2num(tok{t}(fr_id+1));
                    end
                end
                 try
                    if flag_uncombined
                        this.log.addWarning('Experimental uncombined engine enabled');
                        net.adjustNew(id_ref, coo_rate, flag_iono_reduce, flag_clk_export, flag_free_network);
                    else
                        net.adjust(id_ref, coo_rate, flag_iono_reduce, flag_clk_export, fr_id, flag_free_network);
                    end
                catch ex
                    this.log.addError(['Command_Interpreter - Network solution failed:' ex.message]);
                    Core_Utils.printEx(ex);
                end
                for t = 1 : numel(tok)
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_E_COO_CRD.par ')*$'], 'once'))
                        net.exportCrd();
                    end
                end
            end
            %fh = figure; plot(zero2nan(rec(2).work.sat.res)); fh.Name = 'Res'; dockAllFigures;
        end
        
        function runRemSat(this, rec, tok)
            % Remove satellites from receivers
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runRemSat(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                s_idx = 2;
                for r = id_trg
                    sats = strsplit(tok{s_idx},',');
                    for s = 1 : length(sats)
                        sys_c = sats{s}(1);
                        prn = str2double(sats{s}(2:3));
                        rec(r).work.remSat(sys_c, prn);
                    end
                end
            end
        end
        
        function runRemObs(this, rec, tok)
            % Remove observation from receivers
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runRemObs(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                s_idx = 2;
                for r = id_trg
                    if ~isempty(rec(r)) && ~(rec(r).isEmptyWork_mr)
                        obs_type = strsplit(tok{s_idx},',');
                        id = [];
                        for o = 1 : length(obs_type)
                            id = [id; rec(r).work.findObservableByFlag(obs_type{o})];
                        end
                        rec(r).work.remObs(id);
                    end
                end
            end
        end
        
        function runRemTmp(this, rec, tok)
            % Remove data no more needed for pushout
            % This function corrupts the work object and cannot be used for further processing
            %
            % INPUT
            %   rec     list of rec objects
            %
            % SYNTAX
            %   this.runRemTmp(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                for r = id_trg
                    if ~isempty(rec(r)) && ~(rec(r).isEmptyWork_mr)
                        if rec(r).state.flag_out_quality
                            id_rem = rec(1).work.obs_code(:,1) ~= 'S';
                            rec(r).work.obs(id_rem, :) = [];
                            rec(r).work.obs_code = [rec(1).work.obs_code(rec(1).work.obs_code(:,1) == 'S', :); ...
                                rec(1).work.obs_code(rec(1).work.obs_code(:,1) ~= 'S', :)];
                        else
                            rec(r).work.obs = [];
                        end
                        rec(r).work.synt_ph = [];
                        rec(r).work.sat_cache = [];
                        rec(r).work.sat.avail_index = [];
                        rec(r).work.sat.outliers_ph_by_ph = [];
                        rec(r).work.sat.outliers_pr_by_pr = [];
                        rec(r).work.sat.cycle_slip_ph_by_ph = [];
                        rec(r).work.sat.err_tropo = [];
                        rec(r).work.sat.slant_td = [];
                        rec(r).work.sat.err_iono = [];
                        rec(r).work.sat.solid_earth_corr = [];
                        rec(r).work.sat.tot = [];
                        rec(r).work.sat.amb_idx = [];
                        rec(r).work.sat.amb_mat = [];
                    end
                end
            end
        end
        
        function runPseudorangeAlign(this, rec, tok)
            % Execute pseudorange alignement
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runPseudorangeAlign(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                %this.log.addMarkedMessage(sprintf('Alignign pseudranges on receivers %d', id_trg));
                net = Network(rec(id_trg));
                net.alignCodeObservables();
            end
            %fh = figure; plot(zero2nan(rec(2).work.sat.res)); fh.Name = 'Res'; dockAllFigures;
        end
        
        function runCodePP(this, rec, tok)
            % Execute Code Point Positioning
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runCodePP(rec, tok)
            [id_trg, found] = this.getMatchingRec(rec, tok, 'T');
            if ~found
                this.log.addWarning('No target found -> nothing to do');
            else
                [sys_list, sys_found] = this.getConstellation(tok);
                [id_ref, found_ref] = this.getMatchingRec(rec, tok, 'R');
                
                for r = id_trg
                    this.log.newLine();
                    this.log.addMarkedMessage(sprintf('Code positioning on receiver %d: %s', id_trg, rec(r).getMarkerName()));
                    this.log.smallSeparator();
                    this.log.newLine();
                    if sys_found
                        rec(r).work.initPositioning(sys_list);
                    else
                        rec(r).work.initPositioning();
                    end
                end
            end
        end
        
        function runSEID(this, rec, tok)
            % Synthesise L2 observations on a target receiver given a set of dual frequency reference stations
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runSEID(rec, tok)
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found => nothing to do');
            else
                [id_ref, found_ref] = this.getMatchingRec(rec, tok, 'R');
                
                flag_use_plane = false;
                for t = 1 : numel(tok)
                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_M_SEID_PLANE.par ')*$'], 'once'))
                        % use the original plane based interpolation
                        flag_use_plane = true;
                    end
                end
                
                if ~found_ref
                    this.log.addWarning('No reference SEID station found -> nothing to do');
                else
                    if flag_use_plane
                        tic; Core_SEID.getSyntL2(rec.getWork(id_ref), rec.getWork(id_trg), 'plane'); toc;
                    else
                        % (Using a mapping function for the iono has mostly no effect)
                        % but it's usage does not cost many cpu cycles
                        flag_use_mf = false;
                        tic; Core_SEID.getSyntL2(rec.getWork(id_ref), rec.getWork(id_trg), 'distance', flag_use_mf); toc;
                    end
                end
            end
        end
        
        function runSID(this, rec, tok)
            % Synthesise L2 observations on a target receiver given a set of dual frequency reference stations
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runSID(rec, tok)
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found => nothing to do');
            else
                [id_ref, found_ref] = this.getMatchingRec(rec, tok, 'R');
                
                if ~found_ref
                    this.log.addWarning('No reference SID station found -> nothing to do');
                else
                    tic; Core_SEID.getSyntL2(rec.getWork(id_ref), rec.getWork(id_trg), 'ls', false); toc;
                end
            end
        end
        
        function runRemIono(this, rec, tok)
            % Remove iono model from observations on a target receiver given a set of dual frequency reference stations
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runSEID(rec, tok)
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found => nothing to do');
            else
                [id_ref, found_ref] = this.getMatchingRec(rec, tok, 'R');
                if ~found_ref
                    this.log.addWarning('No reference SEID station found -> nothing to do');
                else
                    tic; Core_SEID.remIono(rec.getWork(id_ref), rec.getWork(id_trg)); toc;
                end
            end
        end
        
        function runKeep(this, rec, tok)
            % Filter Receiver data
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runKeep(rec, tok)
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found -> nothing to do');
            else
                [rate, found] = this.getNumericPar(tok, this.PAR_RATE.par);
                if found
                    for r = id_trg
                        this.log.addMarkedMessage(sprintf('Keeping a rate of %ds for receiver %d: %s', rate, r, rec(r).parent.getMarkerName()));
                        if rec(r).isEmpty
                            rec(r).load();
                        end
                        rec(r).keep(rate);
                    end
                end
                [snr_thr, found] = this.getNumericPar(tok, this.PAR_SNRTHR.par);
                if found
                    for r = id_trg
                        % this.log.addMarkedMessage(sprintf('Keeping obs with SNR (L1) above %d dbHZ for receiver %d: %s', snr_thr, r, rec(r).getMarkerName()));
                        if rec(r).isEmpty
                            rec(r).load();
                        end
                        rec(r).remUnderSnrThr(snr_thr);
                    end
                end
                [cut_off, found] = this.getNumericPar(tok, this.PAR_CUTOFF.par);
                if found
                    for r = id_trg
                        % this.log.addMarkedMessage(sprintf('Keeping obs with elevation above %.1f for receiver %d: %s', cut_off, r, rec(r).getMarkerName()));
                        if rec(r).isEmpty
                            rec(r).load();
                        end
                        rec(r).remUnderCutOff(cut_off);
                    end
                end
                [sys_list, found] = this.getConstellation(tok);
                if found
                    for r = id_trg
                        this.log.addMarkedMessage(sprintf('Keeping constellations "%s" for receiver %d: %s', sys_list, r, rec(r).parent.getMarkerName()));
                        if rec(r).isEmpty
                            rec(r).load();
                        end
                        rec(r).keep([], sys_list);
                    end
                end
            end
        end
        
        function runOutDet(this, rec, tok)
            % Perform outlier rejection and cycle slip detection
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runOutDet(rec)
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found -> nothing to do');
            else
                for r = id_trg
                    this.log.addMarkedMessage(sprintf('Outlier rejection and cycle slip detection for receiver %d: %s', r, rec(r).getMarkerName()));
                    rec(r).work.updateDetectOutlierMarkCycleSlip();
                end
            end
        end
        
        function runSync(this, rec, tok)
            % Filter Receiver data
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runKeep(rec, tok)
            [~, found_trg] = this.getMatchingRec(rec, tok, 'T');
            if ~found_trg
                this.log.addWarning('No target found -> nothing to do');
            else
                [rate, found] = this.getRate(tok);
                if found
                    Receiver.sync(rec, rate);
                else
                    Receiver.sync(rec);
                end
            end
        end
        
        function runShow(this, rec, tok, sss_lev)
            % Show Images
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runShow(rec, tok, level)
                        
            fh_list = [];
            if nargin < 3 || isempty(sss_lev)
                sss_lev = 0;
            end
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            [sys_list, sys_found] = this.getConstellation(tok);
            show_ok = 0;
            if ~found_trg
                this.log.addWarning('No target found -> nothing to do');
            else
                for t = 1 : numel(tok) % global for all target
                    try
                        if Core_Utils.isHold; hold off; end
                        if sss_lev == 0
                            trg = rec(id_trg);
                        else
                            trg = [rec(id_trg).work];
                        end
                        if ~isempty(regexp(tok{t}, ['^(' this.PAR_S_MAP.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showMap()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;                            
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_MAPG.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showMapGoogle()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_MAPL.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showMapGoogleLegacy()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_MAPDTM.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showMapDtm()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_PTH.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showPTH()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_NSAT.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showNSat()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_NSATSSS.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showNSatSS(true)]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_NSATSS.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showNSatSS(false)]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ZTD.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZtd()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ZTD_VSH.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZtdVsHeight()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ZHD.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZhd()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ZWD.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZwd()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ZWD_VSH.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZwdVsHeight()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_PWV.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showPwv()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_STD.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showZtdSlant()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ENUBSL.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showBaselineENU()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_PUPBSL.par ')*$'], 'once'))
                            fh_list = [fh_list; trg.showBaselinePlanarUp()]; %#ok<AGROW>
                            show_ok  = show_ok + 1;
                        end                        
                    catch ex
                        Core_Utils.printEx(ex);
                        this.log.addError(sprintf('%s',ex.message));
                    end
                end
                
                for r = id_trg % different for each target
                    
                    for t = 1 : numel(tok)
                        try
                            if Core_Utils.isHold; hold off; end
                            if sss_lev == 0
                                trg = rec(r);
                            else
                                trg = [rec(r).work];
                            end
                            
                            if ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ALL.par ')*$'], 'once'))
                                trg.showAll();
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_DA.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showDataAvailability(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_ENU.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showPositionENU()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_PUP.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showPositionPlanarUp()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_XYZ.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showPositionXYZ()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_CKW.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.work.showDt()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_CK.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showDt()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_SNR.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showSNR_p(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_SNRI.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showSNR_z(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_OSTAT.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showObsStats()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;                                
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_PSTAT.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showProcessingQualityInfo()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;                                
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_OCS.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showOutliersAndCycleSlip(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_OCSP.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showOutliersAndCycleSlip_p(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_RES.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showRes()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_RES_PSAT.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showResPerSat(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_RES_SKY.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showResSky_c(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_RES_SKYP.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showResSky_p(sys_list)]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_S_RES_STD.par ')*$'], 'once'))
                                fh_list = [fh_list; trg.showZtdSlantRes_p()]; %#ok<AGROW>
                                show_ok  = show_ok + 1;
                            end
                        catch ex                            
                            Core.getLogger.addError(sprintf('Receiver %s: %s', trg.getMarkerName, ex.message));
                            Core_Utils.printEx(ex);
                        end
                    end
                end
            end
            
            if ~isempty(fh_list)
                [export_file_name, export_found, flag_close] = this.getExportFig(tok);
                if export_found
                    for fh  = fh_list(:)'
                        file_name = fullfile(Core.getState.getOutDir, 'Images', [fh.UserData.fig_name export_file_name]);
                        [file_dir, file_name, file_ext] = fileparts(file_name);
                        if ~isempty(file_dir)
                            if ~exist(file_dir, 'file')
                                mkdir(file_dir);
                            end
                        end
                        if isempty(file_ext)
                            file_ext = '.png';
                        end
                        if isempty(file_name)
                            Core.getLogger.addWarning('No filename found for the figure export');
                        end
                        if isempty(file_name)
                            file_name = [file_name 'exported_at_' GPS_Time.now.toString('yyyymmdd_HHMMSS')]; %#ok<AGROW>
                        end
                        file_name = fullfile(file_dir, [file_name file_ext]);
                        
                        Core_Utils.exportFig(fh, file_name, Core_UI.DEFAULT_EXPORT_MODE);
                        if flag_close
                            delete(fh);
                        else
                            if ~strcmp(Core_UI.DEFAULT_EXPORT_MODE, Core_UI.DEFAULT_MODE)
                                Core_UI.beautifyFig(fh, Core_UI.DEFAULT_MODE);
                            end
                        end
                    end
                end
            end

            if show_ok == 0
                Core.getLogger.addError('No valid command show found');
            end
        end
        
        function runExport(this, rec, tok, sss_lev)
            % Export results
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   this.runExport(rec, tok, level)
            if nargin < 3 || isempty(sss_lev)
                sss_lev = 0;
            end
            
            [id_trg, found_trg] = this.getMatchingRec(rec, tok, 'T');
            do_not_complain = false;
            flag_crd  = false;
            for t = 1 : numel(tok)
                if ~isempty(regexp(tok{t}, ['^(' this.PAR_E_CORE_MAT.par ')*$'], 'once'))
                    Core.getCurrentCore.exportMat();
                    do_not_complain = true;
                elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_PLAIN_MAT.par ')*$'], 'once'))
                    rec(id_trg).exportPlainMat();
                    found_trg = false;
                    do_not_complain = true;
                elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_COO_CRD.par ')*$'], 'once'))
                    if sss_lev == 0 % run on all the results (out)
                        rec.exportCRD('out');
                    else % run in single session mode (work)
                        rec.exportCRD('work');
                    end
                    flag_crd = true;
                end
            end
            if ~found_trg
                if ~do_not_complain
                    this.log.addWarning('No target found -> nothing to do');
                end
            else
                for r = id_trg % different for each target
                    if ~flag_crd || numel(tok) > 3
                        this.log.newLine();
                        this.log.addMarkedMessage(sprintf('Exporting receiver %d: %s', r, rec(r).getMarkerName()));
                        this.log.smallSeparator();
                        this.log.newLine();
                    end
                    not_exported = ~flag_crd;
                    for t = 1 : numel(tok)
                        try
                            if ~isempty(regexp(tok{t}, ['^(' this.PAR_E_REC_RIN.par ')*$'], 'once'))
                                rec(r).work.exportRinex3();
                                not_exported = false;
                            else
                                if sss_lev == 0 % run on all the results (out)
                                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_SNX.par ')*'], 'once'))
                                        pars       = regexp(tok{t},'(?<=[\(,])[0-9a-zA-Z]*','match'); %match everything that is follows a parenthesis or a coma
                                        export_par = false(length(this.PAR_E_TROPO_SNX.accepted_values),1);
                                        if isempty(pars)
                                            export_par([1,2,3]) = true; % by defaul export only ztd and gradients
                                        elseif strcmpi(pars{1},'ALL')
                                            export_par(:) = true; % export all
                                        else
                                            for i = 1 : length(pars)
                                                for j = 1 : length(export_par)
                                                    if strcmpi(pars{i}, this.PAR_E_TROPO_SNX.accepted_values{j})
                                                        export_par(j) = true;
                                                    end
                                                end
                                            end
                                        end
                                        rec(r).out.exportTropoSINEX(export_par);
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_MAT.par ')*$'], 'once'))
                                        if rec(r).out.isEmpty
                                            rec(r).work.exportTropoMat();
                                        else
                                            rec(r).out.exportTropoMat();
                                        end
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_CSV.par ')*$'], 'once'))
                                        if rec(r).out.isEmpty
                                            rec(r).work.exportTropoCSV();
                                        else
                                            rec(r).out.exportTropoCSV();
                                        end
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_HN.par ')*$'], 'once'))
                                        rec(r).exportHydroNET();
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_REC_MAT.par ')*$'], 'once'))
                                        rec(r).exportMat();
                                        not_exported = false;
                                    end
                                else % run in single session mode (work)
                                    if ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_SNX.par ')*$'], 'once'))
                                        rec(r).work.exportTropoSINEX();
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_TROPO_MAT.par ')*$'], 'once'))
                                        rec(r).work.exportTropoMat();
                                        not_exported = false;
                                    elseif ~isempty(regexp(tok{t}, ['^(' this.PAR_E_REC_MAT.par ')*$'], 'once'))
                                        rec(r).work.exportMat();
                                        not_exported = false;
                                    end
                                end
                            end
                            
                        catch ex
                            Core_Utils.printEx(ex);
                            this.log.addError(sprintf('Receiver %s: %s', rec(r).getMarkerName, ex.message));
                        end
                    end
                    if not_exported
                        this.log.addWarning('Unrecognized export parameter')
                    end
                end
            end
        end
    end
    %
    %% METHODS UTILITIES (PRIVATE)
    % ==================================================================================================================================================
    methods (Access = public)
        function [id_rec, found, matching_rec] = getMatchingRec(this, rec, tok, type)
            % Extract from a set of tokens the receivers to be used
            %
            % INPUT
            %   rec     list of rec objects
            %   tok     list of tokens(parameters) from command line (cell array)
            %   type    type of receavers to search for ('T'/'R'/'M')
            %
            % SYNTAX
            %   [id_rec, found, matching_rec] = this.getMatchingRec(rec, tok, type)
            if nargin == 2
                type = 'T';
            end
            n_rec = numel(rec);
            if n_rec == 0
                n_rec = numel(Core.getState.getRecCount());
            end
            [id_rec, found] = getMatchingKey(this, tok, type, n_rec);
        end
        
        function [id_sss, found] = getMatchingSession(this, tok)
            % Extract from a set of tokens the session to be used
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [id_sss, found] = this.getMatchingSession(tok)
            state = Core.getCurrentSettings();
            n_key = state.getSessionCount();
            [id_sss, found] = getMatchingKey(this, tok, 'S', n_key);
        end
        
        function [id_trg, found] = getMatchingTarget(this, tok)
            % Extract from a set of tokens the target to be used
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [id_sss, found] = this.getMatchingSession(tok)
            [id_trg, found] = getMatchingKey(this, tok, 'T', 10000); % 10000 maximum number of targets
        end
        
        function [id_key, found] = getMatchingKey(this, tok, type, n_key)
            % Extract from a set of tokens the ids to be used
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [id_sss, found] = this.getMatchingKey(tok)            
            
            id_key = [];
            found = false;
            t = 0;
            
            while ~found && t < numel(tok)
                t = t + 1;
                % Search receiver identified after the key character "type"
                if ~isempty(tok{t}) && tok{t}(1) == type
                    % Analyse all the receiver identified on the string
                    % e.g. T*        all the receivers
                    %      T1,3:5    receiver 1,3,4,5
                    str_rec = tok{t}(2:end);
                    % end | END | E == n_key
                    str_rec = strrep(str_rec, 'end', num2str(n_key));
                    str_rec = strrep(str_rec, 'END', num2str(n_key));
                    str_rec = strrep(str_rec, 'E', num2str(n_key));
                    if (type == 'S')
                        str_rec = strrep(str_rec, 'CUR', sprintf('%d', Core.getCurrentSession));
                    end
                    take_all = ~isempty(regexp(str_rec,'[\*]*', 'once'));
                    if take_all
                        id_key = 1 : n_key;
                    else
                        [ids, pos_ids] = regexp(str_rec,'[0-9]*', 'match');
                        ids = str2double(ids);
                        
                        % find *:*:*
                        [sequence, pos_sss] = regexp(str_rec,'[0-9]*:[0-9]*:[0-9]*', 'match');
                        
                        for s = 1 : numel(sequence)
                            pos_par = regexp(sequence{s},'[0-9]*');
                            id_before = find(pos_ids(:) == (pos_sss(s) + pos_par(1) - 1), 1, 'last');
                            %id_step = find(pos_ids(:) == (pos_sss(s) + pos_par(2) - 1), 1, 'first');                            
                            %id_after = find(pos_ids(:) == (pos_sss(s) + pos_par(3) - 1), 1, 'first');
                            id_step = id_before + 1; 
                            id_after = id_before + 2; 
                            if ~isempty(id_before)
                                id_key = [id_key ids(id_before) : ids(id_step) : ids(id_after)]; %#ok<AGROW>
                                ids(id_before : id_after) = [];
                                pos_ids(id_before : id_after) = [];
                            end                            
                        end
                        
                        % find *:*                                                
                        pos_colon = regexp(str_rec,':*');
                        for p = 1 : numel(pos_colon)
                            id_before = find(pos_ids(:) < pos_colon(p), 1, 'last');
                            id_after = find(pos_ids(:) > pos_colon(p), 1, 'first');
                            if ~isempty(id_before) && ~isempty(id_after)
                                id_key = [id_key ids(id_before) : ids(id_after)]; %#ok<AGROW>
                            end
                        end
                        id_key = unique([ids id_key]);
                        id_key(id_key > n_key) = [];
                    end
                    found = ~isempty(id_key);
                end
            end
            if isempty(id_key) % as default return all the sessions
                id_key = 1 : n_key;
            end
        end    
        
        function [num, found] = getNumericPar(this, tok, par_regexp)
            % Extract from a set of tokens a number for a certain parameter
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [num, found] = this.getNumericPar(tok, this.PAR_RATE.par)
            found = false;            
            num = str2double(regexp([tok{:}], ['(?<=' par_regexp ')[+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)*'], 'match', 'once'));
            if ~isempty(num) && ~isnan(num)
                found = true;
            end
        end
        
        function [file_name, found, flag_close] = getExportFig(this, tok)
            % Extract from a set of tokens the file_name of the figure to export
            % and tell if the figure must be closed after export
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [file_name, found, flag_close] = this.getExportFig(tok)
            found = ~isempty(regexp([tok{:}], this.PAR_EXPORT.par, 'match', 'once'));
            file_name = '${STYPE}_${M_LIST}_${NOW}.png';
            tmp = strrep(regexp([tok{:}], ['(?<=' this.PAR_EXPORT.par ')(?<=(=))".*"'], 'match', 'once'),'"', '');
            if ~isempty(file_name)
                file_name = tmp;
            end
            flag_close = ~isempty(regexp([tok{:}], this.PAR_CLOSE.par, 'match', 'once'));            
        end
        
        function [sys_list, found] = getConstellation(this, tok)
            % Extract from a set of tokens the constellation parameter
            %
            % INPUT
            %   tok     list of tokens(parameters) from command line (cell array)
            %
            % SYNTAX
            %   [sys_list, found] = this.getConstellation(tok)
            found = false;            
            sys_list = regexp([tok{:}], ['(?<=' this.PAR_SS.par ')[GREJCISA]*'], 'match', 'once');
            if ~isempty(sys_list)
                found = true;
                cc = Core.getConstellationCollector;
                sys_list = intersect(sys_list, cc.getActiveSysChar);
            end
        end
        
        function [cmd, err, id] = getCommandValidity(this, str_cmd)
            % Extract from a string the goGPS command found
            %
            % INPUT
            %   str_cmd     command as a string
            %
            % OUTPUT
            %   cmd         command struct for the found command
            %   err         error number (==0 ok) (> 0 on error) (< 0 on warning)
            %    id         internal usage id in the VALID_CMD array
            %
            % SYNTAX
            %  [cmd, err, id] = getCommandValidity(this, str_cmd)
            err = 0;
            tok = regexp(str_cmd,'[^ ]*', 'match');
            cmd = [];
            id = [];
            if isempty(tok)
                err = this.WRN_MPT; % no command found
            else
                str_cmd = tok{1};
                id = this.CMD_ID((strcmp(str_cmd, this.VALID_CMD)));
                if isempty(id)
                    err = this.ERR_UNK; % command unknown
                else
                    if id > numel(this.CMD_LIST)
                        cmd = this.(sprintf('KEY_%s', this.KEY_LIST{id - numel(this.CMD_LIST)}));
                    else
                        cmd = this.(sprintf('CMD_%s', this.CMD_LIST{id}));
                    end
                    if ~isfield(cmd, 'key')
                        cmd.key = '';
                    end
                    if numel(tok) < (1 + numel(cmd.rec))
                        err = this.ERR_NEI; % not enough input parameters
                    elseif numel(tok) > (1 + numel(cmd.rec) + numel(cmd.par) + numel(cmd.key)) && ~strcmp(cmd.name{1}, 'RENAME')
                        err = this.WRN_TMI; % too many input parameters
                    end
                end
            end
        end
    end
    %
    %% METHODS UTILITIES
    % ==================================================================================================================================================
    methods
        function [cmd_list, err_list, execution_block, sss_list, trg_list, key_lev, flag_push, flag_parallel] = fastCheck(this, cmd_list)
            % Check a cmd list keeping the valid commands only
            %
            % INPUT
            %   cmd_list    command as a cell array
            %
            % OUTPUT
            %   cmd_list    list with all the valid commands
            %   err         error list
            %
            % SYNTAX
            %  [cmd, err_list, execution_block, sss_list, trg_list, key_lev] = fastCheck(this, cmd_list)
            if nargout > 3
                state = Core.getCurrentSettings();
            end
            % remove empty lines
            for c = length(cmd_list) : -1 : 1
                if isempty(cmd_list{c})
                    cmd_list(c) = [];
                end                    
            end
            err_list = zeros(size(cmd_list));   
            sss = 1;
            trg = [];
            lev = 0;
            par_id_counter = 0;
            execution_block = zeros(1, numel(cmd_list));
            flag_push = false(0,0); % Indicate commands that requires push
            auto_push = true; % This is always true unless PUSHOUT command is specifically used!
            sss_list = cell(numel(cmd_list), 1);
            trg_list = cell(numel(cmd_list), 1);
            key_lev = zeros(1, numel(cmd_list));
            is_par = 0; % is the current line in a parallel block?
            flag_parallel = zeros(numel(cmd_list), 1);
            str_loop = ''; % contains the list of open loops
            eb_counter = 0;
            for c = 1 : numel(cmd_list)
                [cmd, err_list(c)] = this.getCommandValidity(cmd_list{c});
                if (nargout > 2)
                    if err_list(c) == 0 && (cmd.id == this.KEY_FOR.id)
                        % I need to loop
                        eb_counter = eb_counter + 1;
                        lev = lev + 1;
                        tok = regexp(cmd_list{c},'[^ ]*', 'match'); % get command tokens
                        [tmp, sss_found] = this.getMatchingSession(tok);
                        if sss_found
                            sss = tmp;
                        end
                        [trg, trg_found] = this.getMatchingTarget(tok);
                        str_loop = [str_loop 'F'];
                    end
                    if err_list(c) == 0 && (cmd.id == this.KEY_PAR.id)
                        % I need to loop
                        eb_counter = eb_counter + 1;
                        par_id_counter = par_id_counter + 1;
                        lev = lev + 1;
                        tok = regexp(cmd_list{c},'[^ ]*', 'match'); % get command tokens
                        [tmp, sss_found] = this.getMatchingSession(tok);
                        if sss_found
                            sss = tmp;
                        end
                        [trg, trg_found] = this.getMatchingTarget(tok);
                        is_par = sss_found + 2 * trg_found;
                        str_loop = [str_loop 'F'];
                    end
                    if err_list(c) == 0 && (cmd.id == this.KEY_END.id)
                        % clear legacy commands
                        cmd_list{c} = regexprep(cmd_list{c},'ENDPAR|ENDFOR', 'END');
                        if isempty(str_loop)
                            % there is an end that is not closing anything
                            err_list(c) = true;
                        else
                            eb_counter = eb_counter - 1;
                            if str_loop(end) == 'P'
                                % I need to loop
                                is_par = 0;
                                par_id_counter = par_id_counter + 1;
                                lev = lev - 1;
                                trg = [];
                                sss = sss(end);
                            else
                                % I need to loop
                                if ~(c > 1 && flag_parallel(c - 1))
                                    sss = sss(end);
                                end
                                lev = lev - 1;
                            end
                            str_loop(end) = []; % close the last loop
                        end
                    end
                end
                
                flag_parallel(c) = is_par;
                
                if err_list(c) > 0
                    if ~isempty(cmd_list{c}) && (cmd_list{c}(1) ~= '#')
                        this.log.addError(sprintf('%s - cmd %03d "%s"', this.STR_ERR{abs(err_list(c))}, c, cmd_list{c}));
                    end
                end
                if err_list(c) < 0 && err_list(c) > -100
                    this.log.addWarning(sprintf('%s - cmd %03d "%s"', this.STR_ERR{abs(err_list(c))}, c, cmd_list{c}));
                end
                execution_block(c) = eb_counter;
                if ~isempty(cmd)
                    flag_push_command = any(cell2mat(strfind(this.PUSH_LIST, cmd.name{1})));
                    auto_push = auto_push && ~any(cell2mat(strfind(this.CMD_PUSHOUT.name, cmd.name{1})));
                else
                    flag_push_command = false;
                end
                eb_end = [0 cumsum(diff(execution_block) < 0)];
                last_loop = max(eb_end+1);
                if length(flag_push) < last_loop
                    flag_push(last_loop) = false;
                end
                flag_push(last_loop) = flag_push(last_loop) || flag_push_command;
                key_lev(c) = lev;
                sss_list{c} = sss;
                trg_list{c} = trg;
            end   
           
            flag_push = flag_push .* auto_push; % If in the command list PUSHOUT is present disable automatic push!
            cmd_list = cmd_list(~err_list);
            execution_block = execution_block(~err_list);
            sss_list = sss_list(~err_list);
            key_lev = key_lev(~err_list);
            if nargout > 3 && ~any(flag_parallel == 1) && eb_counter == 0 % no FOR found
                for s = 1 : numel(sss_list)
                    sss_list{s} = 1 : state.getSessionCount();
                end
            end
        end                
    end    
end
