/**
 * diewald_shapeFileReader.
 * 
 * a Java Library for reading ESRI-shapeFiles (*.shp, *.dfb, *.shx).
 * 
 * 
 * Copyright (c) 2012 Thomas Diewald
 *
 *
 * This source is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This code is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * A copy of the GNU General Public License is available on the World
 * Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also
 * obtain it by writing to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
package Shape;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.address.DBBean;

import diewald_shapeFile.files.dbf.DBF_Field;
import diewald_shapeFile.files.dbf.DBF_File;
import diewald_shapeFile.files.shp.SHP_File;
import diewald_shapeFile.files.shp.shapeTypes.ShpPolygon;
import diewald_shapeFile.files.shp.shapeTypes.ShpShape;
import diewald_shapeFile.files.shx.SHX_File;
import diewald_shapeFile.shapeFile.ShapeFile;

public class ShapeFileReader {

  public static void main(String[] args) {
    DBF_File.LOG_INFO           = !false;
    DBF_File.LOG_ONLOAD_HEADER  = false;
    DBF_File.LOG_ONLOAD_CONTENT = false;
    
    SHX_File.LOG_INFO           = !false;
    SHX_File.LOG_ONLOAD_HEADER  = false;
    SHX_File.LOG_ONLOAD_CONTENT = false;
    
    SHP_File.LOG_INFO           = !false;
    SHP_File.LOG_ONLOAD_HEADER  = false;
    SHP_File.LOG_ONLOAD_CONTENT = false;
	DBBean dbbean = new DBBean();
	Connection conn = dbbean.getConnection();
	StringBuffer queryInsert = new StringBuffer();
	PreparedStatement ps1 = null;
	PreparedStatement ps2 = null;
	int insertCount = 0;

    try {
      // GET DIRECTORY
      //String curDir = System.getProperty("user.dir");
      //String folder = "/Users/juhyukkim/Downloads/2013_3_3105351/";
      //String folder = "/Users/juhyukkim/Downloads/2013_2_11";
     conn.setAutoCommit(false);
		queryInsert.append(" INSERT INTO BOUNDARYCOORDINATES ( HAENG_CODE \n");
		queryInsert.append(" 						  ,ADM_CD \n");
		queryInsert.append(" 						  ,COX \n");
		queryInsert.append(" 						  ,COY \n");
		queryInsert.append(" 						  ,SEQ \n");
		queryInsert.append(" 						  ,USE_YN \n");
		queryInsert.append(" 						   ) \n");
		queryInsert.append("				   VALUES     ( ? \n");
		queryInsert.append(" 						   ,? \n");
		queryInsert.append(" 						   ,? \n");
		queryInsert.append(" 						   ,? \n");
		queryInsert.append(" 						   ,? \n");
		queryInsert.append(" 						   ,? \n");
		queryInsert.append(" 						   ) \n");
		ps2 = conn.prepareStatement(queryInsert.toString());
		/*
    	String folder = "/Users/juhyukkim/Downloads/오정구";
        
        // LOAD SHAPE FILE (.shp, .shx, .dbf)
        ShapeFile shapefile = new ShapeFile(folder, "오정구 투표구").READ();
        */
    	String folder = "/Users/juhyukkim/Downloads/양천구";
        
        // LOAD SHAPE FILE (.shp, .shx, .dbf)
        ShapeFile shapefile = new ShapeFile(folder, "양천구").READ();
      
      // TEST: printing some content
      ShpShape.Type shape_type = shapefile.getSHP_shapeType();
      System.out.println("\nshape_type = " +shape_type);
    
      int number_of_shapes = shapefile.getSHP_shapeCount();
      int number_of_fields = shapefile.getDBF_fieldCount();
      System.out.println("number_of_shapes = " +number_of_shapes);
      for(int i = 0; i < number_of_shapes; i++){
        ShpPolygon shape    = shapefile.getSHP_shape(i);
        String[] shape_info = shapefile.getDBF_record(i);
        double [][] polygon = shape.getPoints(); 
  
        ShpShape.Type type     = shape.getShapeType();
        int number_of_vertices = shape.getNumberOfPoints();
        int number_of_polygons = shape.getNumberOfParts(); 
        int record_number      = shape.getRecordNumber();
        String haengcode = shape_info[3].trim();
        String adm_cd = haengcode+"-00";
        //String adm_cd = shape_info[4].trim();
        //String haengcode = adm_cd.split("-")[0];
        //System.out.printf("\nSHAPE[%2d] - %s\n", i, type);
        //System.out.printf("  (shape-info) record_number = %3d; vertices = %6d; polygons = %2d\n", record_number, number_of_vertices, number_of_polygons);
        
        
        for(int a = 0; a<polygon.length;a++) {
			double cox = polygon[a][0];
			double coy = polygon[a][1];
			System.out.println("cox = "+cox+ ", coy = "+coy);
			ps2.setString(1, haengcode);
			ps2.setString(2, adm_cd);
			ps2.setDouble(3, cox);
			ps2.setDouble(4, coy);
			ps2.setInt(5, a+1);
			ps2.setString(6, "Y");
			
			ps2.addBatch();
			// 파라미터 Clear
			ps2.clearParameters();
			insertCount++;
			if(insertCount % 1000 == 0) {
				insertCount = 0;
				ps2.executeBatch();
                ps2.clearBatch();
                 
                // 커밋
                conn.commit() ;
			}
        	/*for(int b = 0;b<2;b++) {
        		System.out.print(polygon[a][b]+"  ");
        	}
        	System.out.println();*/
			
        }
        
        /*for(int j = 0; j < number_of_fields; j++){
          String data = shape_info[j].trim();
          DBF_Field field = shapefile.getDBF_field(j);
          String field_name = field.getName();
          System.out.printf("  (dbase-info) [%d] %s = %s", j, field_name, data);
        }
        System.out.printf("\n");*/
        
      }
		ps2.executeBatch();
		conn.commit();
		System.out.printf("end");
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

}
