
# File name:      prepare_wrf_roms_evaluation.sh
# Author:         Ueslei Adriano Sutil
# Email:          uesleisutil1@gmail.com
# Created:        12 April 2019
# Last modified:  12 April 2019
# Version:        1.1
#
# Creates NetCDF files from ROMS and WRF outputs with same 
# time-steps from the following data and reanalysis:
#    ROMS:
#         - MUR (Chin et al., 2017; https://podaac.jpl.nasa.gov/Multi-scale_Ultra-high_Resolution_MUR-SST):
#            Daily Sea Surface Temperature (°C)
#         - OSCAR (Bonjean & Lagerloef, 2002; https://podaac.jpl.nasa.gov/dataset/OSCAR_L4_OC_third-deg):
#            5 days Current Speed at surface (m.s⁻¹) 
#         - GLORYS12V1 (Fernandez & Lellouch, 2018;http://marine.copernicus.eu/services-portfolio/access-to-products/?option=com_csw&view=details&product_id=GLOBAL_REANALYSIS_PHY_001_030):
#            Sea Surface Temperature (°C) 
#            Daily Current Speed at surface (m.s⁻¹)
#    WRF:
#         - CFSR (Saha et al., 2010; https://rda.ucar.edu/datasets/ds093.0/):
#            6 hour Temperature at 2 meters height (°C);
#            6 hour Daily Wind Speed at 10 m height (m/s);
#            6 hour Sea Level Pressure (hPa);

# Prepare ROMS.
cd /media/ueslei/Ueslei/INPE/PCI/SC_2008/Outputs/normal/
ncks -v temp,u,v -d s_rho,49,49 roms.nc roms_sfc.nc
cdo splitday roms_sfc.nc day
cdo cat day21.nc day26.nc roms__21_26_days_oscar_all.nc
cdo daymean roms_21_26_days_oscar_all.nc  roms_21_26_days_oscar.nc  
cdo cat day20.nc day21.nc day22.nc day23.nc day24.nc day25.nc day26.nc day27.nc day28.nc day29.nc day30.nc roms_sfc_split.nc 
cdo daymean roms_sfc_split.nc roms_daily.nc
rm -rf day* roms_sfc.nc roms_sfc_split.nc roms_21_26_days_oscar_all.nc
mv roms_daily.nc roms_21_26_days_oscar.nc /media/ueslei/Ueslei/INPE/PCI/SC_2008/Dados/Evaluation/ROMS

# Prepare WRF.
cd /media/ueslei/Ueslei/INPE/PCI/SC_2008/Outputs/normal
cdo splitday wrf.nc day
cdo cat day20.nc day21.nc day22.nc day23.nc day24.nc day25.nc day26.nc day27.nc day28.nc day29.nc day30.nc wrf_split.nc 
cdo timselmean,6 wrf_split.nc  wrf_6h_cfsr_ori.nc
rm -rf day* wrf_split.nc  
mv wrf_6h_cfsr.nc /media/ueslei/Ueslei/INPE/PCI/SC_2008/Dados/Evaluation/WRF/
