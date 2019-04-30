# Welcome
This repository contains the SQL code and sample open data to replicate our upcoming paper on measuring the connectivity of a cycling network using discontinuity indicators. The following discontinuities can be automatically extracted from geospatial data: the ends of cycling facilities and the changes in cycling facility type. 

This repository includes a step-by-step guide for that purpose, applied to the Montreal cycling network.

# Abstract
Include abstract here. TODO

# Citation
This work is currently under review in a scientific journal. If you find this work useful in your research, please consider citing for now:

    @misc{nabavi-niaki18cycling-discontinuities-git,
        Author = {Matin Nabavi Niaki and Jean-Simon Bourdeau and Luis Miranda-Moreno and Nicolas Saunier},
        Title = {Cycling network discontinuities as indicators for performance evaluation: Case study in four cities},
        Year = {2018},
        howpublished = {https://github.com/nsaunier/cycling-discontinuities/}
    }

# Required Software
* [SpatiaLite](https://www.gaia-gis.it/fossil/libspatialite/home) (optional with spatialite-gui)
* A text editor (e.g. Notepad++ on Windows, emacs, atom, etc.)

# Required Datasets
* Cycling network shapefile (this shapefile should have a field named facilities with the different cycling facility types)
* The cycling network in the provided examples has already been categorized into three facility types:
    1. Separate cycling facility
    2. Painted bike lane
    3. Off-road cycling facility

# Step-by-step guide 
1.	Open *spatialite-gui* and click on **Files** and **Creating a New (empty) SQLite DB**
2.	Set a name for the .sqlite file 
3.	Click on the **Load Shapefile** and select the city’s cycling network shapefile
    * for Montreal, pick the file `Existant_Reseau_cyclable_2013_polyline.shp` (**Warning**: it does not seem to work on Linux for some issues with characters, but it works with on Windows)
4.  Specify the **Table name** as **bike_network**
5.	Set the **GeomColumn name** as **geom**
6.	Set the SRID as the city’s coordinate system id value (can be found here: http://spatialreference.org) and click **Ok** to load the file
    * for Montreal, the SRID is 32188
7.	Click on the + (or arrow) next to **bike_network** and right click on the **geom** icon and select **Check geometries** take note of the **Srid** and **CoordDimension** (could be XYZM, XYZ, or XY)
    * for Montreal, the CoordDimension should be XYZM
8.	Open the **processing.sqlite** file with a text editor, e.g. Notepad++ on Windows
9.	Replace all SRID values with the correct number for the city 
10.	Replace all CoordDimensions to the one specified in the previous step check geometries (XYZM, XYZ, or XY)
11.	Select and copy **[SECTION ONE]** from *treatment.sql* and paste it in *spatialite-gui* and click on the **Execute SQL statement**
12.	Do the same for sections two through six
    * alternatively, you may try to execute the script with the command line SpatiaLite executable, e.g. for Montreal with the provided script `spatialite db-montreal.sqlite < processing-montreal.sql`
13.	Once all sections have been executed, refresh the **User Data** branch
14.	Click on the **bike_network_merge_dissolve_within_2m** and right click on **geom_point**, select **export as shapefile** and save it to the shapefile containting the ***end of cycling facilities***
15.	Repeat the previous step for **bike_network_merge_dissolve_within_5m**, and save to the shapefile containing the ***change in cycling facility type*** points

The two exported shapefiles can be opened with a spatial analyst tool (e.g. ArcGIS, QGIS) to visualize the discontinuity locations. Alternatively, the SpatiaLite databases can be open in QGIS (Browser -> SpatiaLite -> **New Connection**). In the spatial analysis tool, the statistical summary tool will show the total number of discontinuities for each discontinuity layer. Otherwise, the exported database table is saved as *end_points.dbf* and *change_points.dbf* with all the discontinuity points.

# Repository Structure and Data
Each subdirectory contains 
* the prepared shapefile for the bike network, with the facilities field and the three facility types considered in the paper
* the SQL code adapted for each city, with the proper SRID and CoordDimension
    * montreal SRID 32188 (see http://spatialreference.org/ref/epsg/32188/), shapefile available on http://donnees.ville.montreal.qc.ca/
    * portland SRID 32126 (see http://spatialreference.org/ref/epsg/32126/), shapefile available on http://gis-pdx.opendata.arcgis.com/datasets?t=transportation
    * vancouver SRID 32148 (see http://spatialreference.org/ref/epsg/32148/), shapefile available on http://data.vancouver.ca/datacatalogue
    * washington D.C. SRID 32146, (see http://spatialreference.org/ref/epsg/32146/), shapefile available on http://opendata.dc.gov
* the resulting SpatiaLite database after importing the shapefile and applying the corresponding SQL code

# Licence
This code is released under the MIT License (refer to the LICENSE file for details).
