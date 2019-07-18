
#
# File:         prepare_roms_wrf.sh
# Author:       Ueslei Adriano Sutil
# Email:        ueslei@outlook.com
# Created:      25 April 2019
# Last modfied: 18 July 2019
# Version:      1.6
#
# This script will post-process WRF-ARW and ROMS outputs using NCO and CDO
#

red=`tput setaf 1`
green=`tput setaf 2`
bg=`tput setab 7`
reset=`tput sgr0`

echo "${red}${bg}Type the project number, followed by [ENTER]:${reset}"
echo "${red}${bg}(1) SC_2008, (2) ATLEQ or (3) Antartic${reset}"
read exp

if (( $exp == 1)); then
  COADIR='/home/adriano.sutil/1_sc_2008/outputs'
  echo "${red}${bg}Type the experiment number that you want to prepare, followed by [ENTER]:${reset}"
  echo "${red}${bg}(1) normal, (2) +100%, (3) +80%, (4) +60%, (5) +40%, (6) +20%,${reset}"
  echo "${red}${bg}(7) -100%, (8) -80%, (9) -60%, (10) -40% or (11) -20%${reset}"
  read exp_number
	
  if (( $exp_number == 1)); then
    COANUM=$COADIR/normal
  elif (( $exp_number == 2)); then
    COANUM=$COADIR/warm_100
  elif (( $exp_number == 3)); then
    COANUM=$COADIR/warm_80		
  elif (( $exp_number == 4)); then
    COANUM=$COADIR/warm_60	
  elif (( $exp_number == 5)); then
    COANUM=$COADIR/warm_40
  elif (( $exp_number == 6)); then
    COANUM=$COADIR/warm_20	
  elif (( $exp_number == 7)); then
    COANUM=$COADIR/cold_100
  elif (( $exp_number == 8)); then
    COANUM=$COADIR/cold_80
  elif (( $exp_number == 9)); then
    COANUM=$COADIR/cold_60
  elif (( $exp_number == 10)); then
    COANUM=$COADIR/cold_40
  elif (( $exp_number == 11)); then
    COANUM=$COADIR/cold_20
  fi  		
fi
if (( $exp == 2)); then
  COADIR='/home/adriano.sutil/3_atleq/outputs/third_run'
  COANUM=$COADIR
fi
if (( $exp == 3)); then
  COADIR='/home/adriano.sutil/2_antartic/output'
  COANUM=$COADIR
fi

echo ${red}${bg}Will prepare data for $COANUM${reset}
echo ${green}${bg}Preparing WRF output${reset}
if (( $exp == 1)); then
  ncks -v LANDMASK,PSFC,RAINNC,RAINC,RAINSH,SST,T2,T,Times,U10,V10,U,V,W,XLAT,XLONG,PH,HGT,QVAPOR,LH,PHB,Q2,PB,P,TH2,QCLOUD,PBLH,HFX $COANUM/wrfout_d02* $COANUM/wrf_brute.nc
  ncks -v LANDMASK,RAINNC,RAINC,XLAT,XLONG,Times $COANUM/wrf_brute.nc $COANUM/wrf_rain_1.nc 
  if (( $exp_number == 1)); then
    cdo daymean $COANUM/wrf_rain_1.nc $COANUM/wrf_rain_2.nc
    cdo splitday $COANUM/wrf_rain_2.nc $COANUM/day
    rm -rf $COANUM/wrf_rain_1.nc $COANUM/wrf_rain_2.nc
    cdo cat $COANUM/day20.nc $COANUM/day21.nc $COANUM/day22.nc $COANUM/day23.nc $COANUM/day24.nc $COANUM/day25.nc $COANUM/day26.nc $COANUM/day27.nc $COANUM/wrf_rain.nc 
    rm -rf $COANUM/day*
  
    cdo splitday $COANUM/wrf_brute.nc $COANUM/day
    cdo cat $COANUM/day20.nc $COANUM/day21.nc $COANUM/day22.nc $COANUM/day23.nc $COANUM/day24.nc $COANUM/day25.nc $COANUM/day26.nc $COANUM/day27.nc $COANUM/wrf_split.nc
    rm -rf $COANUM/day*
    cdo timselmean,6 $COANUM/wrf_split.nc $COANUM/wrf_6h.nc 
    cdo timselmean,3 $COANUM/wrf_split.nc $COANUM/wrf_3h.nc  
    rm -rf $COANUM/wrf_split.nc
  fi  
fi
if (( $exp == 2)); then
  ncks -v LANDMASK,PSFC,RAINNC,RAINC,RAINSH,SST,T2,T,Times,U10,V10,U,V,W,XLAT,XLONG,PH,HGT,QVAPOR,LH,PHB,Q2,PB,P,TH2,QCLOUD,PBLH,HFX $COANUM/wrfout* $COANUM/wrf.nc
fi
if (( $exp == 3)); then
  ncks -v LANDMASK,PSFC,RAINNC,RAINC,RAINSH,SST,T2,T,Times,U10,V10,U,V,W,XLAT,XLONG,PH,HGT,QVAPOR,LH,PHB,Q2,PB,P,TH2,QCLOUD,PBLH,HFX $COANUM/wrfout* $COANUM/wrf.nc
fi

echo ${green}${bg}Preparing ROMS output${reset}
if (( $exp == 1)); then
  ncks -v temp,salt,u,v,w,latent,sensible,Pair,mask_rho,mask_u,mask_v,lat_rho,lon_rho,angle,Cs_r,hc,s_rho,Vtransform,zeta,h,salt -d s_rho,49,49 $COANUM/ocean_his.nc $COANUM/roms_brute.nc
  if (( $exp_number == 1)); then
    cdo splitday $COANUM/roms_brute.nc $COANUM/day
    cdo cat $COANUM/day21.nc $COANUM/day26.nc $COANUM/roms_21_26_days_oscar1.nc
    cdo daymean $COANUM/roms_21_26_days_oscar1.nc $COANUM/roms_21_26_days_oscar.nc
    rm -rf $COANUM/roms_21_26_days_oscar1.nc
    cdo cat $COANUM/day20.nc $COANUM/day21.nc $COANUM/day22.nc $COANUM/day23.nc $COANUM/day24.nc $COANUM/day25.nc $COANUM/day26.nc $COANUM/day27.nc $COANUM/roms_daily1.nc
    cdo daymean $COANUM/roms_daily1.nc $COANUM/roms_daily.nc 
    rm -rf $COANUM/roms_daily1.nc  $COANUM/day*
  fi  
fi
if (( $exp == 2)); then
  ncks -v temp,salt,u,v,w,latent,sensible,Pair,mask_rho,mask_u,mask_v,lat_rho,lon_rho,angle,Cs_r,hc,s_rho,Vtransform,zeta,h,salt -d s_rho,49,49 $COANUM/ocean_his.nc $COANUM/roms.nc
fi
if (( $exp == 3)); then
  ncks -v temp,salt,u,v,latent,sensible,Pair,mask_rho,mask_u,mask_v,lat_rho,lon_rho,angle,Cs_r,hc,s_rho,Vtransform,zeta,h,salt,aice,hice,iomflx -d s_rho,49,49 $COANUM/ocean_his.nc $COANUM/roms.nc
fi

echo ${green}${bg}Finished.${reset}
