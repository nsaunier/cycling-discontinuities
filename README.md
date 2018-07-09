# Welcome
This repository contains the SQL code and sample open data to replicate our upcoming paper on measuring the connectivity of a cycling network using discontinuity indicators. It include a step-by-step guide for that purpose. 

# Abstract
Include abstract here. TODO

# Citation
This work is currently under review in a scientific journal. If you find this work useful in your research, please consider citing for now:

    @misc{nabavi-niaki18cycling-discontinuities-git,
        Author = {Matin Nabavi Niaki and Jean-Simon Bourdeau and Luis Miranda-Moreno and Nicolas Saunier},
        Title = {Evaluation and Comparing Cycling Network Connectivity of Four Cities Using Discontinuity Indicators},
        Year = {2018},
        howpublished = {https://github.com/nsaunier/cycling-discontinuities/}
    }

# Required Software
* spatialite (optional spatialite_gui)
* text editor (e.g. Notepad++)

# Required Datasets
* Cycling network shapefile (this shapefile should have a field named facilities with the different cycling facility types)
* The cycling network in this example has already been categorized into three facility types:
    1. Separate cycling facility
    2. Painted bike lane
    3. Off-road cycling facility

# Step-by-step guide
1.	Open *spatialite_gui* and click on **Files** and **Creating a New (empty) SQLite DB**
2.	Set a name for the .sqlite file 
3.	Click on the **Load Shapefile** and select the city’s cycling network shapefile
4.  Specify the **Table name** as **bike_network**
5.	Set the **GeomColumn name** as **geom**
6.	Set the SRID as the city’s coordinate system id value (can be found here: http://spatialreference.org)
7.	Click on the  +  next to **bike_network** and right click on the **geom** icon and select **Check geometries** take note of the **Srid** and **CoordDimension** (could be XYZM, XYZ, or XY)
8.	Open the **treatment.sqlite** file with Notepad or Notepad++
9.	Replace all Srid values to the city’s 
10.	Replace all coordDimensions to the one specified in the check geometries step above
11.	Select and copy **[SECTION ONE]** from *treatment.sql* and paste it in *spatialite_gui* and click on the **Execute SQL statement**
12.	Do the same for sections two through six

       Note that in **[SECTION THREE]** you may need to change the line **JOIN (SELECT * FROM bike_network_merge)  r**  to **JOIN bike_network_merge r**  if it gives an error
13.	Once all sections are executed, refresh the **User Data** branch   
14.	Click on the **bike_network_merge_dissolve_within_2m** and right click on **geom_point** and select **export as shapefile**, and save it as *end_points.shp*

       This shapefile represents the ***end of cycling facilities***
15.	Repeat the previous step for **bike_network_merge_dissolve_within_5m**, and save as *change_points.shp*

       This shapefile contains the ***change in cycling facility type*** points

The two exported shapefiles can be opened with a spatial analyst tool (e.g. ArcGIS, QGIS) to visualize the discontinuity locations. In the spatial analyst tool, the statistical summary tool will show the total number of discontinuities for each discontinuity layer. Otherwise, the exported database table is saved as *end_points.dbf* and *change_points.dbf* with all the discontinuity points.

# Licence
This code is released under the MIT License  (refer to the LICENSE file for details).
