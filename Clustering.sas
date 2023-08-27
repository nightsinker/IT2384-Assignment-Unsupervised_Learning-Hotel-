/*---------------------------------------------------------
  The options statement below should be placed
  before the data step when submitting this code.
---------------------------------------------------------*/
options VALIDMEMNAME=EXTEND VALIDVARNAME=ANY;
   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 27Aug2023:18:29:57
     Locale           : en_US
     Model Type       : Cluster
     Interval variable: star_rating
     Interval variable: travel_custer_no
     Class variable   : cust_travel_type
     Class variable   : countryRegion
     ------------------------------------------*/


   length _WARN_ $4;
   label _WARN_ = 'Warnings';
   label _CLUSTER_ID_ = 'Cluster ID';
   label _DISTANCE_ = 'Distance to Centroid';
   label _DISTANCEINT_ = 'Interval Distance to Centroid';
   label _DISTANCENOM_ = 'Nominal Distance to Centroid';

   _i_ = 0;
   _j_ = 0;
   _k_ = 0;
   _l_ = 0;
   _dist_ = 0;
   _minDist_ = 0;
   _found_ = 0;
   _unknown_ = 0;
   _unknownflag_ = 0;
   _gammaVal_ =             0.5;
   _totalMindist2cntr_ = 0;
   _missingflag4Nom_ = 0;
   _missingflag4Int_ = 0;
   _numberOfNomVars_ = 2;
   _numberOfIntVars_ = 2;
   _minDistInt_ = 0;
   _minDistNom_ = 0;
   _DISTANCEINT_ = 0;
   _DISTANCENOM_ = 0;
   label _STANDARDIZED_DISTANCE_ = 'Standardized Distance to Centroid';

   drop _i_;
   drop _j_;
   drop _k_;
   drop _l_;
   drop _dist_;
   drop _minDist_;
   drop _minDistInt_;
   drop _minDistNom_;
   drop _unknown_;
   drop _unknownflag_;
   drop _found_;
   drop _gammaVal_;
   drop _totalMindist2cntr_;
   drop _missingflag4Nom_;
   drop _missingflag4Int_;
   drop _numberOfNomVars_;
   drop _numberOfIntVars_;
   drop _intMindist2cntr_;
   drop _nomMindist2cntr_;

   array _nomVals_79{2} _temporary_;
   array _intVals_79{2} _temporary_;
   array _missingArr_79{2} _temporary_;
   array _intStdVals_79{2} _temporary_;
   array _intVars_79[2] _temporary_;
   _intVars_79[1] =
   star_rating;
   _intVars_79[2] =
   travel_custer_no;
   ********* define class variables ********;
   array _allNomVars_79 {2} $28 _temporary_ ;
   array _nomCharVars_79 {2} $28 _temporary_ ;
   length _cust_travel_type_ $28; drop _cust_travel_type_;
   _cust_travel_type_ = left(trim(put(cust_travel_type,$28.)));
   _allNomVars_79[1] =
    _cust_travel_type_ ;
   _nomCharVars_79[1] =
   cust_travel_type;
   length _countryRegion_ $18; drop _countryRegion_;
   _countryRegion_ = left(trim(put(countryRegion,$18.)));
   _allNomVars_79[2] =
    _countryRegion_ ;
   _nomCharVars_79[2] =
   countryRegion;
   array _cntrcoordsInt_79{5,2} _temporary_ (
   8.5802933088904
   4.7873510540781
   8.5276849641999
                 1
   6.0150208623092
   1.5646731571625
   6.3653985507243
   4.8514492753615
   8.2658127208474
   2.2685512367491
   );
   array _stdcntrcoordsInt_79 {5,2} _temporary_ (
    0.551801208307
    1.215061331177
     0.51227367185
    -0.99477363878
   -1.375628760283
   -0.665299430692
   -1.112370774615
    1.252461215392
    0.315514684144
   -0.254602251411
   );
   array _stdscaleInt_79 {2} _temporary_ (
   1.3309290030692
   1.7138614899156
   );
   array _stdcenterInt_79 {2} _temporary_ (
   7.8458850768259
   2.7049042306883
   );
   array _cntrcoordsNom_79{5,2} _temporary_ (
                 4
                 9
                 2
                 9
                 2
                 9
                 4
                 9
                 1
                 9
   );
   array _nomLevels_79 {2,10} $106 _temporary_ (
    'Business Travelers'
    'Couples'
    'Families with Older Children'
    'Families with Young Children'
    'Groups'
    'Solo travelers'
   ' '
   ' '
   ' '
   ' '
   ,
    'Caribbean'
    'East Asia'
    'Europe'
    'Middle East'
    'North America'
    'Oceania'
    'South America'
    'South Asia'
    'South East Asia'
    'Sub-Saharan Africa'

   );
   array _nomModeLevels_79 {2} _temporary_ (
                 2
                 9
   );
   array _nomType_79 {2} _temporary_ (
                 0
                 0
   );
   array _nomVarLevels_79 {2} _temporary_ (
                 6
                10
   );

   *************** check missing interval value ******************;
   _missingflag4Int_ = 0;
   do _i_ = 1 to _numberOfIntVars_ until(_missingflag4Int_);
      if missing( _intVars_79[_i_] ) then
         _missingflag4Int_ = 1;
   end;


   *************** check missing and unknown nominal value ******************;
   _missingflag4Nom_ = 0;
   _j_ = 1;
   do _i_ = 1 to _numberOfNomVars_;
      _missingArr_79[_i_] = 0;
      if _nomType_79[_i_] = 0 then do;
         if missing( _nomCharVars_79[_j_])  then do;
            _missingflag4Nom_ = 1;
            _missingArr_79[_i_] = 1;
         end;
         _j_ = _j_ + 1;
      end;
   end;
   if _missingflag4Int_ = 1 or _missingflag4Nom_ = 1 then
      substr(_WARN_, 1, 1) = 'M';
   *************** check unknown nominal value ******************;
   _unknownflag_ = 0;
   do _i_=1 to _numberOfNomVars_;
      _unknown_ = 1;
      do _j_=1 to _nomVarLevels_79[_i_] until (_unknown_ = 0);
         if _allNomVars_79[_i_] = _nomLevels_79[_i_, _j_] then do;
            _unknown_ = 0;
         end;
      end;
      if _missingArr_79[_i_]  then
         _unknown_ = 0;
      if _unknown_ = 1 then do;
         _unknownflag_ = 1;
      end;
   end;
   if _unknownflag_ = 1 then
      substr(_WARN_, 2, 1) = 'U';
   ********** prepare nominal variable values *********;
   do _i_=1 to _numberOfNomVars_;
      _nomVals_79[_i_] = 1.0;
      _found_=0;
      do _j_=1 to _nomVarLevels_79[_i_] until (_found_ = 1);
         if _allNomVars_79[_i_] = _nomLevels_79[_i_, _j_] then do;
            _nomVals_79[_i_] = _j_ ;
            _found_=1;
         end;
      end;
   end;
   ********** prepare interval variable values *********;
   do _i_ = 1 to _numberOfIntVars_;
      if missing (_intVars_79[_i_] ) then do;
         _intVals_79[_i_] = .;
         _intStdVals_79[_i_] = .;
      end; else do;
         if missing (_stdscaleInt_79[_i_] ) then do;
            _intStdVals_79[_i_] = ( _intVars_79[_i_] -  _stdcenterInt_79[_i_]);
         end; else do;
            _intStdVals_79[_i_] = ( _intVars_79[_i_] -  _stdcenterInt_79[_i_])
                  /  _stdscaleInt_79[_i_];
         end;
         _intVals_79[_i_] = _intVars_79[_i_];
      end;
   end;
   ****************** find the closest cluster ******************;
   if _missingflag4Int_ > 0 | _missingflag4Nom_ > 0 | _unknownflag_ = 1 then
   do;
      _CLUSTER_ID_ = .;
      _DISTANCE_ = .;
      _minDistInt_ = .;
      _minDistNom_ = .;
      _STANDARDIZED_DISTANCE_ = .;
   end;
   else
   do;
      _CLUSTER_ID_ = .;
      _minDist_ = 8.988465674E307;
      do _i_=1 to               5;
         _intMindist2cntr_ = 0;
         do _j_=1 to               2;
            _dist_ = _intStdVals_79{_j_} - _stdcntrcoordsInt_79{_i_,_j_};
            _dist_ = _dist_ ** 2;
            _intMindist2cntr_ = _intMindist2cntr_ + _dist_;
         end;
         _intMindist2cntr_ = _intMindist2cntr_ **              0.5;
         _nomMindist2cntr_ = 0;
         do _j_=1 to _numberOfNomVars_;
            if( _nomVals_79[_j_] ^= _cntrcoordsNom_79[ _i_,_j_]) then do;
               _nomMindist2cntr_ = _nomMindist2cntr_ + 1;
            end;
         end;
         _totalMindist2cntr_ = _intMindist2cntr_ **               2 + _gammaVal_ * _nomMindist2cntr_;
         if( _minDist_ > _totalMindist2cntr_) then do;
            _CLUSTER_ID_ = _i_;
            _minDist_ = _totalMindist2cntr_;
            _minDistInt_ = _intMindist2cntr_;
            _minDistNom_ = _nomMindist2cntr_;
         end;
         _STANDARDIZED_DISTANCE_ = _minDist_;
         _DISTANCEINT_ = _minDistInt_;
         _DISTANCENOM_ = _minDistNom_;
      end;
      _DISTANCE_ = 8.988465674E307;
      _i_ = _CLUSTER_ID_;
      _intMindist2cntr_ = 0;
      do _j_=1 to               2;
         _dist_ = _intVals_79{_j_} - _cntrcoordsInt_79{_i_,_j_};
         _dist_ = _dist_ ** 2;
         _intMindist2cntr_ = _intMindist2cntr_ + _dist_;
      end;
      _intMindist2cntr_ = _intMindist2cntr_ **              0.5;
      _DISTANCE_ = _intMindist2cntr_ **               2 + _gammaVal_ * _minDistNom_;
      _DISTANCEINT_ = _intMindist2cntr_;
      _DISTANCENOM_ = _minDistNom_;
   end;

if (MISSING('_CLUSTER_ID_'n))then _CLUSTER_ID_ = -1;
   /*------------------------------------------*/
   /*_VA_DROP*/ drop '_CLUSTER_ID_'n '_DISTANCE_'n '_WARN_'n '_DISTANCEINT_'n '_DISTANCENOM_'n '_STANDARDIZED_DISTANCE_'n;
      '_CLUSTER_ID__79'n='_CLUSTER_ID_'n;
'_DISTANCE__79'n='_DISTANCE_'n;
'_WARN__79'n='_WARN_'n;
'_DISTANCEINT__79'n='_DISTANCEINT_'n;
'_DISTANCENOM__79'n='_DISTANCENOM_'n;
'_STANDARDIZED_DISTANCE__79'n='_STANDARDIZED_DISTANCE_'n;
   /*------------------------------------------*/